from fastapi import APIRouter, Query
from services.content_based import get_recommendations_handler
from models.product import Product
from typing import List

router = APIRouter()


@router.get("/recommendations", response_model=List[Product])
async def get_recommendations(product_id: str, top_n: int = 3):
    return await get_recommendations_handler(product_id, top_n)
