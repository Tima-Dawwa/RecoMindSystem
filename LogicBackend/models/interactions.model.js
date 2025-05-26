const Product = require('./products.mongo');
const Interaction = require('./interactions.mongo');


const INTERACTION_TYPES = {
    VIEW: 'view',
    FAVORITE: 'favorite',
    CART_ADD: 'add_to_cart',
    ORDER: 'order',
    RATING: 'rating'
};


const RATING = {
    MIN: 0,
    MAX: 5
};

async function getInteractions(skip, limit) {
    try {
        return await Interaction.find()
            .skip(skip)
            .limit(limit)
            .populate('user_id', 'name email')
            .populate('product_id', 'name price');
    } catch (error) {
        throw new Error(`Failed to fetch interactions: ${error.message}`);
    }
}

async function getInteraction(interaction_id) {
    try {
        const interaction = await Interaction.findById(interaction_id)
            .populate('user_id', 'name email')
            .populate('product_id', 'name price');
        if (!interaction) {
            throw new Error('Interaction not found');
        }
        return interaction;
    } catch (error) {
        throw new Error(`Failed to fetch interaction: ${error.message}`);
    }
}

async function postInteraction(data) {
    try {
        return await Interaction.create(data);
    } catch (error) {
        throw new Error(`Failed to create interaction: ${error.message}`);
    }
}

async function deleteInteraction(interaction_id) {
    try {
        const interaction = await Interaction.findByIdAndDelete(interaction_id);
        if (!interaction) {
            throw new Error('Interaction not found');
        }
        return interaction;
    } catch (error) {
        throw new Error(`Failed to delete interaction: ${error.message}`);
    }
}

async function updateProductInteraction(productId, userId, interactionType, ratingValue = null) {
    try {
        
        const product = await Product.findById(productId);
        if (!product) {
            throw new Error('Product not found');
        }

        
        if (!Object.values(INTERACTION_TYPES).includes(interactionType)) {
            throw new Error('Invalid interaction type');
        }

        
        if (interactionType === INTERACTION_TYPES.RATING) {
            if (ratingValue === null) {
                throw new Error('Rating value is required for rating interactions');
            }
            if (ratingValue < RATING.MIN || ratingValue > RATING.MAX) {
                throw new Error(`Rating value must be between ${RATING.MIN} and ${RATING.MAX}`);
            }
        }

        
        if (interactionType === INTERACTION_TYPES.RATING) {
            const existingRating = await Interaction.findOne({
                user_id: userId,
                product_id: productId,
                interaction_type: INTERACTION_TYPES.RATING
            });

            if (existingRating) {
                throw new Error('User has already rated this product');
            }
        }

        
        const interactionData = {
            user_id: userId,
            product_id: productId,
            interaction_type: interactionType
        };

        if (interactionType === INTERACTION_TYPES.RATING) {
            interactionData.rating_value = ratingValue;
        }

        await Interaction.create(interactionData);

       
        const update = {
            $inc: {
                'interactions.total_interactions': 1
            }
        };

        if (interactionType === INTERACTION_TYPES.RATING) {
            // Update rating statistics
            update.$inc = {
                ...update.$inc,
                rating: ratingValue,
                rating_count: 1
            };
        } else {
            // Update other interaction types
            const updateField = `interactions.${interactionType}s`;
            update.$inc[updateField] = 1;
        }

        const updatedProduct = await Product.findByIdAndUpdate(
            productId,
            update,
            { new: true }
        );

        // Calculate and update average rating
        if (interactionType === INTERACTION_TYPES.RATING) {
            const avgRating = updatedProduct.rating / updatedProduct.rating_count;
            await Product.findByIdAndUpdate(
                productId,
                { $set: { rating: avgRating } }
            );
        }

        return updatedProduct;
    } catch (error) {
        throw new Error(`Failed to update product interaction: ${error.message}`);
    }
}

async function getProductInteractions(productId) {
    try {
        return await Interaction.find({ product_id: productId })
            .populate('user_id', 'name email')
            .sort({ createdAt: -1 });
    } catch (error) {
        throw new Error(`Failed to fetch product interactions: ${error.message}`);
    }
}

async function getUserInteractions(userId) {
    try {
        return await Interaction.find({ user_id: userId })
            .populate('product_id', 'name price')
            .sort({ createdAt: -1 });
    } catch (error) {
        throw new Error(`Failed to fetch user interactions: ${error.message}`);
    }
}

module.exports = {
    getInteractions,
    getInteraction,
    postInteraction,
    deleteInteraction,
    updateProductInteraction,
    getProductInteractions,
    getUserInteractions,
    INTERACTION_TYPES
};
