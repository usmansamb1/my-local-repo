class Transaction {
  final String id;
  final String type; // 'fuel', 'topup', 'payment', 'refund', 'points'
  final double amount;
  final String currency;
  final String title;
  final String description;
  final DateTime date;
  final String status; // 'completed', 'pending', 'failed', 'cancelled'
  final String? refNumber;
  final String? stationName;
  final String? vehicleNumber;
  final Map<String, dynamic>? metadata;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.currency,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    this.refNumber,
    this.stationName,
    this.vehicleNumber,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'currency': currency,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'status': status,
      'refNumber': refNumber,
      'stationName': stationName,
      'vehicleNumber': vehicleNumber,
      'metadata': metadata,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      type: json['type'],
      amount: json['amount'].toDouble(),
      currency: json['currency'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      status: json['status'],
      refNumber: json['refNumber'],
      stationName: json['stationName'],
      vehicleNumber: json['vehicleNumber'],
      metadata: json['metadata'],
    );
  }

  bool get isCredit => ['topup', 'refund', 'points'].contains(type);
  bool get isDebit => ['fuel', 'payment'].contains(type);
  bool get isPending => status == 'pending';
  bool get isCompleted => status == 'completed';
  bool get isFailed => status == 'failed';

  static List<Transaction> getDemoTransactions() {
    return [
      Transaction(
        id: 'txn_001',
        type: 'fuel',
        amount: 150.50,
        currency: 'SAR',
        title: 'Fuel Purchase',
        description: 'FuelApp Station - Al Riyadh',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        status: 'completed',
        refNumber: 'FP001234',
        stationName: 'FuelApp Al Riyadh',
        vehicleNumber: 'ABC-1234',
      ),
      Transaction(
        id: 'txn_002',
        type: 'topup',
        amount: 500.00,
        currency: 'SAR',
        title: 'Wallet Top-up',
        description: 'Visa **** 4532',
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: 'completed',
        refNumber: 'TU001235',
      ),
      Transaction(
        id: 'txn_003',
        type: 'points',
        amount: 25.00,
        currency: 'PTS',
        title: 'Points Earned',
        description: 'Fuel purchase reward',
        date: DateTime.now().subtract(const Duration(days: 2)),
        status: 'completed',
      ),
      Transaction(
        id: 'txn_004',
        type: 'payment',
        amount: 85.75,
        currency: 'SAR',
        title: 'Mini Market',
        description: 'FuelApp Store - Jeddah',
        date: DateTime.now().subtract(const Duration(days: 3)),
        status: 'completed',
        refNumber: 'MM001236',
        stationName: 'FuelApp Jeddah',
      ),
      Transaction(
        id: 'txn_005',
        type: 'fuel',
        amount: 200.00,
        currency: 'SAR',
        title: 'Fuel Purchase',
        description: 'FuelApp Station - Dammam',
        date: DateTime.now().subtract(const Duration(days: 5)),
        status: 'completed',
        refNumber: 'FP001237',
        stationName: 'FuelApp Dammam',
        vehicleNumber: 'XYZ-5678',
      ),
    ];
  }
}