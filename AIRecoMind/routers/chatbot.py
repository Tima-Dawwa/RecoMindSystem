from fastapi import APIRouter
from pydantic import BaseModel
from typing import Optional
from PIL import Image
import os

from services.chatbot.chatbot_service import get_chatbot_recommendations
from services.chatbot.rag_generation import generate_response
from utils.database import product_collection

router = APIRouter()

BASE_IMAGE_FOLDER = "../LogicBackend/public/images/chats"


class ChatRequest(BaseModel):
    message: Optional[str] = None
    image: Optional[str] = None


@router.post("/chatbot")
async def chat_endpoint(request: ChatRequest):
    # query_image = None

    # # Step 1: Load image from disk if provided
    # if request.image:
    #     image_path = os.path.join(BASE_IMAGE_FOLDER, request.image)
    #     if os.path.exists(image_path):
    #         try:
    #             query_image = Image.open(image_path).convert("RGB")
    #         except Exception as e:
    #             return {"error": f"Failed to open image: {e}"}
    #     else:
    #         return {"error": "Image file not found"}

    # recs = get_chatbot_recommendations(
    #     query_text=request.message,
    #     query_image=query_image
    # )

    # answer = generate_response(
    #     user_query=request.message or "",
    #     recommendations=recs,
    #     product_collection=product_collection
    # )

    # return {"answer": answer, "recommendations": recs}
    return "Hello! This is a test response from the chatbot."
