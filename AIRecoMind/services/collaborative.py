# Summary Flow
# Data → Sparse Matrix → ALS Training → Save model

# At runtime: Load model → Map user ID → Recommend products → If no user data, use fallback.
import numpy as np
from typing import Tuple
from typing import List, Tuple, Dict, Any
from implicit.als import AlternatingLeastSquares
from sklearn.preprocessing import LabelEncoder
from scipy.sparse import coo_matrix
from models.interaction import Interaction
from models.product import Product
from services.database import interaction_collection, product_collection


async def get_all_interactions() -> List[Interaction]:
    cursor = interaction_collection.find({})
    interactions = []
    async for doc in cursor:
        interactions.append(Interaction(
            user_id=doc.get("user_id", ""),
            product_id=doc.get("product_id", ""),
            interaction_type=doc.get("interaction_type", ""),
            interaction_weight=doc.get("interaction_weight", ""),
        ))
    return interactions


async def get_all_products_interaction_score() -> List[Product]:
    cursor = product_collection.find({})
    products = []
    async for doc in cursor:
        interactions = doc.get("interactions", {})
        products.append(Product(
            id=str(doc["_id"]),
            total_interactions=interactions.get("total_interactions"),
            total_interaction_score=doc.get("total_interaction_score")
        ))

    return products


async def load_interaction_data():
    interactions = await get_all_interactions()
    return interactions


async def return_compute_interaction_score():
    interaction_score = await get_all_products_interaction_score()
    return interaction_score


def build_sparse_matrix(interactions: List[Interaction]) -> Tuple[coo_matrix, LabelEncoder, LabelEncoder]:

    user_ids = [interaction.user_id for interaction in interactions]
    product_ids = [interaction.product_id for interaction in interactions]
    weights = [float(interaction.interaction_weight)
               for interaction in interactions]

    user_encoder = LabelEncoder()
    item_encoder = LabelEncoder()

    user_indices = user_encoder.fit_transform(user_ids)
    item_indices = item_encoder.fit_transform(product_ids)

    matrix = coo_matrix((weights, (user_indices, item_indices)))

    return matrix, user_encoder, item_encoder


def train_als_model(
    interaction_matrix: coo_matrix,
    factors: int = 20,
    regularization: float = 0.1,
    iterations: int = 20
) -> AlternatingLeastSquares:

    item_user_matrix = interaction_matrix.T.tocsr()

    model = AlternatingLeastSquares(
        factors=factors,
        regularization=regularization,
        iterations=iterations,
        use_gpu=False
    )
    model.fit(item_user_matrix)

    return model


# 5. Save model and encoders for later use (disk, cache, etc.)
def save_model_and_encoders():
    """
    Save ALS model, LabelEncoders, and sparse matrix to persistent storage.
    """
    pass


# 6. Load model, encoders, and matrix from storage for runtime recommendations
def load_model_and_encoders():
    """
    Load ALS model, encoders, and interaction matrix.
    """
    pass


# 7. Get fallback recommendations for cold start users (popular, trending, or highly rated products)
async def get_fallback_recommendations(top_n= 20) -> List[str]:

    products = await get_all_products_interaction_score()
    products.sort(key=lambda p: p.total_interaction_score or 0, reverse=True)
    return [p.id for p in products[:top_n]]


# 8. Main function: get collaborative recommendations with cold start handling
async def get_collaborative_recommendations(user_id: str, top_n: int = 20) -> List[str]:

    model, user_encoder, item_encoder, user_item_matrix = load_model_and_encoders()

    if user_id not in user_encoder.classes_:
        return await get_fallback_recommendations(top_n)
    user_index = np.where(user_encoder.classes_ == user_id)[0][0]
    recommended = model.recommend(user_index, user_item_matrix.T, num=top_n)
    item_indices = [item_idx for item_idx, _ in recommended]
    product_ids = item_encoder.inverse_transform(item_indices)
    return product_ids.tolist()
