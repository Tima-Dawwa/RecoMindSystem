import asyncio
from sentence_transformers import SentenceTransformer
import faiss
from tqdm import tqdm
import pickle
import numpy as np
import pandas as pd
from models.product import Product
from utils.database import product_collection
from typing import List

BATCH_SIZE = 1000
MODEL_NAME = "all-MiniLM-L6-v2"
FAISS_INDEX_FILE = "data/product_index_hnsw.faiss"
EMBEDDING_STORE_FILE = "data/product_embeddings.pkl"
ID_MAPPING_FILE = "data/id_mapping.pkl"

# ----- SETUP -----
# model = SentenceTransformer(MODEL_NAME)
# model.save("saved_models/all-MiniLM-L6-v2")

model = SentenceTransformer("saved_models/all-MiniLM-L6-v2")

embedding_dim = model.get_sentence_embedding_dimension()
hnsw_index = faiss.IndexHNSWFlat(embedding_dim, 32)
hnsw_index.hnsw.efConstruction = 200
index = faiss.IndexIDMap(hnsw_index)


async def get_all_products() -> List[Product]:
    cursor = product_collection.find({})
    products = []
    async for doc in cursor:
        products.append(Product(
            id=str(doc["_id"]),
            name=doc.get("name", ""),
            type=doc.get("type", ""),
            appearance=doc.get("appearance", ""),
            color=doc.get("color", ""),
            department=doc.get("department", ""),
            gender=doc.get("gender", ""),
            details=doc.get("details", "")
        ))
    return products


def combine_features(product) -> str:
    return " ".join([
        product.get('name', ''),
        product.get('type', ''),
        product.get('appearance', ''),
        product.get('color', ''),
        product.get('department', ''),
        product.get('gender', ''),
        product.get('details', '')
    ]).lower()



def build_faiss_index_for_products(product_data: pd.DataFrame, index_filename='product_faiss.index'):
    all_embeddings = {}
    id_mapping = {}
    reverse_id_mapping = {}
    int_counter = 1

    batch, ids = [], []

    for idx, row in tqdm(product_data.iterrows(), total=len(product_data), desc="Embedding Products"):
        try:
            product_text = combine_features(row)
            batch.append(product_text)

            int_id = int_counter
            ids.append(int_id)
            id_mapping[int_id] = row['id']
            reverse_id_mapping[row['id']] = int_id

            int_counter += 1

            if len(batch) >= BATCH_SIZE:
                process_batch(batch, ids, model, index, all_embeddings)
                batch, ids = [], []
        except Exception as e:
            print(f"Skipping product {row['id']} due to error: {e}")

    if batch:
        process_batch(batch, ids, model, index, all_embeddings)

    faiss.write_index(index, index_filename)
    print(f"FAISS index saved to: {index_filename}")

    with open(EMBEDDING_STORE_FILE, "wb") as f:
        pickle.dump(all_embeddings, f)
    print(f" Embeddings saved to: {EMBEDDING_STORE_FILE}")

    with open(ID_MAPPING_FILE, "wb") as f:
        pickle.dump(id_mapping, f)
    print(f" ID Mapping saved to: {ID_MAPPING_FILE}")

    with open("data/reverse_id_mapping.pkl", "wb") as f:
        pickle.dump(reverse_id_mapping, f)
    print(f" Reverse ID Mapping saved.")

    return index


def process_batch(batch, ids, model, index, all_embeddings):
    embeddings = model.encode(batch, convert_to_numpy=True)
    embeddings = np.array(embeddings).astype("float32")
    id_array = np.array(ids).astype("int64")

    for i, emb in zip(ids, embeddings):
        all_embeddings[i] = emb

    index.add_with_ids(embeddings, id_array)




async def main():
    products = await get_all_products()
    df = pd.DataFrame([vars(p) for p in products])
    build_faiss_index_for_products(df, index_filename=FAISS_INDEX_FILE)

asyncio.run(main())
