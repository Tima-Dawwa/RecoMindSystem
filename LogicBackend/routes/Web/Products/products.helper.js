function normalizeBool(val) {
    if (val === true || val === 'true') return true;
    if (val === false || val === 'false') return false;
    return undefined;
}

function getCategory(categoryTitle) {
    const clothingCategories = {
        "All": [],
        "Tops": ["Sweater", "T-shirt", "Top", "Blouse", "Shirt", "Vest top", "Hoodie", "Polo shirt"],
        "Bottoms": ["Trousers", "Shorts", "Skirt", "Leggings/Tights", "Outdoor trousers"],
        "Jackets": ["Jacket", "Cardigan", "Coat"],
        "Pyjama": ["Pyjama set", "Pyjama jumpsuit/playsuit", "Pyjama bottom", "Night gown", "Robe"],
        "Suits": ["Blazer", "Outdoor Waistcoat", "Tie", "Tailored Waistcoat"],
        "Overall": ["Jumpsuit/Playsuit", "Dungarees", "Outdoor overall", "Dress"],
        "Shoes": ["Sneakers", "Boots", "Sandals", "Other shoe", "Slippers", "Heeled sandals", "Pumps", "Flat shoe", "Flip flop", "Wedge", "Bootie", "Heels", "Flat shoes"],
        "Bags": ["Bag", "Weekend/Gym bag", "Backpack", "Cross-body bag", "Tote bag", "Shoulder bag", "Bumbag", "Wallet"],
        "Hats": ["Hat/beanie", "Cap/peaked", "Hat/brim", "Beanie", "Cap", "Felt hat", "Straw hat"],
        "Accessory": ["Earring", "Earrings", "Other accessories", "Necklace", "Ring", "Accessories set", "Bracelet", "Watch", "Hair/alice band", "Hair clip", "Hair string", "Hair ties", "Hairband", "Sunglasses", "Eyeglasses"],
        "Additions": ["Scarf", "Belt", "Gloves", "Socks"]
    };
    return clothingCategories[categoryTitle];
}

module.exports = {
    normalizeBool,
    getCategory
}