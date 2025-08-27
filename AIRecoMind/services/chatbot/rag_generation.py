from typing import List, Dict, Any
from motor.motor_asyncio import AsyncIOMotorCollection
from huggingface_hub import InferenceClient
from models.product import Product

# -----------------------

GEN_MODEL_PATH = "jais/jais-13b-chat"
HF_TOKEN = 'api_token_here'
client = InferenceClient(model=GEN_MODEL_PATH, token=HF_TOKEN)

# -----------------------


async def build_context(
    recommendations: List[Dict[str, Any]], product_collection: AsyncIOMotorCollection
) -> str:
    # Extract product IDs
    product_ids = [rec if isinstance(rec, str) else rec.get(
        "product_id") for rec in recommendations if rec]

    if not product_ids:
        return ""

    # Fetch all products in one query
    cursor = product_collection.find({"_id": {"$in": product_ids}})
    products = [Product(id=str(doc["_id"]), **doc) async for doc in cursor]

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
    recommendations: List[Dict[str, Any]],
    product_collection: AsyncIOMotorCollection,
    max_new_tokens: int = 300,
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
        response = client.text_generation(
            prompt, max_new_tokens=max_new_tokens, temperature=temperature)
        return response[0]["generated_text"]
    except Exception as e:
        return f"Sorry, I couldn't generate a response right now: {e}"
