from typing import List, Dict, Tuple
import numpy as np
from services.content_based import get_content_based_recommendations
from services.collaborative import get_collaborative_recommendations
from sklearn.metrics import precision_score, recall_score, f1_score

async def get_hybrid_recommendations(user_id: str, product_id: str, top_n: int = 10) -> List[str]:
    """
    Combines collaborative and content-based recommendations and removes duplicates.
    Returns the best N recommendations.
    """
    # Get recommendations from both systems
    
    # Combine and remove duplicates while preserving order
    
    # First add collaborative recommendations
     
    # Then add content-based recommendations
    
async def get_weighted_hybrid_recommendations(
    user_id: str, 
    product_id: str, 
    top_n: int = 10,
    collab_weight: float = 0.7,
    content_weight: float = 0.3
) -> List[Tuple[str, float]]:
    """
    Combines recommendations with different weights (0.7 collaborative, 0.3 content-based).
    Returns the best N recommendations sorted by score.
    """
    # Get recommendations from both systems
    
    # Create scoring dictionary
     
    # Score collaborative recommendations
     
    # Score content-based recommendations
    
    # Sort by score and return top N
    
async def evaluate_hybrid_recommendations(
    user_id: str,
    product_id: str,
    ground_truth: List[str],
    top_n: int = 10
) -> Dict[str, float]:
    """
    Evaluates the quality of recommendations using precision, recall, and F1-score.
    """
    # Get hybrid recommendations
    
    # Convert to binary arrays for evaluation
     
    # Calculate metrics
   

async def get_cascade_hybrid_recommendations(
    user_id: str,
    product_id: str,
    top_n: int = 10,
    initial_pool_size: int = 50
) -> List[str]:
    """
    Uses collaborative recommendations as initial filter (50 recommendations),
    then refines results using content-based recommendations.
    """
    # Get initial collaborative recommendations
   
    # Get content-based scores for all products in initial pool
    
    # Sort by content-based scores and return top N
    
async def evaluate_cascade_hybrid_recommendations(
    user_id: str,
    product_id: str,
    ground_truth: List[str],
    top_n: int = 10,
    initial_pool_size: int = 50
) -> Dict[str, float]:
    """
    Evaluates the quality of cascade hybrid recommendations using precision, recall, and F1-score.
    """
    # Get cascade hybrid recommendations
   
    
    # Convert to binary arrays for evaluation
    
    # Calculate metrics
    