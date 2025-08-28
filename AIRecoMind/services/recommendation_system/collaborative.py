import asyncio
import os
import joblib
import numpy as np
from joblib import dump
from typing import Tuple
from typing import List, Tuple
from models.product import Product
from scipy.sparse import coo_matrix
from models.interaction import Interaction
from sklearn.preprocessing import LabelEncoder
from implicit.als import AlternatingLeastSquares
from utils.database import interaction_collection, product_collection


async def get_all_interactions() -> List[Interaction]:
    cursor = interaction_collection.find({})
    interactions = []
    async for doc in cursor:
        interactions.append(Interaction(
            user_id=str(doc["user_id"]),
            product_id=str(doc["product_id"]),
            interaction_type=doc.get("interaction_type", ""),
            interaction_weight=float(
                doc.get("interaction_weight", 1.0)),  # default to 1.0
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
) -> Tuple[AlternatingLeastSquares, coo_matrix]:
    user_item_matrix = interaction_matrix.tocsr()
    item_user_matrix = user_item_matrix.T.tocsr()

    model = AlternatingLeastSquares(
        factors=factors,
        regularization=regularization,
        iterations=iterations,
        use_gpu=False
    )
    model.fit(item_user_matrix)

    return model, user_item_matrix


def save_model_and_encoders(model: AlternatingLeastSquares, user_encoder: LabelEncoder,
                            item_encoder: LabelEncoder, matrix: coo_matrix):
    os.makedirs('data', exist_ok=True)

    dump(model, 'data/als_model.joblib', compress=3)
    dump(user_encoder, 'data/user_encoder.joblib', compress=3)
    dump(item_encoder, 'data/item_encoder.joblib', compress=3)
    dump(matrix, 'data/interaction_matrix.joblib', compress=3)


def load_model_and_encoders():
    model = joblib.load('data/als_model.joblib')
    user_encoder = joblib.load('data/user_encoder.joblib')
    item_encoder = joblib.load('data/item_encoder.joblib')
    matrix = joblib.load('data/interaction_matrix.joblib')
    return model, user_encoder, item_encoder, matrix


async def get_fallback_recommendations(top_n=20) -> List[str]:
    products = await return_compute_interaction_score()
    products.sort(key=lambda p: p.total_interaction_score or 0, reverse=True)
    return [p.id for p in products[:top_n]]


async def get_collaborative_recommendations(user_id: str, top_n: int = 20):
    model, user_encoder, item_encoder, user_item_matrix = load_model_and_encoders()

    if user_id not in user_encoder.classes_:
        fallback_ids = await get_fallback_recommendations(top_n)
        return [{"id": pid, "similarity": 1.0} for pid in fallback_ids]

    user_index = np.where(user_encoder.classes_ == user_id)[0][0]

    user_item_matrix = user_item_matrix.T.tocsr()

    if user_index >= user_item_matrix.shape[0]:
        fallback_ids = await get_fallback_recommendations(top_n)
        return [{"id": pid, "similarity": 1.0} for pid in fallback_ids]

    if user_item_matrix.getrow(user_index).nnz == 0:
        fallback_ids = await get_fallback_recommendations(top_n)
        return [{"id": pid, "similarity": 1.0} for pid in fallback_ids]

    user_vector = user_item_matrix[user_index]
    item_indices, scores = model.recommend(user_index, user_vector, N=top_n)

    scores = np.array(scores)
    if scores.max() > scores.min():
        normalized_scores = (scores - scores.min()) / \
            (scores.max() - scores.min())
    else:
        normalized_scores = np.ones_like(scores)

    product_ids = item_encoder.inverse_transform(item_indices)

    return [
        {"id": str(pid), "similarity": float(sim)}
        for pid, sim in zip(product_ids, normalized_scores)
    ]


async def retrain_als_model():
    interactions = await load_interaction_data()
    matrix, user_encoder, item_encoder = build_sparse_matrix(interactions)
    model, user_item_matrix = train_als_model(matrix)
    save_model_and_encoders(model, user_encoder,
                            item_encoder, user_item_matrix)
    return True


# here for the first time
# async def main():
#     await retrain_als_model()


# # Run the async main function
# asyncio.run(main())
