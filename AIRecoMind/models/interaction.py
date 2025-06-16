from pydantic import BaseModel
from typing import List


class Interaction(BaseModel):
    user_id: str
    product_id: str
    interaction_type: str
    Interaction_weight: str
