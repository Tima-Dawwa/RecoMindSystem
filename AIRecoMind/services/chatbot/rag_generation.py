from bson import ObjectId
from typing import List, Dict, Any
from motor.motor_asyncio import AsyncIOMotorCollection
from huggingface_hub import InferenceClient
from models.product import Product

# -----------------------

GEN_MODEL_PATH = "deepseek-ai/DeepSeek-V3-0324"
HF_TOKEN = 'api_key_here'
client = InferenceClient(provider="auto",
                         api_key=HF_TOKEN)

# -----------------------


async def build_context(
    recommendations: List[str], product_collection: AsyncIOMotorCollection
) -> str:
    if not recommendations:
        return ""

    object_ids = [ObjectId(pid) for pid in recommendations]

    cursor = product_collection.find({"_id": {"$in": object_ids}})
    products = [
        Product(id=str(doc["_id"]), **{**doc, "images": doc["images"]
                [0] if isinstance(doc["images"], list) else doc["images"]})
        async for doc in cursor
    ]

    contexts = []
    for product in products:
        details = (
            f"Name: {product.name}, "
            f"Type: {product.type}, "
            f"Appearance: {product.appearance}, "
            f"Color: {product.color}, "
            f"Gender: {product.gender}, "
            f"Price: {product.price} "
            f"{'(Discounted: ' + str(product.discounted_price) + ')' if product.discounted_price else ''}, "
            f"Rating: {product.rating} ({product.rating_count} reviews), "
            f"Details: {product.details}"
        )
        contexts.append(details)

    return "\n".join(contexts)


# -----------------------


async def generate_response(
    user_query: str,
    recommendations: List[str],
    product_collection: AsyncIOMotorCollection,
    max_new_tokens: int = 100,
    temperature: float = 0.7,
) -> str:
    context = await build_context(recommendations, product_collection)

    if not context:
        return "I couldn't find matching products right now, sorry!"

    prompt = f"""
You are a helpful fashion shopping assistant.
Use the following product information to answer the customer’s query.
Be friendly, concise, and highlight the most relevant details (type, appearance, color, price, discount, rating).

Customer query:
{user_query}

Relevant products:
{context}

Instructions:
- Recommend the most suitable items based on the query.
- Mention the product name, type, appearance, and color naturally.
- If price or discount is available, highlight it.
- If rating is high, mention that customers liked it.
- Keep the tone conversational, like helping a friend shop.
- Answer in the same language as the user (Arabic or English).
"""
    try:
        completion = client.chat.completions.create(
            model=GEN_MODEL_PATH,
            messages=[{"role": "user", "content": prompt}],
            max_tokens=max_new_tokens,
            temperature=temperature,
            top_p=0.9,
            n=1,
        )

        response_text = completion.choices[0].message.content.strip()
        return response_text
    except Exception as e:
        return f"Sorry, I couldn't generate a response right now: {e}"
