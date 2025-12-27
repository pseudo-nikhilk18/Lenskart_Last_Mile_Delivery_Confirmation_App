class ApiConstants {

    static const String baseUrl = 'http://10.0.2.2:3000/api';
    
    static String getShipmentUrl(String shipmentId) {
        return '$baseUrl/shipments/$shipmentId';
    }
    
    static String confirmDeliveryUrl(String shipmentId) {
        return '$baseUrl/shipments/$shipmentId/deliver';
    }
}

