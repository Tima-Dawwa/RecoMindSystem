const Product = require('./products.mongo');
const Interaction = require('./interactions.mongo');
const { INTERACTION_TYPES, RATING } = require('../public/constants/interaction')

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

async function postInteraction(user_id, product_id, interaction_type, rating_value = null) {
    return await Interaction.create({
        user_id,
        product_id,
        interaction_type,
        rating_value: rating_value
    });
}

async function updateRatingInteraction(interaction_id, rating_value) {
    return await Interaction.findOneAndUpdate({
        _id: interaction_id
    }, {
        rating_value: rating_value,
        interaction_weight: rating_value
    });
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

async function removeProductInteraction(productId, userId, type) {
    try {
        const interaction = await Interaction.findOneAndDelete({
            product_id: productId,
            user_id: userId,
            interaction_type: type
        });
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
                existingRating.rating_value = ratingValue
                existingRating.save();
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

async function getProductInteractionCount(productId, interactionType) {
    try {
        const product = await Product.findById(productId);
        if (!product) {
            throw new Error('Product not found');
        }

        if (interactionType) {

            return product.interactions[interactionType] || 0;
        } else {

            return product.interactions.total_interactions || 0;
        }
    } catch (error) {
        throw new Error(`Failed to get product interaction count: ${error.message}`);
    }
}

async function removeProductInteraction(productId, userId, interactionType) {
    try {
        const product = await Product.findById(productId);
        if (!product) {
            throw new Error('Product not found');
        }


        await Interaction.findOneAndDelete({
            user_id: userId,
            product_id: productId,
            interaction_type: interactionType
        });


        const update = {
            $inc: {
                'interactions.total_interactions': -1
            }
        };


        const updateField = `interactions.${interactionType}`;
        update.$inc[updateField] = -1;


        const updatedProduct = await Product.findByIdAndUpdate(
            productId,
            update,
            { new: true }
        );

        return updatedProduct;
    } catch (error) {
        throw new Error(`Failed to remove product interaction: ${error.message}`);
    }
}

async function checkRating(userId, productId) {
    return await Interaction.findOne({
        user_id: userId,
        product_id: productId,
        interaction_type: INTERACTION_TYPES.RATING
    });
}

module.exports = {
    getInteractions,
    getInteraction,
    postInteraction,
    deleteInteraction,
    updateProductInteraction,
    getProductInteractions,
    getUserInteractions,
    checkRating,
    updateRatingInteraction,
    removeProductInteraction
};
