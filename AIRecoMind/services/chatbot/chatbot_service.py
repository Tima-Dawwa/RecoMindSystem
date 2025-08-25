import asyncio
import os
from concurrent.futures import ThreadPoolExecutor
from typing import List, Tuple
from PIL import Image
import torch
from tqdm import tqdm

from services.chatbot.model import MultilingualFashionRetrieval
from services.chatbot.fashion_retriever import FashionRetriever, load_model_checkpoint
from models.product import Product
from utils.database import product_collection

# ---------------- CONFIG ---------------- #
MODEL_PATH = 'saved_models/MultilingualFashionRetrieval/multilingual_fashion_model_final.pth'
IMAGE_FOLDER = '../LogicBackend/public/'
INDEX_FILE = 'data/chatbot/products.faiss'
METADATA_FILE = 'data/chatbot/products_metadata.pkl'

BATCH_SIZE = 24
MAX_WORKERS = 8

device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
model = load_model_checkpoint(MultilingualFashionRetrieval, MODEL_PATH, device)
retriever = FashionRetriever(model, device)

executor = ThreadPoolExecutor(max_workers=MAX_WORKERS)


# ----------------------------------
TRAINED_CATEGORIES = {
    'Trousers', 'Dress', 'Sweater', 'T-shirt', 'Top', 'Blouse',
    'Jacket', 'Shorts', 'Shirt', 'Vest top', 'Skirt', 'Hoodie',
    'Leggings/Tights', 'Cardigan', 'Jumpsuit/Playsuit', 'Blazer',
    'Coat', 'Polo shirt', 'Dungarees', 'Night gown', 'Robe',
    'Outdoor Waistcoat', 'Outdoor trousers', 'Tailored Waistcoat',
    'Outdoor overall', 'Pyjama set', 'Pyjama jumpsuit/playsuit',
    'Pyjama bottom'
}


async def get_all_products() -> List[Product]:
    cursor = product_collection.find({
        "type": {"$in": list(TRAINED_CATEGORIES)}
    }, {"images": 1, "details": 1})

    products = []
    async for doc in cursor:
        images_array = doc.get('images', [])
        if images_array:
            products.append(
                Product(id=str(doc["_id"]), images=images_array[0],
                        details=doc.get('details', ''))
            )
    return products


def load_image(image_path: str):
    try:
        return Image.open(image_path).convert('RGB')
    except Exception as e:
        print(f"Error loading {image_path}: {e}")
        return None


async def load_images_async(paths: List[str]) -> Tuple[List[Image.Image], List[int]]:
    loop = asyncio.get_running_loop()
    results = await asyncio.gather(*(loop.run_in_executor(executor, load_image, p) for p in paths))

    valid_images = []
    valid_indices = []
    for i, img in enumerate(results):
        if img is not None:
            valid_images.append(img)
            valid_indices.append(i)

    return valid_images, valid_indices


# ---------------------------------- (initial)
async def encode_and_save_batches():
    products = await get_all_products()

    if os.path.exists(INDEX_FILE) and os.path.exists(METADATA_FILE):
        retriever.load_index(INDEX_FILE, METADATA_FILE)
        start_idx = len(retriever.products) // 2
        print(f"Resuming from product {start_idx}")
    else:
        retriever.index = None
        retriever.products = []
        start_idx = 0

    for start in tqdm(range(start_idx, len(products), BATCH_SIZE), desc="Processing batches"):
        batch = products[start:start + BATCH_SIZE]
        image_paths = [os.path.join(
            IMAGE_FOLDER, p.images.lstrip('/')) for p in batch]

        images, valid_indices = await load_images_async(image_paths)
        descriptions = [batch[i].details for i in valid_indices]
        batch_metadata = [{'product_id': batch[i].id} for i in valid_indices]

        if images:
            retriever.add_batch_to_index(
                images, descriptions, batch_metadata)
            retriever.save_index(INDEX_FILE, METADATA_FILE)
            print(
                f"Batch {start}-{start+len(batch)} saved. Valid images: {len(images)}/{len(batch)}")

        if start % (BATCH_SIZE * 10) == 0:
            torch.cuda.empty_cache()


# ---------------------------------- (main function used in back)
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

    return [res['product'].get('product_id') for res in results]


# ---------------------------------- (here run only once)
if __name__ == "__main__":
    asyncio.run(encode_and_save_batches())
