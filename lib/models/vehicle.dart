class Vehicle {
  final String id;
  final String plateNumber;
  final String make;
  final String model;
  final int year;
  final String color;
  final String type; // 'sedan', 'suv', 'truck', etc.
  final double balance; // Vehicle-specific balance
  final DateTime createdAt;
  final bool isActive;
  final String? notes;

  Vehicle({
    required this.id,
    required this.plateNumber,
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.type,
    required this.balance,
    required this.createdAt,
    required this.isActive,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plateNumber': plateNumber,
      'make': make,
      'model': model,
      'year': year,
      'color': color,
      'type': type,
      'balance': balance,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
      'notes': notes,
    };
  }

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      plateNumber: json['plateNumber'],
      make: json['make'],
      model: json['model'],
      year: json['year'],
      color: json['color'],
      type: json['type'],
      balance: json['balance'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      isActive: json['isActive'],
      notes: json['notes'],
    );
  }

  String get displayName => '$make $model ($year)';
  String get formattedBalance => '﷼ ${balance.toStringAsFixed(2)}';

  static List<Vehicle> getDemoVehicles() {
    return [
      Vehicle(
        id: 'v001',
        plateNumber: 'ABC 1234',
        make: 'Toyota',
        model: 'Camry',
        year: 2022,
        color: 'White',
        type: 'sedan',
        balance: 250.64,
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
        isActive: true,
        notes: 'Primary family car',
      ),
      Vehicle(
        id: 'v002',
        plateNumber: 'XYZ 5678',
        make: 'BMW',
        model: 'X5',
        year: 2021,
        color: 'Black',
        type: 'suv',
        balance: 119.31,
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
        isActive: true,
        notes: 'Weekend car',
      ),
      Vehicle(
        id: 'v003',
        plateNumber: 'LMN 9012',
        make: 'Mercedes',
        model: 'C-Class',
        year: 2023,
        color: 'Silver',
        type: 'sedan',
        balance: 224.34,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        isActive: true,
      ),
    ];
  }
}

class VehicleReport {
  final String id;
  final String vehicleId;
  final DateTime startDate;
  final DateTime endDate;
  final double totalLiters;
  final double totalAmount;
  final String currency;
  final List<FuelTransaction> transactions;

  VehicleReport({
    required this.id,
    required this.vehicleId,
    required this.startDate,
    required this.endDate,
    required this.totalLiters,
    required this.totalAmount,
    required this.currency,
    required this.transactions,
  });

  double get averageConsumption => totalLiters / daysBetween;
  int get daysBetween => endDate.difference(startDate).inDays + 1;
  double get averageDaily => totalAmount / daysBetween;

  static List<VehicleReport> getDemoReports() {
    return [
      VehicleReport(
        id: 'r001',
        vehicleId: 'v001',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2025, 7, 1),
        totalLiters: 274.4,
        totalAmount: 599.4,
        currency: 'SAR',
        transactions: FuelTransaction.getDemoTransactions(),
      ),
    ];
  }
}

class FuelTransaction {
  final String id;
  final String stationName;
  final DateTime date;
  final double liters;
  final double amount;
  final String fuelType;
  final String vehicleId;

  FuelTransaction({
    required this.id,
    required this.stationName,
    required this.date,
    required this.liters,
    required this.amount,
    required this.fuelType,
    required this.vehicleId,
  });

  static List<FuelTransaction> getDemoTransactions() {
    return [
      FuelTransaction(
        id: 'ft001',
        stationName: 'Zulum - Zulum Station 2',
        date: DateTime.now().subtract(const Duration(days: 2)),
        liters: 46.0,
        amount: 139.0,
        fuelType: '95',
        vehicleId: 'v001',
      ),
      FuelTransaction(
        id: 'ft002',
        stationName: 'Abu Bakr 2',
        date: DateTime.now().subtract(const Duration(days: 5)),
        liters: 48.0,
        amount: 139.0,
        fuelType: '95',
        vehicleId: 'v001',
      ),
      FuelTransaction(
        id: 'ft003',
        stationName: 'Takhasusi 2',
        date: DateTime.now().subtract(const Duration(days: 10)),
        liters: 53.0,
        amount: 273.36,
        fuelType: '95',
        vehicleId: 'v001',
      ),
      FuelTransaction(
        id: 'ft004',
        stationName: 'FuelApp Station - FAISAL BIN',
        date: DateTime.now().subtract(const Duration(days: 15)),
        liters: 48.0,
        amount: 113.0,
        fuelType: '95',
        vehicleId: 'v001',
      ),
    ];
  }
}