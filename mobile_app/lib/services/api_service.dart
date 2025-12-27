import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/shipment_model.dart';
import '../utils/constants.dart';

class ApiService {
    // Fetch shipment details by ID
    static Future<Map<String, dynamic>> getShipmentDetails(String shipmentId) async {
        try{
            final url = ApiConstants.getShipmentUrl(shipmentId);
            final response = await http.get(Uri.parse(url));

            final data = json.decode(response.body);
            
            if(response.statusCode == 200){
                return{
                    'success': true,
                    'data': Shipment.fromJson(data['shipment']),
                };
            } 
            else{
                return{
                    'success': false,
                    'message': data['message'] ?? 'Failed to fetch shipment',
                };
            }
        } 
        catch(e){
            return{
                'success': false,
                'message': 'Error: ${e.toString()}',
            };
        }
    }

    // Confirm delivery
    static Future<Map<String, dynamic>> confirmDelivery(String shipmentId, String otp, String deliveredBy,) async {
        try{
            final url = ApiConstants.confirmDeliveryUrl(shipmentId);
            final response = await http.post(
                Uri.parse(url),
                headers: {'Content-Type': 'application/json'},
                body: json.encode({
                    'otp': otp,
                    'deliveredBy': deliveredBy,
                }),
            );

            final data = json.decode(response.body);
            
            if(response.statusCode == 200) {
                return{
                    'success': true,
                    'message': data['message'] ?? 'Delivery confirmed successfully',
                };
            } 
            else{
                return{
                    'success': false,
                    'message': data['message'] ?? 'Failed to confirm delivery',
                };
            }
        }
        catch(e){
            return{
                'success': false,
                'message': 'Error: ${e.toString()}',
            };
        }
    }
}

