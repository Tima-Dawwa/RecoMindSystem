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

const WEIGHT_MAP = {
    [INTERACTION_TYPES.VIEW]: 1,
    [INTERACTION_TYPES.FAVORITE]: 2,
    [INTERACTION_TYPES.CART_ADD]: 3,
    [INTERACTION_TYPES.ORDER]: 5,
};

module.exports = {
    INTERACTION_TYPES,
    RATING,
    WEIGHT_MAP
}