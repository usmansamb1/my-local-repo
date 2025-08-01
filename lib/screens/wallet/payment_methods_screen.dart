import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/payment_method.dart';
import '../../utils/constants.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  List<PaymentMethod> paymentMethods = [];

  @override
  void initState() {
    super.initState();
    paymentMethods = PaymentMethod.getDemoPaymentMethods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Payment Methods'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addPaymentMethod,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Cards & Bank Accounts', 'card'),
            ...paymentMethods
                .where((pm) => pm.isCard || pm.isBank)
                .map((pm) => _buildPaymentMethodCard(pm))
                .toList(),
            const SizedBox(height: 24),
            _buildSectionHeader('Digital Wallets', 'ewallet'),
            ...paymentMethods
                .where((pm) => pm.isEWallet)
                .map((pm) => _buildPaymentMethodCard(pm))
                .toList(),
            const SizedBox(height: 24),
            _buildSectionHeader('Reward Points', 'points'),
            ...paymentMethods
                .where((pm) => pm.isPoints)
                .map((pm) => _buildPaymentMethodCard(pm))
                .toList(),
            const SizedBox(height: 24),
            _buildAddMethodButtons(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String type) {
    final items = paymentMethods.where((pm) => _getTypeGroup(pm.type) == type).length;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          Text(
            '$items method${items != 1 ? 's' : ''}',
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _getTypeGroup(String type) {
    switch (type) {
      case 'card':
      case 'bank':
        return 'card';
      case 'ewallet':
        return 'ewallet';
      case 'points':
        return 'points';
      default:
        return 'card';
    }
  }

  Widget _buildPaymentMethodCard(PaymentMethod paymentMethod) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showPaymentMethodDetails(paymentMethod),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getPaymentMethodColor(paymentMethod.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getPaymentMethodIcon(paymentMethod.type),
                    color: _getPaymentMethodColor(paymentMethod.type),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            paymentMethod.displayName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          if (paymentMethod.isDefault) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'DEFAULT',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getPaymentMethodSubtitle(paymentMethod),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) => _handleMenuAction(value, paymentMethod),
                  itemBuilder: (context) => [
                    if (!paymentMethod.isDefault)
                      const PopupMenuItem(
                        value: 'set_default',
                        child: Text('Set as Default'),
                      ),
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    PopupMenuItem(
                      value: paymentMethod.isActive ? 'disable' : 'enable',
                      child: Text(paymentMethod.isActive ? 'Disable' : 'Enable'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                  child: const Icon(
                    Icons.more_vert,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddMethodButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add New Payment Method',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _buildAddMethodButton(
          'Add Credit/Debit Card',
          Icons.credit_card,
          Colors.blue,
          () => _addNewPaymentMethod('card'),
        ),
        const SizedBox(height: 12),
        _buildAddMethodButton(
          'Link Bank Account',
          Icons.account_balance,
          Colors.green,
          () => _addNewPaymentMethod('bank'),
        ),
        const SizedBox(height: 12),
        _buildAddMethodButton(
          'Add Digital Wallet',
          Icons.account_balance_wallet,
          Colors.purple,
          () => _addNewPaymentMethod('ewallet'),
        ),
      ],
    );
  }

  Widget _buildAddMethodButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
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

  String _getPaymentMethodSubtitle(PaymentMethod paymentMethod) {
    if (paymentMethod.expiryDate != null) {
      return 'Expires ${paymentMethod.expiryDate}';
    }
    if (paymentMethod.bankName != null) {
      return paymentMethod.bankName!;
    }
    if (paymentMethod.isPoints) {
      return 'Redeem points for purchases';
    }
    return 'Added ${_formatDate(paymentMethod.createdAt)}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showPaymentMethodDetails(PaymentMethod paymentMethod) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: _getPaymentMethodColor(paymentMethod.type).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          _getPaymentMethodIcon(paymentMethod.type),
                          color: _getPaymentMethodColor(paymentMethod.type),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              paymentMethod.displayName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getPaymentMethodSubtitle(paymentMethod),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (paymentMethod.isDefault)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'This is your default payment method',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _editPaymentMethod(paymentMethod);
                      },
                      child: const Text('Edit Payment Method'),
                    ),
                  ),
                  if (!paymentMethod.isDefault) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _setAsDefault(paymentMethod);
                        },
                        child: const Text('Set as Default'),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _deletePaymentMethod(paymentMethod);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Delete Payment Method'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(String action, PaymentMethod paymentMethod) {
    switch (action) {
      case 'set_default':
        _setAsDefault(paymentMethod);
        break;
      case 'edit':
        _editPaymentMethod(paymentMethod);
        break;
      case 'disable':
      case 'enable':
        _togglePaymentMethod(paymentMethod);
        break;
      case 'delete':
        _deletePaymentMethod(paymentMethod);
        break;
    }
  }

  void _addPaymentMethod() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                'Add Payment Method',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.credit_card, color: Colors.blue),
              title: const Text('Credit/Debit Card'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                _addNewPaymentMethod('card');
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance, color: Colors.green),
              title: const Text('Bank Account'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                _addNewPaymentMethod('bank');
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet, color: Colors.purple),
              title: const Text('Digital Wallet'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                _addNewPaymentMethod('ewallet');
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _addNewPaymentMethod(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Add $type functionality would be implemented here'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _editPaymentMethod(PaymentMethod paymentMethod) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit payment method functionality would be implemented here'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _setAsDefault(PaymentMethod paymentMethod) {
    setState(() {
      for (var pm in paymentMethods) {
        pm.isDefault = pm.id == paymentMethod.id;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${paymentMethod.displayName} set as default'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _togglePaymentMethod(PaymentMethod paymentMethod) {
    setState(() {
      paymentMethod.isActive = !paymentMethod.isActive;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${paymentMethod.displayName} ${paymentMethod.isActive ? 'enabled' : 'disabled'}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _deletePaymentMethod(PaymentMethod paymentMethod) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Payment Method'),
        content: Text(
          'Are you sure you want to delete ${paymentMethod.displayName}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                paymentMethods.removeWhere((pm) => pm.id == paymentMethod.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${paymentMethod.displayName} deleted'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}