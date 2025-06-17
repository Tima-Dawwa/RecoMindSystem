# rag_generation.py
"""
Handles generating a natural language response using a RAG model
given user query and retrieved product information.

Recommended libraries:
- transformers
- torch
"""


def build_generation_prompt(user_query: str, products_info: list):
    """
    Build prompt text combining user query and product details
    to feed into the generation model.
    Inputs:
        - user_query: string from user
        - products_info: list of dicts containing product details
    Returns:
        - prompt string
    """
    pass


def generate_response(prompt: str):
    """
    Call the RAG model to generate a conversational response.
    Inputs:
        - prompt: string prompt
    Returns:
        - generated response string
    """
    pass


def load_generation_model():
    """
    Load and initialize the RAG or language generation model.
    """
    pass
