import 'package:flutter/material.dart';
import '../models/shipment_model.dart';
import '../services/api_service.dart';

class DeliveryScreen extends StatefulWidget {
    const DeliveryScreen({super.key});

    @override
    State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
    final _shipmentIdController = TextEditingController();
    final _otpController = TextEditingController();
    final _agentNameController = TextEditingController();
    
    Shipment? _shipment;
    bool _isLoading = false;
    String? _errorMessage;
    String? _successMessage;

    Future<void> _fetchShipmentDetails({bool preserveSuccessMessage = false}) async {
        if (_shipmentIdController.text.isEmpty) {
            setState(() {
                _errorMessage = 'Please enter Shipment ID';
                _successMessage = null;
            });
            return;
        }

        setState(() {
            _isLoading = true;
            _errorMessage = null;
            if (!preserveSuccessMessage) {
                _successMessage = null;
            }
            _shipment = null;
        });

        final result = await ApiService.getShipmentDetails(_shipmentIdController.text.trim());

        setState(() {
            _isLoading = false;
            if (result['success']) {
                _shipment = result['data'];
                _errorMessage = null;
                // Keep success message if preserving
            } else {
                _errorMessage = result['message'];
                _shipment = null;
                if (!preserveSuccessMessage) {
                    _successMessage = null;
                }
            }
        });
    }

    Future<void> _confirmDelivery() async {
        if (_otpController.text.isEmpty || _agentNameController.text.isEmpty) {
            setState(() {
                _errorMessage = 'Please enter OTP and Agent Name';
                _successMessage = null;
            });
            return;
        }

        if (_shipment == null) {
            setState(() {
                _errorMessage = 'Please fetch shipment details first';
                _successMessage = null;
            });
            return;
        }

        setState(() {
            _isLoading = true;
            _errorMessage = null;
            _successMessage = null;
        });

        final result = await ApiService.confirmDelivery(
            _shipment!.shipmentId,
            _otpController.text.trim(),
            _agentNameController.text.trim(),
        );

        setState(() {
            _isLoading = false;
            if (result['success']) {
                _successMessage = 'Delivery Success!';
                _errorMessage = null;
                // Refresh shipment details (preserve success message)
                _fetchShipmentDetails(preserveSuccessMessage: true);
            } else {
                _errorMessage = result['message'];
                _successMessage = null;
            }
        });
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text(
                    'Last Mile Delivery',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                    ),
                ),
                backgroundColor: const Color(0xFF00A8E8), // Lenskart blue
                foregroundColor: Colors.white,
                elevation: 0,
            ),
            backgroundColor: Colors.grey.shade50,
            body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                        // Shipment ID Input Section
                        Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                        const Text(
                                            'Enter Shipment ID',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF00A8E8),
                                            ),
                                        ),
                                        const SizedBox(height: 16),
                                        TextField(
                                            controller: _shipmentIdController,
                                            decoration: InputDecoration(
                                                labelText: 'Shipment ID',
                                                hintText: 'e.g., SHIP001',
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white,
                                                prefixIcon: const Icon(Icons.local_shipping),
                                            ),
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                            onPressed: _isLoading ? null : _fetchShipmentDetails,
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFF00A8E8),
                                                foregroundColor: Colors.white,
                                                padding: const EdgeInsets.symmetric(vertical: 16),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                ),
                                                elevation: 2,
                                            ),
                                            child: const Text(
                                                'Fetch Details',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                ),
                                            ),
                                        ),
                                    ],
                                ),
                            ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Shipment Details Display
                        if (_shipment != null)
                            Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                ),
                                color: Colors.white,
                                child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Row(
                                                children: [
                                                    const Icon(
                                                        Icons.info_outline,
                                                        color: Color(0xFF00A8E8),
                                                        size: 24,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    const Text(
                                                        'Shipment Details',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.bold,
                                                            color: Color(0xFF00A8E8),
                                                        ),
                                                    ),
                                                ],
                                            ),
                                            const SizedBox(height: 16),
                                            _buildDetailRow('Shipment ID:', _shipment!.shipmentId),
                                            _buildDetailRow('Customer Name:', _shipment!.customerName),
                                            _buildDetailRow('Status:', _shipment!.status),
                                            if (_shipment!.deliveredBy != null)
                                                _buildDetailRow('Delivered By:', _shipment!.deliveredBy!),
                                        ],
                                    ),
                                ),
                            ),
                        
                        const SizedBox(height: 16),
                        
                        // Delivery Confirmation Section
                        if (_shipment != null && _shipment!.status != 'Delivered')
                            Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                            const Text(
                                                'Confirm Delivery',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF00A8E8),
                                                ),
                                            ),
                                            const SizedBox(height: 16),
                                            TextField(
                                                controller: _agentNameController,
                                                decoration: InputDecoration(
                                                    labelText: 'Agent Name',
                                                    hintText: 'Enter your name',
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    prefixIcon: const Icon(Icons.person),
                                                ),
                                            ),
                                            const SizedBox(height: 16),
                                            TextField(
                                                controller: _otpController,
                                                decoration: InputDecoration(
                                                    labelText: 'OTP',
                                                    hintText: 'Enter OTP from customer',
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    prefixIcon: const Icon(Icons.lock),
                                                ),
                                                keyboardType: TextInputType.number,
                                            ),
                                            const SizedBox(height: 20),
                                            ElevatedButton(
                                                onPressed: _isLoading ? null : _confirmDelivery,
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.green.shade600,
                                                    foregroundColor: Colors.white,
                                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    elevation: 2,
                                                ),
                                                child: const Text(
                                                    'Confirm Delivery',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                    ),
                                                ),
                                            ),
                                        ],
                                    ),
                                ),
                            ),
                        
                        // Error Message
                        if (_errorMessage != null)
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.red.shade300, width: 1.5),
                                    ),
                                    child: Row(
                                        children: [
                                            const Icon(Icons.error_outline, color: Colors.red),
                                            const SizedBox(width: 12),
                                            Expanded(
                                                child: Text(
                                                    _errorMessage!,
                                                    style: const TextStyle(
                                                        color: Colors.red,
                                                        fontWeight: FontWeight.w500,
                                                    ),
                                                ),
                                            ),
                                        ],
                                    ),
                                ),
                            ),
                        
                        // Success Message
                        if (_successMessage != null)
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: Colors.green.shade400, width: 2),
                                        boxShadow: [
                                            BoxShadow(
                                                color: Colors.green.shade200,
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                            ),
                                        ],
                                    ),
                                    child: Row(
                                        children: [
                                            const Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                                size: 32,
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                                child: Text(
                                                    _successMessage!,
                                                    style: const TextStyle(
                                                        color: Colors.green,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 18,
                                                    ),
                                                ),
                                            ),
                                        ],
                                    ),
                                ),
                            ),
                        
                        // Loading Indicator
                        if (_isLoading)
                            const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(child: CircularProgressIndicator()),
                            ),
                    ],
                ),
            ),
        );
    }

    Widget _buildDetailRow(String label, String value) {
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    SizedBox(
                        width: 120,
                        child: Text(
                            label,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                    ),
                    Expanded(
                        child: Text(value),
                    ),
                ],
            ),
        );
    }

    @override
    void dispose() {
        _shipmentIdController.dispose();
        _otpController.dispose();
        _agentNameController.dispose();
        super.dispose();
    }
}

