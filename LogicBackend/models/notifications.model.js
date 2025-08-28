const Notification = require('./notifications.mongo');

async function postNotification(data) {
    await Notification.create(data);
}

async function getNotifications(skip, limit) {
    return await Notification.find().skip(skip).limit(limit);
}

async function getNotificationsCount() {
    return await Notification.find().countDocuments();
}

async function deleteNotification(id) {
    return await Notification.findByIdAndDelete(id);
}

module.exports = {
    postNotification,
    getNotifications,
    getNotificationsCount,
    deleteNotification
};
