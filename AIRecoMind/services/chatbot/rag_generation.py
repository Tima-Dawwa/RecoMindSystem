import torch
from typing import List, Dict, Any
from pymongo.collection import Collection
from transformers import AutoTokenizer, AutoModelForCausalLM

GEN_MODEL_PATH = "jais/jais-13b-chat"
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

tokenizer = AutoTokenizer.from_pretrained(GEN_MODEL_PATH)
generator = AutoModelForCausalLM.from_pretrained(
    GEN_MODEL_PATH,
    torch_dtype=torch.float16 if torch.cuda.is_available() else torch.float32,
    device_map="auto"
).to(device)


def build_context(recommendations: List[Dict[str, Any]], product_collection: Collection) -> str:
    contexts = []
    for rec in recommendations:
        product_id = rec if isinstance(rec, str) else rec.get("product_id")
        if not product_id:
            continue

        product = product_collection.find_one({"_id": product_id})
        if not product:
            continue

        details = (
            f"Name: {product.get('name')}, "
            f"Type: {product.get('type')}, "
            f"Appearance: {product.get('appearance')}, "
            f"Color: {product.get('color')}, "
            f"Gender: {product.get('gender')}, "
            f"Price: {product.get('price')} "
            f"{'(Discounted: ' + str(product.get('discounted_price')) + ')' if product.get('discounted_price') else ''}, "
            f"Rating: {product.get('rating')} ({product.get('rating_count')} reviews), "
            f"Details: {product.get('details')}"
        )
        contexts.append(details)

    return "\n".join(contexts)


def generate_response(
    user_query: str,
    recommendations: List[Dict[str, Any]],
    product_collection: Collection,
    max_new_tokens: int = 300,
    temperature: float = 0.7,
) -> str:
    context = build_context(recommendations, product_collection)

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

    inputs = tokenizer(prompt, return_tensors="pt").to(device)

    outputs = generator.generate(
        **inputs,
        max_new_tokens=max_new_tokens,
        temperature=temperature,
        do_sample=True,
        pad_token_id=tokenizer.eos_token_id,
    )

    return tokenizer.decode(outputs[0], skip_special_tokens=True)
