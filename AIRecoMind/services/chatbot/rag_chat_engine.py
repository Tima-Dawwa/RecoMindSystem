from blip2_service import encode_input, search_similar_products, load_faiss_index
from rag_generation import build_generation_prompt, generate_response, load_generation_model


def initialize():
    """
    Initialize necessary models and indexes.
    """
    pass


def handle_user_message(user_text: str = None, user_image=None):
    """
    Full pipeline:
    - encode input
    - retrieve similar products
    - generate natural language response
    Returns:
        - dict with keys 'product_ids' and 'bot_message'
    """
    pass
