import os
import torch
from your_model import MultilingualFashionRetrieval
from fashion_retriever import FashionRetriever, load_model_checkpoint

# -------------------- #
# 1. Load the model
# -------------------- #
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
model = load_model_checkpoint(
    MultilingualFashionRetrieval, 'checkpoint.pth', device)

# -------------------- #
# 2. Initialize retriever
# -------------------- #
retriever = FashionRetriever(model, device)

# -------------------- #
# 3. Encode products or load existing index
# -------------------- #
image_folder = 'products/images/'
metadata_file = 'products.csv'
index_file = 'products.faiss'
metadata_pkl = 'products_metadata.pkl'

if os.path.exists(index_file) and os.path.exists(metadata_pkl):
    # Load existing FAISS index and metadata
    retriever.load_index(index_file, metadata_pkl)
else:
    # List all image files
    image_files = [f for f in os.listdir(image_folder) if f.lower().endswith(
        ('jpg', 'jpeg', 'png', 'bmp', 'webp'))]

    # Automatically choose FAISS index type based on dataset size
    if len(image_files) < 10000:
        index_type = 'flat'  # Exact search
    else:
        index_type = 'ivf'   # Approximate search

    # Encode and build FAISS index
    retriever.encode_products_from_folder(
        image_folder, metadata_file, index_type=index_type)

    # Save for future use
    retriever.save_index(index_file, metadata_pkl)

# -------------------- #
# 4. Check index stats
# -------------------- #
print(retriever.get_index_stats())

# -------------------- #
# 5. Chatbot recommendations function
# -------------------- #


def get_chatbot_recommendations(query_image=None, query_text=None, top_k=5):
    if query_image and query_text:
        results = retriever.search_by_image_and_text(
            query_image, query_text, top_k)
    elif query_image:
        results = retriever.search_by_image(query_image, top_k)
    elif query_text:
        results = retriever.search_by_text(query_text, top_k)
    else:
        return []

    product_ids = [res['product'].get(
        'product_id') for res in results if 'product_id' in res['product']]
    return product_ids
