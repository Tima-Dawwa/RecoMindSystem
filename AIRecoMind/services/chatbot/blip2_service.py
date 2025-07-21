def encode_input(user_text: str = None, user_image=None):
    """
    Encode user input (text and/or image) into embedding vector.
    Inputs:
        - user_text: optional string
        - user_image: optional image object
    Returns:
        - embedding: numpy array or torch tensor
    """
    pass


def search_similar_products(embedding, top_k: int = 5):
    """
    Search FAISS index using embedding to get top_k product IDs.
    Inputs:
        - embedding: embedding vector from encode_input
        - top_k: number of similar products to return
    Returns:
        - List of product IDs
    """
    pass


def load_faiss_index():
    """
    Load the FAISS index and related mappings.
    Should be called once at startup.
    """
    pass
