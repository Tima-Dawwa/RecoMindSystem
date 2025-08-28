const path = require('path');
const fs = require('fs');

function encodeImage(image) {
    const matches = image.match(/^data:image\/\w+;base64,(.+)$/);

    if (!matches || matches.length !== 2) {
        console.error('Invalid base64 string');
        return null;
    }

    const base64Data = matches[1];
    const imageBuffer = Buffer.from(base64Data, 'base64');
    const imageName = `chat_${Date.now()}.png`;
    const imagePath = path.join(__dirname, '../public/chat', imageName);

    fs.mkdirSync(path.dirname(imagePath), { recursive: true });

    fs.writeFileSync(imagePath, imageBuffer);

    return imageName;
}

module.exports = { encodeImage };
