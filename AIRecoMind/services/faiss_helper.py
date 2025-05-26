import numpy as np
import faiss
import pickle
from sentence_transformers import SentenceTransformer
import os
from typing import List

# ----- CONFIG -----
BATCH_SIZE = 1000
MODEL_NAME = "all-MiniLM-L6-v2"
FAISS_INDEX_FILE = "data/product_index_hnsw.faiss"
EMBEDDING_STORE_FILE = "data/product_embeddings.pkl"
ID_MAPPING_FILE = "data/id_mapping.pkl"
REVERSE_ID_MAPPING_FILE = "data/reverse_id_mapping.pkl"

# Load model once
model = SentenceTransformer(MODEL_NAME)

# Global shared objects
index = None
all_embeddings = {}
id_mapping = {}
reverse_id_mapping = {}
int_counter = 1


def load_index_and_mappings():
    global index, all_embeddings, id_mapping, reverse_id_mapping, int_counter

    if os.path.exists(FAISS_INDEX_FILE):
        index = faiss.read_index(FAISS_INDEX_FILE)
    else:
        raise FileNotFoundError("FAISS index file not found.")

    with open(EMBEDDING_STORE_FILE, "rb") as f:
        all_embeddings = pickle.load(f)

    with open(ID_MAPPING_FILE, "rb") as f:
        id_mapping = pickle.load(f)

    with open(REVERSE_ID_MAPPING_FILE, "rb") as f:
        reverse_id_mapping = pickle.load(f)

    if id_mapping:
        int_counter = max(id_mapping.keys()) + 1
    else:
        int_counter = 1


# Load once on script start
load_index_and_mappings()


def embed_text(text: str):
    embedding = model.encode([text], convert_to_numpy=True)
    return np.array(embedding).astype("float32")[0]


def add_embedding_to_index(embedding, int_id):
    index.add_with_ids(np.array([embedding]), np.array([int_id]))


def update_embeddings_store(int_id, embedding):
    all_embeddings[int_id] = embedding


def update_id_mappings(int_id, product_id):
    id_mapping[int_id] = product_id
    reverse_id_mapping[product_id] = int_id


def save_to_index_file():
    faiss.write_index(index, FAISS_INDEX_FILE)

    with open(EMBEDDING_STORE_FILE, "wb") as f:
        pickle.dump(all_embeddings, f)

    with open(ID_MAPPING_FILE, "wb") as f:
        pickle.dump(id_mapping, f)

    with open(REVERSE_ID_MAPPING_FILE, "wb") as f:
        pickle.dump(reverse_id_mapping, f)


def search_product_by_text(query_text: str, top_k: int = 5, exclude_ids: List[str] = []):
    query_embedding = embed_text(query_text)
    distances, indices = index.search(
        np.array([query_embedding]), top_k + len(exclude_ids))

    results = []
    for dist, idx in zip(distances[0], indices[0]):
        if idx in id_mapping:
            product_id = id_mapping[idx]
            if product_id not in exclude_ids:
                results.append(product_id)
            if len(results) >= top_k:
                break
    return results


def delete_product_from_index(product_id: str):
    if product_id not in reverse_id_mapping:
        print(f"Product {product_id} not found in the index.")
        return

    int_id = reverse_id_mapping[product_id]
    index.remove_ids(np.array([int_id], dtype=np.int64))

    all_embeddings.pop(int_id, None)
    id_mapping.pop(int_id, None)
    reverse_id_mapping.pop(product_id, None)

    save_to_index_file()
    print(
        f"Product {product_id} has been successfully deleted from the index.")


def add_product_to_index(product_id: str, combined_text: str):
    global int_counter

    embedding = embed_text(combined_text)
    int_id = int_counter
    int_counter += 1

    add_embedding_to_index(embedding, int_id)
    update_embeddings_store(int_id, embedding)
    update_id_mappings(int_id, product_id)
    save_to_index_file()

    print(f"Added product {product_id} as int ID {int_id} to FAISS index.")
