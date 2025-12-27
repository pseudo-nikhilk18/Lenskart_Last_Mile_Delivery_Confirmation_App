const shipmentRepository = require('../repositories/shipmentRepository');
const STATUS = require('../constants/statusConstants');

const confirmDelivery = async (shipmentId, otp, deliveredBy) => {
    // Find shipment
    const shipment = await shipmentRepository.findByShipmentId(shipmentId);
    
    if (!shipment) {
        throw{ 
            status: 404, 
            message: 'Shipment not found' 
        };
    }
    
    // Check if already delivered
    if (shipment.status === STATUS.DELIVERED) {
        throw{ 
            status: 409, 
            message: 'Shipment already delivered'
        };
    }
    
    // Validate OTP
    if (shipment.otp_code !== otp) {
        throw{ 
            status: 401, 
            message: 'Invalid OTP' 
        };
    }
    
    // Mark as delivered
    const updated = await shipmentRepository.markAsDelivered(shipmentId, deliveredBy);
    
    if (!updated) {
        throw{ 
            status: 500, 
            message: 'Failed to update delivery status' 
        };
    }
    
    return {
        success: true,
        message: 'Delivery confirmed successfully',
        shipment: {
            shipmentId: shipment.shipment_id,
            customerName: shipment.customer_name,
            status: STATUS.DELIVERED
        }
    };
};

const getShipmentDetails = async (shipmentId) => {

    const shipment = await shipmentRepository.findByShipmentId(shipmentId);
    
    if (!shipment) {
        throw{ 
            status: 404, 
            message: 'Shipment not found' 
        };
    }
    
    return {
        success: true,
        shipment: {
            shipmentId: shipment.shipment_id,
            customerName: shipment.customer_name,
            status: shipment.status,
            deliveredAt: shipment.delivered_at,
            deliveredBy: shipment.delivered_by
        }
    };
};

module.exports = {
    confirmDelivery,
    getShipmentDetails
};

