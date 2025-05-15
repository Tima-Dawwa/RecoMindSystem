from fastapi import APIRouter, Response
from services.content_based import get_content_based_recommendations, add_product
from models.product import Product
from typing import List

router = APIRouter()


@router.get("/recommendations", response_model=List[Product])
async def get_recommendations(product_id: str, top_n: int = 3):
    return await get_content_based_recommendations(product_id, top_n)


@router.post("/recommendations")
async def add_product_for_recommendation(product_id: str):
    await add_product(product_id)
    return Response(status_code=200, content=b"")
