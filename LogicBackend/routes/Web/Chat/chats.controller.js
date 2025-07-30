const { postChat, getChats, getChatsCount } = require('../../../models/chats.model');
const { getPagination } = require('../../../services/query');
const { serializedData } = require('../../../services/serializeArray');
const { chatData } = require('./chat.serializer');
const { validateCreateChat } = require('./chat.validation');

// Done
async function httpGetAllChats(req, res) {
    req.query.limit = 10;
    const { skip, limit } = getPagination(req.query)
    const user_id = req.user._id
    let chats = await getChats(user_id, skip, limit)
    let count = await getChatsCount(user_id)
    return res.status(200).json({
        data: serializedData(chats, chatData),
        count: count
    })
}

// Done
async function httpPostChat(req, res) {
    const { error } = validateCreateChat(req.body)
    if (error) return res.status(400).json({ message: error.details[0].message })
    const data = {
        user_id: req.user._id,
        name: req.body.chat_name
    }
    await postChat(data)
    return res.status(200).json({ message: 'Chat Successfully Created' })
}

module.exports = {
    httpGetAllChats,
    httpPostChat,
}