const deliveryService = require('../services/DeliveryService');
const logger = require('../utils/logger');

const confirmDelivery = async (req, res) => {
    const {shipmentId} = req.params;
    const {otp, deliveredBy} = req.body;
    
    try{
        // Validate required fields
        if (!shipmentId || !otp || !deliveredBy) {
            logger.logDeliveryAttempt(
                shipmentId || 'N/A',
                deliveredBy || 'N/A',
                false,
                'Missing required input fields'
            );
            return res.status(400).json({
                success: false,
                message: 'Missing required input fields'
            });
        }
        
        const result = await deliveryService.confirmDelivery(shipmentId, otp, deliveredBy);
        
        // Log successful delivery
        logger.logDeliveryAttempt(
            shipmentId,
            deliveredBy,
            true,
            'Delivery confirmed successfully'
        );
        
        res.status(200).json(result);
        
    }
    catch(error){
        const status = error.status || 500;
        const message = error.message || 'Internal server error';
        
        // Log failed delivery attempt
        logger.logDeliveryAttempt(
            shipmentId || 'N/A',
            deliveredBy || 'N/A',
            false,
            message
        );
        
        res.status(status).json({
            success: false,
            message: message
        });
    }
};

const getShipmentDetails = async (req, res) => {
    try{
        const {shipmentId} = req.params;
        
        if (!shipmentId) {
            return res.status(400).json({
                success: false,
                message: 'Shipment ID is required'
            });
        }
        
        const result = await deliveryService.getShipmentDetails(shipmentId);
        
        res.status(200).json(result);
        
    }
    catch(error){
        const status = error.status || 500;
        const message = error.message || 'Internal server error';
        
        res.status(status).json({
            success: false,
            message: message
        });
    }
};

module.exports = {
    confirmDelivery,
    getShipmentDetails
};

