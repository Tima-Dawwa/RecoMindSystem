import asyncio
import os
from typing import List
import torch
from services.chatbot.model import MultilingualFashionRetrieval
from services.chatbot.fashion_retriever import FashionRetriever, load_model_checkpoint
from models.product import Product
from utils.database import product_collection
from PIL import Image

MODEL_PATH = 'saved_models/MultilingualFashionRetrieval/multilingual_fashion_model_final.pth'
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

model = load_model_checkpoint(
    MultilingualFashionRetrieval, MODEL_PATH, device)

retriever = FashionRetriever(model, device)


async def get_all_products() -> List[Product]:
    cursor = product_collection.find({})
    products = []
    async for doc in cursor:
        images_array = doc.get('images', [])
        if images_array:
            products.append(Product(
                id=str(doc["_id"]),
                images=images_array[0]
            ))
    return products


async def load_and_encode_data():
    image_folder = '../LogicBackend/public/'
    index_file = 'data/chatbot/products.faiss'
    metadata_pkl = 'data/chatbot/products_metadata.pkl'

    if os.path.exists(index_file) and os.path.exists(metadata_pkl):
        print("Loading existing index...")
        retriever.load_index(index_file, metadata_pkl)
    else:
        print("Index not found. Encoding products from database...")
        products_from_db = await get_all_products()

        images = []
        metadata = []
        for product in products_from_db:
            relative_image_path = product.images.lstrip('/')
            image_path = os.path.join(image_folder, relative_image_path)

            if os.path.exists(image_path):
                try:
                    img = Image.open(image_path).convert('RGB')
                    images.append(img)
                    metadata.append({'product_id': product.id})
                except Exception as e:
                    print(f"Error loading image {image_path}: {e}")

        print(len(images))
        print(len(metadata))

        # if len(images) < 10000:
        #     index_type = 'flat'
        # else:
        #     index_type = 'ivf'

        # retriever.encode_products(images, metadata, index_type=index_type)
        # retriever.save_index(index_file, metadata_pkl)

    # print(retriever.get_index_stats())

# this used for production
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

    # 💡 Corrected: Retrieve 'product_id' from the simplified metadata
    product_ids = [res['product'].get('product_id') for res in results]
    return product_ids


# this run for initial
# if __name__ == "__main__":
    # asyncio.run(load_and_encode_data())
