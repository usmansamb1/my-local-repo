import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/invoice.dart';
import '../../utils/constants.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Invoice> invoices = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    invoices = Invoice.getDemoInvoices();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Invoices'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Paid'),
            Tab(text: 'Pending'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInvoicesList(invoices),
          _buildInvoicesList(invoices.where((inv) => inv.isPaid).toList()),
          _buildInvoicesList(invoices.where((inv) => inv.isPending).toList()),
        ],
      ),
    );
  }

  Widget _buildInvoicesList(List<Invoice> invoices) {
    if (invoices.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: AppTheme.textSecondary,
            ),
            SizedBox(height: 16),
            Text(
              'No invoices found',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: invoices.length,
      itemBuilder: (context, index) {
        final invoice = invoices[index];
        return _buildInvoiceCard(invoice);
      },
    );
  }

  Widget _buildInvoiceCard(Invoice invoice) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          onTap: () => _navigateToInvoiceDetails(invoice),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      invoice.invoiceNumber,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(invoice.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        invoice.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(invoice.status),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  invoice.stationName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(invoice.issueDate),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getTypeIcon(invoice.type),
                          size: 20,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getTypeDisplay(invoice.type),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${invoice.currency} ${invoice.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'overdue':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      default:
        return AppTheme.textSecondary;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'fuel':
        return Icons.local_gas_station;
      case 'service':
        return Icons.build;
      case 'product':
        return Icons.shopping_bag;
      default:
        return Icons.receipt;
    }
  }

  String _getTypeDisplay(String type) {
    switch (type) {
      case 'fuel':
        return 'Fuel Purchase';
      case 'service':
        return 'Service';
      case 'product':
        return 'Products';
      default:
        return 'Invoice';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _navigateToInvoiceDetails(Invoice invoice) {
    Navigator.pushNamed(
      context,
      Constants.invoiceDetailsRoute,
      arguments: invoice,
    );
  }
}