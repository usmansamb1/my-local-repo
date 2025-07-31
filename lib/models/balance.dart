class Balance {
  final double totalBalance;
  final double walletBalance;
  final int points;
  final double rewardBalance;

  Balance({
    required this.totalBalance,
    required this.walletBalance,
    required this.points,
    required this.rewardBalance,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalBalance': totalBalance,
      'walletBalance': walletBalance,
      'points': points,
      'rewardBalance': rewardBalance,
    };
  }

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      totalBalance: json['totalBalance'].toDouble(),
      walletBalance: json['walletBalance'].toDouble(),
      points: json['points'],
      rewardBalance: json['rewardBalance'].toDouble(),
    );
  }

  static Balance empty() {
    return Balance(
      totalBalance: 0.0,
      walletBalance: 0.0,
      points: 0,
      rewardBalance: 0.0,
    );
  }
}