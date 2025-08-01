import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../models/payment_method.dart';
import '../../utils/constants.dart';
import '../../widgets/primary_button.dart';

class AddBalanceScreen extends StatefulWidget {
  const AddBalanceScreen({super.key});

  @override
  State<AddBalanceScreen> createState() => _AddBalanceScreenState();
}

class _AddBalanceScreenState extends State<AddBalanceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  List<PaymentMethod> paymentMethods = [];
  PaymentMethod? selectedPaymentMethod;
  bool _isLoading = false;

  final List<double> quickAmounts = [50, 100, 200, 500];

  @override
  void initState() {
    super.initState();
    paymentMethods = PaymentMethod.getDemoPaymentMethods();
    selectedPaymentMethod = paymentMethods.firstWhere(
      (pm) => pm.isDefault,
      orElse: () => paymentMethods.first,
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Add Balance'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCurrentBalanceCard(),
              const SizedBox(height: 24),
              _buildAmountSection(),
              const SizedBox(height: 24),
              _buildPaymentMethodSection(),
              const SizedBox(height: 32),
              _buildAddBalanceButton(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Wallet Balance',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'SAR 0.00',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.account_balance_wallet,
                color: Colors.white70,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Add money to your FuelApp wallet',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter Amount',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            decoration: const InputDecoration(
              hintText: '0.00',
              prefixText: 'SAR ',
              prefixStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
            ),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount';
              }
              final amount = double.tryParse(value);
              if (amount == null || amount <= 0) {
                return 'Please enter a valid amount';
              }
              if (amount < 10) {
                return 'Minimum amount is SAR 10';
              }
              if (amount > 5000) {
                return 'Maximum amount is SAR 5000';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Quick amounts',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: quickAmounts.map((amount) => _buildQuickAmountChip(amount)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAmountChip(double amount) {
    return GestureDetector(
      onTap: () {
        _amountController.text = amount.toStringAsFixed(0);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.primaryColor.withOpacity(0.3),
          ),
        ),
        child: Text(
          'SAR ${amount.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, Constants.paymentMethodsRoute);
                },
                child: const Text('Manage'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...paymentMethods.take(3).map((pm) => _buildPaymentMethodTile(pm)).toList(),
          if (paymentMethods.length > 3)
            TextButton(
              onPressed: () {
                _showAllPaymentMethods();
              },
              child: Text('View all ${paymentMethods.length} methods'),
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile(PaymentMethod paymentMethod) {
    final isSelected = selectedPaymentMethod?.id == paymentMethod.id;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              selectedPaymentMethod = paymentMethod;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
                width: isSelected ? 2 : 1,
              ),
              color: isSelected ? AppTheme.primaryColor.withOpacity(0.05) : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getPaymentMethodColor(paymentMethod.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getPaymentMethodIcon(paymentMethod.type),
                    color: _getPaymentMethodColor(paymentMethod.type),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        paymentMethod.displayName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      if (paymentMethod.isDefault)
                        const Text(
                          'Default',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                    ],
                  ),
                ),
                Radio<PaymentMethod>(
                  value: paymentMethod,
                  groupValue: selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value;
                    });
                  },
                  activeColor: AppTheme.primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddBalanceButton() {
    return PrimaryButton(
      text: 'Add Balance',
      onPressed: _isLoading ? null : _addBalance,
      isLoading: _isLoading,
    );
  }

  Color _getPaymentMethodColor(String type) {
    switch (type) {
      case 'card':
        return Colors.blue;
      case 'bank':
        return Colors.green;
      case 'ewallet':
        return Colors.purple;
      case 'points':
        return Colors.orange;
      default:
        return AppTheme.primaryColor;
    }
  }

  IconData _getPaymentMethodIcon(String type) {
    switch (type) {
      case 'card':
        return Icons.credit_card;
      case 'bank':
        return Icons.account_balance;
      case 'ewallet':
        return Icons.account_balance_wallet;
      case 'points':
        return Icons.stars;
      default:
        return Icons.payment;
    }
  }

  void _showAllPaymentMethods() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Select Payment Method',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: paymentMethods.length,
                itemBuilder: (context, index) {
                  final pm = paymentMethods[index];
                  return _buildPaymentMethodTile(pm);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addBalance() async {
    if (!_formKey.currentState!.validate() || selectedPaymentMethod == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Constants.mockDelay);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'Balance Added Successfully!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'SAR ${_amountController.text} has been added to your wallet',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Go back to previous screen
                  },
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}