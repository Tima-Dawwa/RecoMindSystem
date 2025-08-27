const Notification = require('./notifications.mongo');

async function addNotification(userId, message, type = 'info') {
    const notification = new Notification({
        user: userId,
        message,
        type
    });
    return await notification.save();
}

async function getUserNotifications(userId) {
    return await Notification.find({ user: userId }).sort({ createdAt: -1 });
}

async function markAsRead(notificationId) {
    return await Notification.findByIdAndUpdate(notificationId, { read: true }, { new: true });
}

module.exports = {
    addNotification,
    getUserNotifications,
    markAsRead
};