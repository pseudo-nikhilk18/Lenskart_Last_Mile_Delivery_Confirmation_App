class Shipment {
    final String shipmentId;
    final String customerName;
    final String status;
    final String? deliveredAt;
    final String? deliveredBy;

    Shipment({
        required this.shipmentId,
        required this.customerName,
        required this.status,
        this.deliveredAt,
        this.deliveredBy,
    });


    factory Shipment.fromJson(Map<String, dynamic> json) {
        return Shipment(
            shipmentId: json['shipmentId'] ?? '',
            customerName: json['customerName'] ?? '',
            status: json['status'] ?? '',
            deliveredAt: json['deliveredAt'],
            deliveredBy: json['deliveredBy'],
        );
    }
}

