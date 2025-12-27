
const logDeliveryAttempt = (shipmentId, agentName, success, message) => {
    // Handle logging asynchronously to avoid blocking the response
    setImmediate(() => {
        const timestamp = new Date().toISOString();
        const status = success ? 'SUCCESS' : 'FAILURE';
        
        const logEntry = {
            timestamp,
            shipmentId,
            agentName,
            status,
            message
        };
        
        console.log(`[DELIVERY ${status}] ${timestamp} | Shipment: ${shipmentId} | Agent: ${agentName} | ${message}`);
    });
};

module.exports = {logDeliveryAttempt };

