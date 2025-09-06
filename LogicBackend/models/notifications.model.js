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

async function deleteOldNotifications(cutoffDate) {
    const result = await Notification.deleteMany({ createdAt: { $lt: cutoffDate } });
    return result.deletedCount;
}

module.exports = {
    postNotification,
    getNotifications,
    getNotificationsCount,
    deleteNotification,
    deleteOldNotifications
};
