from tqdm import tqdm
import numpy as np
import pandas as pd
import faiss
from sentence_transformers import SentenceTransformer


# ----- CONFIG -----
BATCH_SIZE = 1000
MODEL_NAME = "all-MiniLM-L6-v2"
FAISS_INDEX_FILE = "data/product_index_hnsw.faiss"
EMBEDDING_STORE_FILE = "data/product_embeddings.pkl"
ID_MAPPING_FILE = "data/id_mapping.pkl"

# model = SentenceTransformer('saved_models/all-MiniLM-L6-v2')
model = SentenceTransformer('MODEL_NAME')


def load_index_and_mappings():
    pass


def embed_text(text: str, model):
    pass


def get_next_int_id(current_counter: int):
    pass


def add_embedding_to_index(index, embedding, int_id):
    pass


def update_embeddings_store(all_embeddings, int_id, embedding):
    pass


def update_id_mappings(id_mapping, reverse_id_mapping, int_id, product_id):
    pass


def save_to_index_file(index, all_embeddings, id_mapping, reverse_id_mapping):
    pass


async def add_product_to_index(product_id: str, combined_text: str):
    index, all_embeddings, id_mapping, reverse_id_mapping, int_counter = load_index_and_mappings()
    embedding = embed_text(combined_text, model)
    int_id = get_next_int_id(int_counter)
    add_embedding_to_index(index, embedding, int_id)
    update_embeddings_store(all_embeddings, int_id, embedding)
    update_id_mappings(id_mapping, reverse_id_mapping, int_id, product_id)
    save_to_index_file(index, all_embeddings, id_mapping, reverse_id_mapping)
    print(f"Added product {product_id} as int ID {int_id} to FAISS index.")
