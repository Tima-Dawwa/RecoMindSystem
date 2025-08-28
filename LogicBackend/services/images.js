const path = require('path');
const fs = require('fs');

function encodeImage(base64Image, extension = 'jpg') {
    try {
        const imageBuffer = Buffer.from(base64Image, 'base64');
        const imageName = `chat_${Date.now()}.${extension}`;
        const imagePath = path.join(__dirname, '../public/images/chats', imageName);

        fs.mkdirSync(path.dirname(imagePath), { recursive: true });
        fs.writeFileSync(imagePath, imageBuffer);

        return imageName;
    } catch (err) {
        console.error('Failed to save base64 image:', err);
        return null;
    }
}

module.exports = { encodeImage };
