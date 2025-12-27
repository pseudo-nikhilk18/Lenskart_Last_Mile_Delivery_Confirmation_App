const connectDB = require('../config/db');

const findByShipmentId = async (shipmentId) => {

    const [rows] = await connectDB.execute(
        'SELECT * FROM shipments WHERE shipment_id = ?',
        [shipmentId]
    );
    return rows[0] || null;
};

const markAsDelivered = async (shipmentId, deliveredBy) => {
    const [result] = await connectDB.execute(
        `UPDATE shipments 
        SET status = 'Delivered', 
            delivered_at = NOW(), 
            delivered_by = ? 
        WHERE shipment_id = ? AND status != 'Delivered'`,
        [deliveredBy, shipmentId]
    );
    return result.affectedRows > 0;
};

module.exports = {
    findByShipmentId,
    markAsDelivered
};

