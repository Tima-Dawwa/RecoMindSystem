import asyncio
from sentence_transformers import SentenceTransformer
import faiss
from tqdm import tqdm
import pickle
import numpy as np
import pandas as pd
from models.product import Product
from services.database import product_collection
from typing import List

# ----- CONFIG -----
BATCH_SIZE = 1000
MODEL_NAME = "all-MiniLM-L6-v2"
FAISS_INDEX_FILE = "data/product_index_hnsw.faiss"
EMBEDDING_STORE_FILE = "data/product_embeddings.pkl"
ID_MAPPING_FILE = "data/id_mapping.pkl"

# ----- SETUP -----
# model = SentenceTransformer(MODEL_NAME)
# model.save("saved_models/all-MiniLM-L6-v2")

model = SentenceTransformer("saved_models/all-MiniLM-L6-v2")

# ----- BUILD INDEX -----
embedding_dim = model.get_sentence_embedding_dimension()
hnsw_index = faiss.IndexHNSWFlat(embedding_dim, 32)
hnsw_index.hnsw.efConstruction = 200
index = faiss.IndexIDMap(hnsw_index)


# ----- Get All -----------
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


# ----- COMBINE FEATURES -----


def combine_features(product) -> str:
    """
    Combine various product attributes into a single string for embedding.
    Converts all text to lowercase.
    """
    return " ".join([
        product.get('name', ''),
        product.get('type', ''),
        product.get('appearance', ''),
        product.get('color', ''),
        product.get('department', ''),
        product.get('gender', ''),
        product.get('details', '')
    ]).lower()

# ----- BUILD FAISS INDEX FUNCTION -----


def build_faiss_index_for_products(product_data: pd.DataFrame, index_filename='product_faiss.index'):
    """
    Build FAISS index for product descriptions and save it to a file.

    Parameters:
    - product_data: pandas DataFrame containing product IDs and their descriptions
    - text_col: the column name containing product descriptions (default: 'description')
    - model_name: name of the pre-trained Sentence-Transformer model (default: 'all-MiniLM-L6-v2')
    - index_filename: filename to save the FAISS index (default: 'product_faiss.index')

    Returns:
    - index: FAISS index object containing the product embeddings
    """

    # Initialize the index and mapping
    all_embeddings = {}
    id_mapping = {}  # int_id -> ObjectId
    reverse_id_mapping = {}  # ObjectId -> int_id for quick lookup
    int_counter = 1  # ID counter for FAISS

    # Process the products in batches
    batch, ids = [], []

    # Iterate through the product data
    for idx, row in tqdm(product_data.iterrows(), total=len(product_data), desc="Embedding Products"):
        try:
            # Combine features into a single text string
            product_text = combine_features(row)
            batch.append(product_text)

            # Use integer ID for FAISS and map it to ObjectId
            int_id = int_counter
            ids.append(int_id)
            id_mapping[int_id] = row['id']  # BSON ObjectId to int_id mapping
            # reverse map for later retrieval
            reverse_id_mapping[row['id']] = int_id

            int_counter += 1

            # Process the batch when it reaches the defined batch size
            if len(batch) >= BATCH_SIZE:
                process_batch(batch, ids, model, index, all_embeddings)
                batch, ids = [], []  # Reset batch and ids after processing
        except Exception as e:
            print(f"Skipping product {row['id']} due to error: {e}")

    # Process the last batch (if any)
    if batch:
        process_batch(batch, ids, model, index, all_embeddings)

    # Save the FAISS index
    faiss.write_index(index, index_filename)
    print(f"✅ FAISS index saved to: {index_filename}")

    # Save the embeddings (optional)
    with open(EMBEDDING_STORE_FILE, "wb") as f:
        pickle.dump(all_embeddings, f)
    print(f"✅ Embeddings saved to: {EMBEDDING_STORE_FILE}")

    # Save ID mappings
    with open(ID_MAPPING_FILE, "wb") as f:
        pickle.dump(id_mapping, f)
    print(f"✅ ID Mapping saved to: {ID_MAPPING_FILE}")

    # Save reverse ID mapping (ObjectId -> int_id)
    with open("data/reverse_id_mapping.pkl", "wb") as f:
        pickle.dump(reverse_id_mapping, f)
    print(f"✅ Reverse ID Mapping saved.")

    return index


def process_batch(batch, ids, model, index, all_embeddings):
    """
    Process a batch of product descriptions, compute embeddings, and add them to the FAISS index.
    """
    embeddings = model.encode(batch, convert_to_numpy=True)
    embeddings = np.array(embeddings).astype("float32")
    id_array = np.array(ids).astype("int64")

    # Store embeddings
    for i, emb in zip(ids, embeddings):
        all_embeddings[i] = emb

    # Add to FAISS index
    index.add_with_ids(embeddings, id_array)


# How to run


async def main():
    products = await get_all_products()
    # Convert list of Product objects to DataFrame
    df = pd.DataFrame([vars(p) for p in products])
    build_faiss_index_for_products(df, index_filename=FAISS_INDEX_FILE)

# Run the async main function
asyncio.run(main())
