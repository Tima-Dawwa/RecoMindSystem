const { getProductById } = require("../../../models/products.model");
const { productData } = require("./chat.serializer");

async function getProductsData(products) {
    let finalProducts = [];
    for (let i = 0; i < products.length; i++) {
        const temp = await getProductById(products[i])
        finalProducts.push(productData(temp))
    }
    return finalProducts
}

module.exports = {
    getProductsData
}