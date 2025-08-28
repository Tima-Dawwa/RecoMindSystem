const { getNotifications, getNotificationsCount, deleteNotification } = require('../../../models/notifications.model');
const { serializedData } = require('../../../services/serializeArray');
const { notificationData } = require('./notifications.serializer');
const { getPagination } = require('../../../services/query');

async function httpGetAllNotifications(req, res) {
    const { skip, limit } = getPagination(req.query);
    const notifications = await getNotifications(skip, limit);
    const notificationsCount = await getNotificationsCount();
    return res.status(200).json({
        data: serializedData(notifications, notificationData),
        count: notificationsCount
    });
}

async function httpDeleteNotification(req, res) {
    await deleteNotification(req.params.id);
    return res.status(200).json({ message: 'Notification Deleted Successfully' });
}

module.exports = {
    httpGetAllNotifications,
    httpDeleteNotification
};
