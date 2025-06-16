from fastapi import APIRouter, Response
from services.content_based import get_content_based_recommendations, add_product
from services.collaborative import get_collaborative_recommendations, retrain_als_model
from services.hybrid import get_cascade_hybrid_recommendations
from typing import List

router = APIRouter()


@router.get("/content-recommendations", response_model=List[str])
async def get_content_recommendations(product_id: str, top_n: int = 3):
    return await get_content_based_recommendations(product_id, top_n)


@router.post("/content-recommendations")
async def add_product_for_recommendation(product_id: str):
    await add_product(product_id)
    return Response(status_code=200, content=b"")


@router.get("/collaborative-recommendations", response_model=List[str])
async def get_collaborative_recommendations(user_id: str, top_n: int = 20):
    return await get_collaborative_recommendations(user_id, top_n)


@router.post("/collaborative-recommendations")
async def add_product_for_recommendation():
    await retrain_als_model()
    return Response(status_code=200, content=b"")


@router.get("/hybrid-recommendations", response_model=List[str])
async def get_hybrid_recommendations(user_id: str, product_id: str, top_n: int = 20):
    return await get_cascade_hybrid_recommendations(user_id, product_id, top_n)
