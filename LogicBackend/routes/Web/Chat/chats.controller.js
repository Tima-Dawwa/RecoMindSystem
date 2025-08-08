const { postChat, getChats, getChatsCount } = require('../../../models/chats.model');
const { getPagination } = require('../../../services/query');
const { serializedData } = require('../../../services/serializeArray');
const { chatData } = require('./chat.serializer');

// Done
async function httpGetAllChats(req, res) {
    const user_id = req.user._id
    let chats = await getChats(user_id)
    let count = await getChatsCount(user_id)
    return res.status(200).json({
        data: serializedData(chats, chatData),
        count: count
    })
}

// Done
async function httpPostChat(req, res) {
    const data = {
        user_id: req.user._id,
        name: ""
    }
    chat = await postChat(data)
    return res.status(200).json({ message: 'Chat Successfully Created', chatID: chat._id })
}

module.exports = {
    httpGetAllChats,
    httpPostChat,
}