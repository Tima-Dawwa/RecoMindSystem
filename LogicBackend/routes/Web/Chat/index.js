const { validateSendMessage } = require('./chat.validation');
const { getChat, postChatMessage } = require('../../../models/chats.model');
const { verifyToken } = require('../../../services/token');
const { encodeImage } = require('../../../services/images');
const { default: mongoose } = require('mongoose');
require('dotenv').config()

const { getChatbotResponse } = require('./chatbot');
const { productData } = require('./chat.serializer');
const { getProductById } = require('../../../models/products.model');
const { getProductsData } = require('./chat.helper');

const userSocketMap = {};

async function socketFunctionality(io, socket) {
    const token = socket.handshake.query.token;
    if (!token) return
    const checkUser = verifyToken(token, process.env.SECRET_KEY)
    if (!checkUser) {
        return socket.disconnect();
    }

    const userID = checkUser.id;
    let mainChatID = null;
    userSocketMap[userID] = socket.id;

    socket.on('join-chat', async (chatId) => {
        console.log("joined-chat")
        if (!mongoose.isValidObjectId(chatId)) {
            socket.emit('chat-error', { message: "Chat not found or access denied." });
            return;
        }

        const chat = await getChat(chatId);
        if (!chat || chat.user_id.toString() !== userID) {
            socket.emit('chat-error', { message: "Chat not found or access denied." });
            return;
        }

        socket.join(chatId);
        console.log(`User ${userID} joined chat ${chatId}`);
        mainChatID = chatId;

        let messages = [];
        for (let i = 0; i < chat.messages.length; i++) {
            const message = chat.messages[i];
            const recommendedProducts = await getProductsData(message.recommendedProducts)
            let messageData = {
                content: message.content || '',
                timestamp: message.timestamp,
                senderType: message.senderType,
                image: message.image,
                from_me: message.senderType === 'user',
                recommendedProducts: recommendedProducts
            };
            messages.push(messageData);
        }

        socket.emit('chat-history', messages);
    });

    socket.on('leave-chat', () => {
        if (mainChatID) {
            socket.leave(mainChatID);
            console.log(`User ${userID} left chat ${mainChatID}`);
            mainChatID = null;
        }
    });

    socket.on('send-message', async (data) => {
        console.log("send-message")

        try {
            let { message, image } = data;
            const { error } = validateSendMessage({ message });
            if (error) {
                socket.emit('message-error', { message: error.details[0].message });
                return;
            }

            if (!mainChatID) {
                socket.emit('chat-error', { message: "No active chat found" });
                return;
            }

            const chat = await getChat(mainChatID);
            if (!chat || chat.user_id.toString() !== userID) {
                socket.emit('chat-error', { message: "Chat not found or access denied" });
                return;
            }

            if (!chat.name || chat.name.trim() === "") {
                const newName = message.trim().substring(0, 10);
                chat.name = newName;
                await chat.save();
            }

            let processedImage = null;

            if (image) {
                processedImage = encodeImage(image);
            }

            let userMessage = {
                senderType: 'user',
                content: message || '',
                image: processedImage ? `${process.env.URL}/images/chats/${processedImage}` : null,
                timestamp: new Date()
            };

            await postChatMessage(chat, userMessage);

            socket.emit('message-sent', {
                content: userMessage.content,
                timestamp: userMessage.timestamp,
                senderType: 'user',
                from_me: true,
                image: processedImage ? `${process.env.URL}/images/chats/${processedImage}` : null
            });

            try {
                socket.emit('bot-typing', true);

                const botResponse = await getChatbotResponse({
                    message: message,
                    image: processedImage,
                    userId: userID
                });

                socket.emit('bot-typing', false);

                let botMessage = {
                    senderType: 'system',
                    content: botResponse.message || '',
                    timestamp: new Date(),
                    recommendedProducts: botResponse.recommendedProducts || []
                };

                await postChatMessage(chat, botMessage);

                const recommendedProducts = await getProductsData(botMessage.recommendedProducts)
                socket.emit('receive-message', {
                    content: botMessage.content,
                    timestamp: botMessage.timestamp,
                    senderType: 'system',
                    from_me: false,
                    recommendedProducts: recommendedProducts
                });

            } catch (botError) {
                console.error('Chatbot error:', botError);
                socket.emit('bot-typing', false);

                let errorMessage = {
                    senderType: 'system',
                    content: 'Sorry, I encountered an error processing your message. Please try again.',
                    timestamp: new Date()
                };

                await postChatMessage(chat, errorMessage);

                socket.emit('receive-message', {
                    content: errorMessage.content,
                    timestamp: errorMessage.timestamp,
                    senderType: 'system',
                    from_me: false
                });
            }

        } catch (error) {
            console.error('Message handling error:', error);
            socket.emit('message-error', { message: 'Failed to process message' });
        }
    });

    socket.on('disconnect', () => {
        console.log(`User ${userID} disconnected`);
        delete userSocketMap[userID];
    });
}

module.exports = socketFunctionality;