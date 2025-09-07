from pydantic import BaseModel
from fastapi import APIRouter, Response
from models.recommendation import Recommendation
from services.recommendation_system.content_based import get_content_based_recommendations, add_product
from services.recommendation_system.collaborative import get_collaborative_recommendations, retrain_als_model
from services.recommendation_system.hybrid import get_cascade_hybrid_recommendations
from typing import List

router = APIRouter()


@router.get("/content-recommendations", response_model=List[Recommendation])
async def get_content_recommendations(product_id: str, top_n: int = 3):
    results = await get_content_based_recommendations(product_id, top_n)
    return [{"id": pid, "similarity": float(sim)} for pid, sim in results]


@router.post("/content-recommendations")
async def add_product_for_recommendation(product_id: str):
    await add_product(product_id)
    return Response(status_code=200, content=b"")


# @router.post("/content-recommendations/delete")
# async def delete_product_from_recommendation(product_id: str):
#     await delete_product(product_id)
#     return Response(status_code=200, content=b"")


@router.get("/collaborative-recommendations", response_model=List[Recommendation])
async def get_collaborative_recommendations_route(user_id: str = "", top_n: int = 20):
    results = await get_collaborative_recommendations(user_id, top_n)
    return results


@router.post("/collaborative-recommendations")
async def train_collaborative_recommendations():
    await retrain_als_model()
    return Response(status_code=200, content=b"")


@router.get("/hybrid-recommendations", response_model=List[Recommendation])
async def get_hybrid_recommendations(user_id: str = "", product_id: str = "", top_n: int = 20):
    return await get_cascade_hybrid_recommendations(user_id, product_id, top_n)
