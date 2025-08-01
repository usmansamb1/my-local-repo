class Invoice {
  final String id;
  final String invoiceNumber;
  final String type; // 'fuel', 'service', 'product'
  final double amount;
  final double taxAmount;
  final double totalAmount;
  final String currency;
  final DateTime issueDate;
  final DateTime dueDate;
  final String status; // 'paid', 'pending', 'overdue', 'cancelled'
  final String customerName;
  final String stationName;
  final String stationAddress;
  final List<InvoiceItem> items;
  final String? vehicleNumber;
  final String? notes;

  Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.type,
    required this.amount,
    required this.taxAmount,
    required this.totalAmount,
    required this.currency,
    required this.issueDate,
    required this.dueDate,
    required this.status,
    required this.customerName,
    required this.stationName,
    required this.stationAddress,
    required this.items,
    this.vehicleNumber,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceNumber': invoiceNumber,
      'type': type,
      'amount': amount,
      'taxAmount': taxAmount,
      'totalAmount': totalAmount,
      'currency': currency,
      'issueDate': issueDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'status': status,
      'customerName': customerName,
      'stationName': stationName,
      'stationAddress': stationAddress,
      'items': items.map((item) => item.toJson()).toList(),
      'vehicleNumber': vehicleNumber,
      'notes': notes,
    };
  }

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      invoiceNumber: json['invoiceNumber'],
      type: json['type'],
      amount: json['amount'].toDouble(),
      taxAmount: json['taxAmount'].toDouble(),
      totalAmount: json['totalAmount'].toDouble(),
      currency: json['currency'],
      issueDate: DateTime.parse(json['issueDate']),
      dueDate: DateTime.parse(json['dueDate']),
      status: json['status'],
      customerName: json['customerName'],
      stationName: json['stationName'],
      stationAddress: json['stationAddress'],
      items: (json['items'] as List).map((item) => InvoiceItem.fromJson(item)).toList(),
      vehicleNumber: json['vehicleNumber'],
      notes: json['notes'],
    );
  }

  bool get isPaid => status == 'paid';
  bool get isPending => status == 'pending';
  bool get isOverdue => status == 'overdue' || (status == 'pending' && DateTime.now().isAfter(dueDate));

  static List<Invoice> getDemoInvoices() {
    return [
      Invoice(
        id: 'inv_001',
        invoiceNumber: 'INV-2024-001',
        type: 'fuel',
        amount: 150.50,
        taxAmount: 22.58,
        totalAmount: 173.08,
        currency: 'SAR',
        issueDate: DateTime.now().subtract(const Duration(hours: 2)),
        dueDate: DateTime.now().add(const Duration(days: 30)),
        status: 'paid',
        customerName: 'Ahmed Al-Rashid',
        stationName: 'FuelApp Al Riyadh',
        stationAddress: 'King Fahd Road, Riyadh, Saudi Arabia',
        vehicleNumber: 'ABC-1234',
        items: [
          InvoiceItem(
            id: 'item_001',
            name: 'Premium Gasoline 95',
            quantity: 45.5,
            unit: 'Liters',
            unitPrice: 3.31,
            totalPrice: 150.50,
          ),
        ],
      ),
      Invoice(
        id: 'inv_002',
        invoiceNumber: 'INV-2024-002',
        type: 'service',
        amount: 85.75,
        taxAmount: 12.86,
        totalAmount: 98.61,
        currency: 'SAR',
        issueDate: DateTime.now().subtract(const Duration(days: 1)),
        dueDate: DateTime.now().add(const Duration(days: 29)),
        status: 'paid',
        customerName: 'Fatima Al-Zahra',
        stationName: 'FuelApp Jeddah',
        stationAddress: 'Corniche Road, Jeddah, Saudi Arabia',
        items: [
          InvoiceItem(
            id: 'item_002',
            name: 'Car Wash Premium',
            quantity: 1,
            unit: 'Service',
            unitPrice: 45.00,
            totalPrice: 45.00,
          ),
          InvoiceItem(
            id: 'item_003',
            name: 'Engine Oil Change',
            quantity: 1,
            unit: 'Service',
            unitPrice: 40.75,
            totalPrice: 40.75,
          ),
        ],
      ),
      Invoice(
        id: 'inv_003',
        invoiceNumber: 'INV-2024-003',
        type: 'product',
        amount: 45.20,
        taxAmount: 6.78,
        totalAmount: 51.98,
        currency: 'SAR',
        issueDate: DateTime.now().subtract(const Duration(days: 3)),
        dueDate: DateTime.now().add(const Duration(days: 27)),
        status: 'pending',
        customerName: 'Mohammed Al-Saudi',
        stationName: 'FuelApp Dammam',
        stationAddress: 'Prince Mohammed Bin Fahd Road, Dammam, Saudi Arabia',
        items: [
          InvoiceItem(
            id: 'item_004',
            name: 'Energy Drink',
            quantity: 2,
            unit: 'Pieces',
            unitPrice: 8.50,
            totalPrice: 17.00,
          ),
          InvoiceItem(
            id: 'item_005',
            name: 'Snacks Combo',
            quantity: 1,
            unit: 'Combo',
            unitPrice: 28.20,
            totalPrice: 28.20,
          ),
        ],
      ),
    ];
  }
}

class InvoiceItem {
  final String id;
  final String name;
  final double quantity;
  final String unit;
  final double unitPrice;
  final double totalPrice;

  InvoiceItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
    };
  }

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'].toDouble(),
      unit: json['unit'],
      unitPrice: json['unitPrice'].toDouble(),
      totalPrice: json['totalPrice'].toDouble(),
    );
  }
}