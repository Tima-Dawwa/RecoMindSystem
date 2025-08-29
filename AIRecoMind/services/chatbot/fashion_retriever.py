import torch
import torch.nn.functional as F
from PIL import Image
from typing import List, Dict, Optional
from tqdm import tqdm
import numpy as np
import faiss
import pickle


class FashionRetriever:
    # ------------------------------------------------- #
    def __init__(self, model, device):
        self.model = model
        self.device = device
        self.model.eval()

        self.index = None
        self.products = None
        self.embed_dim = model.embed_dim
    # ------------------------------------------------- #

    def encode_products(self, images: List[Image.Image], metadata: Optional[List[Dict]] = None,
                        batch_size: int = 32, index_type: str = 'flat'):
        print(f"Encoding {len(images)} product images...")

        all_embeddings = []

        with torch.no_grad():
            for i in tqdm(range(0, len(images), batch_size), desc="Encoding products"):
                batch_images = images[i:i+batch_size]
                img_emb = self.model.encode_image(batch_images)
                img_emb = F.normalize(img_emb, dim=-1)
                all_embeddings.append(img_emb.cpu().numpy())

        embeddings = np.concatenate(all_embeddings, axis=0).astype('float32')

        self._build_faiss_index(embeddings, index_type)

        self.products = []
        for i in range(len(images)):
            product = {'index': i, 'image': images[i]}
            if metadata and i < len(metadata):
                product.update(metadata[i])
            self.products.append(product)

        print(
            f"Successfully built FAISS index with {len(self.products)} products")
        print(f"Index type: {type(self.index).__name__}")
    # ------------------------------------------------- #

    def add_batch_to_index(self, images: List[Image.Image], descriptions: List[str], metadata: List[dict]):
        with torch.no_grad():
            with torch.amp.autocast('cuda'):
                img_emb = self.model.encode_image(images)
                text_emb = self.model.encode_text(
                    descriptions)

            img_emb = img_emb.cpu().numpy().astype('float32')
            text_emb = text_emb.cpu().numpy().astype('float32')

        all_embeddings = []
        all_metadata = []
        for i in range(len(images)):
            all_embeddings.append(img_emb[i])
            all_embeddings.append(text_emb[i])
            all_metadata.append(metadata[i])
            all_metadata.append(metadata[i])

        all_embeddings = np.array(all_embeddings).astype('float32')

        if self.index is None:
            self._build_faiss_index(all_embeddings, index_type='flat')
            self.products = all_metadata.copy()
        else:
            self.index.add(all_embeddings)
            self.products.extend(all_metadata)

    # ------------------------------------------------- #

    def _build_faiss_index(self, embeddings: np.ndarray, index_type: str = 'flat'):
        if index_type == 'flat':
            self.index = faiss.IndexFlatIP(self.embed_dim)

        elif index_type == 'ivf':
            nlist = min(100, len(embeddings) // 100)
            quantizer = faiss.IndexFlatIP(self.embed_dim)
            self.index = faiss.IndexIVFFlat(quantizer, self.embed_dim, nlist)

            print("Training IVF index...")
            self.index.train(embeddings)
            self.index.nprobe = 10

        else:
            raise ValueError(f"Unknown index_type: {index_type}")

        self.index.add(embeddings)
        print(f"Added {embeddings.shape[0]} embeddings to FAISS index")
    # ------------------------------------------------- #

    def search_by_text(self, query_text: str, top_k: int = 10) -> List[Dict]:
        if self.index is None:
            raise ValueError(
                "Products not encoded. Call encode_products() first.")

        with torch.no_grad():
            text_embed = self.model.encode_text([query_text])
            text_embed = F.normalize(text_embed, dim=-1)
            query_vector = text_embed.cpu().numpy().astype('float32')

        similarities, indices = self.index.search(query_vector, top_k)

        results = []
        for i, (sim, idx) in enumerate(zip(similarities[0], indices[0])):
            if idx != -1:
                results.append({
                    'product': self.products[idx],
                    'similarity': float(sim),
                    'rank': i + 1
                })

        return results
    # ------------------------------------------------- #

    def search_by_image(self, query_image: Image.Image, top_k: int = 10) -> List[Dict]:
        if self.index is None:
            raise ValueError(
                "Products not encoded. Call encode_products() first.")

        with torch.no_grad():
            image_embed = self.model.encode_image([query_image])
            image_embed = F.normalize(image_embed, dim=-1)
            query_vector = image_embed.cpu().numpy().astype('float32')

        similarities, indices = self.index.search(query_vector, top_k)

        results = []
        for i, (sim, idx) in enumerate(zip(similarities[0], indices[0])):
            if idx != -1:
                results.append({
                    'product': self.products[idx],
                    'similarity': float(sim),
                    'rank': i + 1
                })

        return results
    # ------------------------------------------------- #

    def search_by_image_and_text(self, query_image: Image.Image, query_text: str,
                                 top_k: int = 10, alpha: float = 0.7) -> List[Dict]:

        if self.index is None:
            raise ValueError(
                "Products not encoded. Call encode_products() first.")

        with torch.no_grad():
            image_emb = F.normalize(
                self.model.encode_image([query_image]), dim=-1)
            text_emb = F.normalize(
                self.model.encode_text([query_text]), dim=-1)

            multimodal_emb = F.normalize(
                alpha * image_emb + (1 - alpha) * text_emb, dim=-1)
            query_vector = multimodal_emb.cpu().numpy().astype('float32')

        similarities, indices = self.index.search(query_vector, top_k)

        results = []
        for i, (sim, idx) in enumerate(zip(similarities[0], indices[0])):
            if idx != -1:
                results.append({
                    'product': self.products[idx],
                    'similarity': float(sim),
                    'rank': i + 1
                })

        return results
    # ------------------------------------------------- #

    def get_product_count(self) -> int:
        return len(self.products) if self.products else 0
    # ------------------------------------------------- #

    def save_index(self, index_path: str, metadata_path: str):
        if self.index is None:
            raise ValueError("No index to save")

        faiss.write_index(self.index, index_path)

        with open(metadata_path, 'wb') as f:
            pickle.dump(self.products, f)

        print(f"FAISS index saved to {index_path}")
        print(f"Product metadata saved to {metadata_path}")
    # ------------------------------------------------- #

    def load_index(self, index_path: str, metadata_path: str):
        self.index = faiss.read_index(index_path)

        with open(metadata_path, 'rb') as f:
            self.products = pickle.load(f)

        print(f"FAISS index loaded from {index_path}")
        print(f"Product metadata loaded from {metadata_path}")
        print(f"Ready to search {len(self.products)} products")
    # ------------------------------------------------- #

    def get_index_stats(self) -> Dict:
        if self.index is None:
            return {'status': 'No index built'}

        return {
            'total_vectors': self.index.ntotal,
            'dimension': self.index.d,
            'index_type': type(self.index).__name__,
            'is_trained': getattr(self.index, 'is_trained', True),
            'memory_usage_mb': self.index.ntotal * self.index.d * 4 / (1024 * 1024)
        }
    # ------------------------------------------------- #


def load_model_checkpoint(model_class, checkpoint_path: str, device: torch.device, **model_kwargs):
    model = model_class(**model_kwargs)
    checkpoint = torch.load(checkpoint_path, map_location=device)

    if 'model_state_dict' in checkpoint:
        model.load_state_dict(checkpoint['model_state_dict'])
    else:
        model.load_state_dict(checkpoint)

    model.to(device)
    model.eval()
    print(f"Model loaded from {checkpoint_path}")
    return model
