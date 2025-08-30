const { getProductById } = require('../../../models/products.model');
const { productData } = require('./chat.serializer');
const { checkFavorite } = require('../../../models/favorites.model');

async function getProductsData(products, userID) {
    let finalProducts = [];
    for (let i = 0; i < products.length; i++) {
        const temp = await getProductById(products[i]);
        temp.isFavorite = (await checkFavorite(userID, temp._id)) ? true : false;
        finalProducts.push(productData(temp));
    }
    return finalProducts;
}

module.exports = {
    getProductsData
};
