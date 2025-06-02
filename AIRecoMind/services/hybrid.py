from bson import ObjectId
from services.database import product_collection
from typing import List, Dict, Tuple
import numpy as np
from services.content_based import get_content_based_recommendations
from services.collaborative import get_collaborative_recommendations


def rerank_with_content_scores(
    product_ids: List[str],
    content_scores: Dict[str, float],
    seen_items: List[str],
    top_n: int
) -> List[str]:
    """
    Reranks a list of product_ids using content-based similarity scores.
    Filters out already seen items.
    """
    filtered_products = [pid for pid in product_ids if pid not in seen_items]
    scored_products = [(pid, content_scores.get(pid, 0.0))
                       for pid in filtered_products]
    ranked = sorted(scored_products, key=lambda x: x[1], reverse=True)
    return [pid for pid, _ in ranked[:top_n]]


async def get_cascade_hybrid_recommendations(
    user_id: str,
    product_id: str,
    top_n: int = 10,
    initial_pool_size: int = 50
) -> List[str]:
    """
    Uses collaborative filtering for candidate pool, then reranks using content-based similarity.
    Handles cold-starts and filters seen items.
    """
    collab_pool = await get_collaborative_recommendations(user_id, top_n=initial_pool_size)

    seen_items = get_seen_product_ids(user_id)

    content_scores = {pid: np.random.rand() for pid in collab_pool}

    reranked = rerank_with_content_scores(
        collab_pool, content_scores, seen_items, top_n)

    return reranked


def compute_binary_arrays(predictions: List[str], ground_truth: List[str]) -> Tuple[List[int], List[int]]:
    y_true = [1] * len(predictions)
    y_pred = [1 if pid in ground_truth else 0 for pid in predictions]
    return y_true, y_pred


def calculate_precision(y_true: List[int], y_pred: List[int]) -> float:

    if not y_pred:
        return 0.0

    true_positives = sum(1 for t, p in zip(
        y_true, y_pred) if t == 1 and p == 1)
    return true_positives / sum(y_pred)


def calculate_recall(y_true: List[int], y_pred: List[int]) -> float:

    if not y_true:
        return 0.0

    true_positives = sum(1 for t, p in zip(
        y_true, y_pred) if t == 1 and p == 1)
    return true_positives / sum(y_true)


def calculate_f1(y_true: List[int], y_pred: List[int]) -> float:

    precision = calculate_precision(y_true, y_pred)
    recall = calculate_recall(y_true, y_pred)

    if precision + recall == 0:
        return 0.0

    return 2 * (precision * recall) / (precision + recall)


def calculate_metrics(y_true: List[int], y_pred: List[int]) -> Dict[str, float]:

    return {
        "precision": calculate_precision(y_true, y_pred),
        "recall": calculate_recall(y_true, y_pred),
        "f1_score": calculate_f1(y_true, y_pred)
    }


async def evaluate_cascade_hybrid_recommendations(
    user_id: str,
    product_id: str,
    ground_truth: List[str],
    top_n: int = 10,
    initial_pool_size: int = 50
) -> Dict[str, float]:

    recommendations = await get_cascade_hybrid_recommendations(
        user_id, product_id, top_n, initial_pool_size
    )

    y_true = [1 if item in ground_truth else 0 for item in recommendations]
    y_pred = [1] * len(recommendations)

    return calculate_metrics(y_true, y_pred)


# seen items
async def get_seen_product_ids(user_id: str) -> List[str]:
    cursor = product_collection.find(
        {"user_id": ObjectId(user_id), "interaction_type": "view"},
        {"_id": 1}
    )

    seen_ids = []
    async for doc in cursor:
        seen_ids.append(str(doc["_id"]))

    return seen_ids
