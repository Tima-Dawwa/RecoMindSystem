from typing import List, Union
import torch
import torch.nn as nn
import torch.nn.functional as F
from transformers import AutoModel, AutoTokenizer, Blip2Model, Blip2Processor
from langdetect import detect, LangDetectException
import re
from PIL import Image


BLIP2_PATH = 'saved_models/MultilingualFashionRetrieval/blip2-opt-2.7b'
ARABERT_PATH = 'saved_models/MultilingualFashionRetrieval/arabertv2'
BERT_EN_PATH = 'saved_models/MultilingualFashionRetrieval/bert-base-uncased'


class MultilingualFashionRetrieval(nn.Module):
    def __init__(self, embed_dim=512, dropout=0.1):
        super().__init__()

        self.ar_text_tokenizer = AutoTokenizer.from_pretrained(ARABERT_PATH)
        self.ar_text_encoder = AutoModel.from_pretrained(ARABERT_PATH)

        self.en_text_tokenizer = AutoTokenizer.from_pretrained(BERT_EN_PATH)
        self.en_text_encoder = AutoModel.from_pretrained(BERT_EN_PATH)

        self.blip2_processor = Blip2Processor.from_pretrained(BLIP2_PATH)
        self.blip2_model = Blip2Model.from_pretrained(
            BLIP2_PATH).to(dtype=torch.float32)
        self.blip2_model.language_model = None

        for param in self.ar_text_encoder.parameters():
            param.requires_grad = False
        for param in self.en_text_encoder.parameters():
            param.requires_grad = False
        for param in self.blip2_model.parameters():
            param.requires_grad = False

        ar_text_dim = self.ar_text_encoder.config.hidden_size
        en_text_dim = self.en_text_encoder.config.hidden_size
        blip2_dim = self.blip2_model.config.qformer_config.hidden_size

        self.ar_text_projection = nn.Sequential(
            nn.Linear(ar_text_dim, embed_dim),
            nn.LayerNorm(embed_dim),
            nn.Dropout(dropout)
        )

        self.en_text_projection = nn.Sequential(
            nn.Linear(en_text_dim, embed_dim),
            nn.LayerNorm(embed_dim),
            nn.Dropout(dropout)
        )

        self.image_projection = nn.Sequential(
            nn.Linear(blip2_dim, embed_dim),
            nn.LayerNorm(embed_dim),
            nn.Dropout(dropout)
        )

        self.fusion_layer = nn.Sequential(
            nn.Linear(embed_dim * 2, embed_dim * 2),
            nn.ReLU(),
            nn.Dropout(dropout),
            nn.Linear(embed_dim * 2, embed_dim),
            nn.LayerNorm(embed_dim)
        )

        self.embed_dim = embed_dim
        self._init_weights()

        total_params = sum(p.numel() for p in self.parameters())
        trainable_params = sum(p.numel()
                               for p in self.parameters() if p.requires_grad)
        print(f"Total parameters: {total_params:,}")
        print(
            f"Trainable parameters: {trainable_params:,} ({trainable_params / total_params:.1%})")
        print(f"Frozen parameters: {total_params - trainable_params:,}")

    def _init_weights(self):
        for module in [self.ar_text_projection, self.en_text_projection,
                       self.image_projection, self.fusion_layer]:
            for layer in module:
                if isinstance(layer, nn.Linear):
                    nn.init.xavier_uniform_(layer.weight)
                    if layer.bias is not None:
                        nn.init.zeros_(layer.bias)

    def detect_language(self, text: str) -> str:
        try:
            arabic_pattern = re.compile(
                r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]')
            if arabic_pattern.search(text):
                return 'ar'
            detected = detect(text)
            return 'ar' if detected == 'ar' else 'en'
        except (LangDetectException, Exception):
            arabic_chars = len(re.findall(r'[\u0600-\u06FF]', text))
            total_chars = len(re.sub(r'\s+', '', text))
            return 'ar' if total_chars > 0 and arabic_chars / total_chars > 0.3 else 'en'

    def encode_text(self, texts: List[str]) -> torch.Tensor:
        if not texts:
            return torch.empty(0, self.embed_dim, device=self.device)

        ar_texts = []
        en_texts = []
        ar_indices = []
        en_indices = []

        for i, text in enumerate(texts):
            lang = self.detect_language(text)
            if lang == 'ar':
                ar_texts.append(text)
                ar_indices.append(i)
            else:
                en_texts.append(text)
                en_indices.append(i)

        all_embeds = torch.zeros(
            len(texts), self.embed_dim, device=self.device)

        if ar_texts:
            ar_inputs = self.ar_text_tokenizer(
                ar_texts, padding=True, truncation=True,
                max_length=128, return_tensors='pt'
            )
            ar_inputs = {k: v.to(self.device) for k, v in ar_inputs.items()}

            with torch.no_grad():
                ar_outputs = self.ar_text_encoder(**ar_inputs)
                ar_features = ar_outputs.last_hidden_state[:, 0, :]

            ar_embeds = self.ar_text_projection(ar_features)
            ar_embeds = F.normalize(ar_embeds, dim=-1)

            for i, embed in enumerate(ar_embeds):
                all_embeds[ar_indices[i]] = embed

        if en_texts:
            en_inputs = self.en_text_tokenizer(
                en_texts, padding=True, truncation=True,
                max_length=128, return_tensors='pt'
            )
            en_inputs = {k: v.to(self.device) for k, v in en_inputs.items()}

            with torch.no_grad():
                en_outputs = self.en_text_encoder(**en_inputs)
                en_features = en_outputs.last_hidden_state[:, 0, :]

            en_embeds = self.en_text_projection(en_features)
            en_embeds = F.normalize(en_embeds, dim=-1)

            for i, embed in enumerate(en_embeds):
                all_embeds[en_indices[i]] = embed

        return all_embeds

    def encode_text_batch(self, input_ids, attention_mask, lang):
        input_ids = input_ids.to(self.device)
        attention_mask = attention_mask.to(self.device)

        if lang == 'ar':
            outputs = self.ar_text_encoder(
                input_ids=input_ids, attention_mask=attention_mask)
            features = outputs.last_hidden_state[:, 0, :]
            projected = self.ar_text_projection(features)
        else:
            outputs = self.en_text_encoder(
                input_ids=input_ids, attention_mask=attention_mask)
            features = outputs.last_hidden_state[:, 0, :]
            projected = self.en_text_projection(features)

        return F.normalize(projected, dim=-1)

    def encode_image(self, images: Union[List[Image.Image], torch.Tensor]) -> torch.Tensor:
        if isinstance(images, list) and isinstance(images[0], Image.Image):
            inputs = self.blip2_processor(images=images, return_tensors="pt")
            pixel_values = inputs['pixel_values'].to(self.device)
        else:
            pixel_values = images.to(self.device)

        with torch.no_grad():
            vision_outputs = self.blip2_model.vision_model(
                pixel_values=pixel_values)
            image_embeds = vision_outputs.last_hidden_state

            query_tokens = self.blip2_model.query_tokens.expand(
                image_embeds.shape[0], -1, -1)
            query_outputs = self.blip2_model.qformer(
                query_embeds=query_tokens,
                encoder_hidden_states=image_embeds,
                encoder_attention_mask=torch.ones(
                    image_embeds.size()[:-1], dtype=torch.long, device=self.device)
            )
            features = query_outputs.last_hidden_state.mean(dim=1)

        image_embeds = self.image_projection(features)
        return F.normalize(image_embeds, dim=-1)

    def encode_multimodal(self, texts: List[str], images: Union[List[Image.Image], torch.Tensor]) -> torch.Tensor:
        text_embeds = self.encode_text(texts)
        image_embeds = self.encode_image(images)

        combined = torch.cat([text_embeds, image_embeds], dim=-1)
        multimodal_embeds = self.fusion_layer(combined)
        return F.normalize(multimodal_embeds, dim=-1)

    @property
    def device(self):
        return next(self.parameters()).device
