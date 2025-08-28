const Chat = require('./chats.mongo');

async function getChats(user_id) {
    return await Chat.find({ user_id: user_id }).sort({ createdAt: -1 });
}

async function getChatsCount(user_id) {
    return await Chat.find({ user_id: user_id }).countDocuments();
}

async function getChat(id) {
    return await Chat.findById(id);
}

async function postChat(data) {
    return await Chat.create(data);
}

async function postChatMessage(chat, message) {
    chat.messages.push(message);
    await chat.save();
}

module.exports = {
    getChats,
    getChatsCount,
    getChat,
    postChat,
    postChatMessage
};
