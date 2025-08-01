class PaymentMethod {
  final String id;
  final String type; // 'card', 'bank', 'ewallet', 'points'
  final String name;
  final String displayName; // e.g., "Visa **** 4532"
  final String? cardNumber; // masked number
  final String? expiryDate;
  final String? bankName;
  final String? accountNumber; // masked number
  bool isDefault;
  bool isActive;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.name,
    required this.displayName,
    this.cardNumber,
    this.expiryDate,
    this.bankName,
    this.accountNumber,
    required this.isDefault,
    required this.isActive,
    required this.createdAt,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'displayName': displayName,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'isDefault': isDefault,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      type: json['type'],
      name: json['name'],
      displayName: json['displayName'],
      cardNumber: json['cardNumber'],
      expiryDate: json['expiryDate'],
      bankName: json['bankName'],
      accountNumber: json['accountNumber'],
      isDefault: json['isDefault'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      metadata: json['metadata'],
    );
  }

  bool get isCard => type == 'card';
  bool get isBank => type == 'bank';
  bool get isEWallet => type == 'ewallet';
  bool get isPoints => type == 'points';

  String get icon {
    switch (type) {
      case 'card':
        if (name.toLowerCase().contains('visa')) return 'visa';
        if (name.toLowerCase().contains('mastercard')) return 'mastercard';
        if (name.toLowerCase().contains('mada')) return 'mada';
        return 'card';
      case 'bank':
        return 'bank';
      case 'ewallet':
        if (name.toLowerCase().contains('stc')) return 'stc_pay';
        if (name.toLowerCase().contains('apple')) return 'apple_pay';
        return 'wallet';
      case 'points':
        return 'points';
      default:
        return 'payment';
    }
  }

  static List<PaymentMethod> getDemoPaymentMethods() {
    return [
      PaymentMethod(
        id: 'pm_001',
        type: 'card',
        name: 'Visa Credit Card',
        displayName: 'Visa **** 4532',
        cardNumber: '**** **** **** 4532',
        expiryDate: '12/26',
        isDefault: true,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      PaymentMethod(
        id: 'pm_002',
        type: 'card',
        name: 'Mada Debit Card',
        displayName: 'Mada **** 8765',
        cardNumber: '**** **** **** 8765',
        expiryDate: '08/25',
        isDefault: false,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      PaymentMethod(
        id: 'pm_003',
        type: 'ewallet',
        name: 'STC Pay',
        displayName: 'STC Pay - 05XXXXXXX',
        isDefault: false,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      PaymentMethod(
        id: 'pm_004',
        type: 'bank',
        name: 'Al Rajhi Bank',
        displayName: 'Al Rajhi **** 1234',
        bankName: 'Al Rajhi Bank',
        accountNumber: '**** **** **** 1234',
        isDefault: false,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
      ),
      PaymentMethod(
        id: 'pm_005',
        type: 'points',
        name: 'FuelApp Points',
        displayName: 'FuelApp Reward Points',
        isDefault: false,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
      ),
    ];
  }
}