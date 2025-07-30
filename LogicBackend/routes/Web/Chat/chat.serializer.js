function chatData(chat) {
    let last_message = ''
    if (chat.messages.length > 0) {
        last_message = chat.messages[chat.messages.length - 1].content
    }
    return {
        chat_name: chat.name,
        last_message: last_message
    }
}

module.exports = {
    chatData,
}