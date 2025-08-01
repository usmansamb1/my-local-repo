import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../models/transaction.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailsScreen({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Transaction Details'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareTransaction(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTransactionHeader(),
            const SizedBox(height: 24),
            _buildTransactionDetails(),
            const SizedBox(height: 24),
            if (transaction.stationName != null) _buildStationInfo(),
            if (transaction.stationName != null) const SizedBox(height: 24),
            _buildActionButtons(context),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _getStatusColor().withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getTransactionIcon(),
              size: 40,
              color: _getStatusColor(),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            transaction.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '${transaction.isCredit ? '+' : '-'}${transaction.currency} ${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: _getAmountColor(),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              transaction.status.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _getStatusColor(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionDetails() {
    return Container(
      width: double.infinity,
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
            'Transaction Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Transaction ID', transaction.id),
          const SizedBox(height: 12),
          if (transaction.refNumber != null) ...[
            _buildDetailRow('Reference Number', transaction.refNumber!),
            const SizedBox(height: 12),
          ],
          _buildDetailRow('Date & Time', _formatDateTime(transaction.date)),
          const SizedBox(height: 12),
          _buildDetailRow('Type', _getTypeDisplay()),
          const SizedBox(height: 12),
          _buildDetailRow('Amount', '${transaction.currency} ${transaction.amount.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          _buildDetailRow('Status', transaction.status.toUpperCase()),
          if (transaction.vehicleNumber != null) ...[
            const SizedBox(height: 12),
            _buildDetailRow('Vehicle', transaction.vehicleNumber!),
          ],
          if (transaction.description.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildDetailRow('Description', transaction.description),
          ],
        ],
      ),
    );
  }

  Widget _buildStationInfo() {
    return Container(
      width: double.infinity,
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
            children: [
              const Icon(
                Icons.local_gas_station,
                color: AppTheme.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Station Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Station', transaction.stationName!),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _viewOnMap,
                  icon: const Icon(Icons.map, size: 18),
                  label: const Text('View on Map'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: const BorderSide(color: AppTheme.primaryColor),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _getDirections,
                  icon: const Icon(Icons.directions, size: 18),
                  label: const Text('Directions'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: const BorderSide(color: AppTheme.primaryColor),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (label == 'Transaction ID' || label == 'Reference Number') {
                _copyToClipboard(value);
              }
            },
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: (label == 'Transaction ID' || label == 'Reference Number')
                    ? AppTheme.primaryColor
                    : AppTheme.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        if (transaction.isPending) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _cancelTransaction(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Cancel Transaction',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _downloadReceipt,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  side: const BorderSide(color: AppTheme.primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Download Receipt'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: _reportIssue,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  side: const BorderSide(color: AppTheme.primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Report Issue'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getStatusColor() {
    switch (transaction.status) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      default:
        return AppTheme.textSecondary;
    }
  }

  Color _getAmountColor() {
    if (transaction.isFailed) return Colors.grey;
    return transaction.isCredit ? Colors.green : Colors.red;
  }

  IconData _getTransactionIcon() {
    switch (transaction.type) {
      case 'fuel':
        return Icons.local_gas_station;
      case 'topup':
        return Icons.add_circle;
      case 'payment':
        return Icons.shopping_cart;
      case 'refund':
        return Icons.refresh;
      case 'points':
        return Icons.stars;
      default:
        return Icons.receipt;
    }
  }

  String _getTypeDisplay() {
    switch (transaction.type) {
      case 'fuel':
        return 'Fuel Purchase';
      case 'topup':
        return 'Wallet Top-up';
      case 'payment':
        return 'Payment';
      case 'refund':
        return 'Refund';
      case 'points':
        return 'Points';
      default:
        return 'Transaction';
    }
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  void _shareTransaction() {
    // Implement transaction sharing
  }

  void _cancelTransaction(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Transaction'),
        content: const Text(
          'Are you sure you want to cancel this transaction? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Transaction'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Transaction cancelled successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Cancel Transaction'),
          ),
        ],
      ),
    );
  }

  void _downloadReceipt() {
    // Implement receipt download
  }

  void _reportIssue() {
    // Implement issue reporting
  }

  void _viewOnMap() {
    // Implement map view
  }

  void _getDirections() {
    // Implement directions
  }
}