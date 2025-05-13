from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from models.product import Product
from bson import ObjectId
from typing import List

async def get_all_products() -> List[Product]:
    cursor = product_collection.find({})
    products = []
    async for doc in cursor:
        products.append(Product(
            id=str(doc["_id"]),
            name=doc.get("name", ""),
            type=doc.get("type", ""),
            appearance=doc.get("appearance", ""),
            color=doc.get("color", ""),
            department=doc.get("department", ""),
            gender=doc.get("gender", ""),
            details=doc.get("details", "")
        ))
    return products

products = await get_all_products()

def get_content_based_recommendations(product_id: str, top_n: int = 3) -> List[Product]:
    # Combine all features into a single string for each product
    def combine_features(product: Product) -> str:
        return " ".join([
            product.name,
            product.type,
            product.appearance,
            product.color,
            product.department,
            product.gender,
            product.details
        ]).lower()  # Convert to lowercase for uniformity

    combined_features = [combine_features(product) for product in products]

    # Create a TfidfVectorizer to convert product descriptions into feature vectors
    vectorizer = TfidfVectorizer(stop_words='english')
    tfidf_matrix = vectorizer.fit_transform(descriptions)

    # Compute cosine similarity between all products
    cosine_sim = cosine_similarity(tfidf_matrix, tfidf_matrix)

    # Find the index of the product based on the provided product_id
    idx = next(i for i, product in enumerate(products) if product.id == product_id)

    # Get pairwise similarity scores of the products with the specified product
    sim_scores = list(enumerate(cosine_sim[idx]))

    # Sort the products by similarity score (descending)
    sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)

    # Get the indices of the most similar products (excluding the product itself)
    sim_scores = sim_scores[1:top_n + 1]

    # Get the most similar products
    recommended_products = [products[i[0]] for i in sim_scores]

    return recommended_products
