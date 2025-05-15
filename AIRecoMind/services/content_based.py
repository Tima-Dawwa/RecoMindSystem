import numpy as np
from models.product import Product
from services.database import product_collection
from services.faiss_helper import add_product_to_index, search_product_by_text
from typing import Any, Dict, List
from bson import ObjectId


def combine_features(product: Product) -> str:
    return " ".join([
        product.name,
        product.type,
        product.appearance,
        product.color,
        product.department,
        product.gender,
        product.details
    ]).lower()


async def get_product_by_id(product_id: str) -> Product:
    doc = await product_collection.find_one({"_id": ObjectId(product_id)})
    return Product(
        id=str(doc["_id"]),
        name=doc.get("name", ""),
        type=doc.get("type", ""),
        appearance=doc.get("appearance", ""),
        color=doc.get("color", ""),
        department=doc.get("department", ""),
        gender=doc.get("gender", ""),
        details=doc.get("details", "")
    )


async def get_content_based_recommendations(product_id: str, top_n: int = 3) -> List[str]:
    product = await get_product_by_id(product_id)
    combined_text = combine_features(product)
    recommended_products = search_product_by_text(combined_text, top_k=top_n)
    return recommended_products


async def add_product(product_id: str):
    product = await get_product_by_id(product_id)
    combined_text = combine_features(product)
    add_product_to_index(product.id, combined_text)
