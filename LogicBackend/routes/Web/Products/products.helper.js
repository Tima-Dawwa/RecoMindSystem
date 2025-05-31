function normalizeBool(val) {
    if (val === true || val === 'true') return true;
    if (val === false || val === 'false') return false;
    return undefined;
}

function getCategories(){
    
}

module.exports = {
    normalizeBool
}