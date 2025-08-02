import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

class FuelAppQuickScreen extends StatefulWidget {
  const FuelAppQuickScreen({super.key});

  @override
  State<FuelAppQuickScreen> createState() => _FuelAppQuickScreenState();
}

class _FuelAppQuickScreenState extends State<FuelAppQuickScreen> {
  String? selectedVehicle;
  String selectedFuelType = '91';
  final TextEditingController _amountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  
  final List<QuickVehicle> vehicles = [
    QuickVehicle(model: 'Hyundai', plateNumber: '9876', icon: Icons.directions_car),
    QuickVehicle(model: 'Toyota Camry', plateNumber: '1234', icon: Icons.directions_car),
    QuickVehicle(model: 'Honda Accord', plateNumber: '5678', icon: Icons.directions_car),
    QuickVehicle(model: 'Nissan Altima', plateNumber: '2468', icon: Icons.directions_car),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('FuelApp Quick'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Choose Vehicle Section
                const Text(
                  'Choose Vehicle',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Vehicle Selection Dropdown
                DropdownButtonFormField<String>(
                  value: selectedVehicle,
                  decoration: InputDecoration(
                    hintText: 'Select a vehicle',
                    prefixIcon: const Icon(Icons.directions_car),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                    ),
                  ),
                  items: vehicles.map((vehicle) {
                    return DropdownMenuItem<String>(
                      value: vehicle.model,
                      child: Row(
                        children: [
                          Icon(vehicle.icon, size: 20, color: AppTheme.primaryColor),
                          const SizedBox(width: 8),
                          Text('${vehicle.model} - ${vehicle.plateNumber}'),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedVehicle = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a vehicle';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Add new vehicle button
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Add vehicle functionality would be implemented here')),
                    );
                  },
                  icon: const Icon(Icons.add, color: AppTheme.primaryColor),
                  label: const Text(
                    '1. Vehicles are selected',
                    style: TextStyle(color: AppTheme.primaryColor),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Fuel Type Section
                const Text(
                  'Fuel Type',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Fuel Type Selection
                Row(
                  children: [
                    Expanded(
                      child: _buildFuelTypeOption('91', true),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildFuelTypeOption('Diesel', false),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Fuel Amount Section
                const Text(
                  'Fuel Amount for 91',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Amount Input
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: InputDecoration(
                    hintText: 'Enter amount',
                    prefixText: 'SAR ',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter fuel amount';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'FuelApp Quick Request',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Info Text
                Center(
                  child: Text(
                    'FuelApp Quick Page',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildFuelTypeOption(String type, bool is91) {
    final isSelected = selectedFuelType == type;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFuelType = type;
        });
        HapticFeedback.lightImpact();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              is91 ? Icons.local_gas_station : Icons.local_gas_station_outlined,
              color: isSelected ? Colors.white : AppTheme.primaryColor,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              type,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      // Simulate sending email
      await Future.delayed(const Duration(seconds: 2));
      
      // In a real implementation, email content would be sent here
      // with vehicle info, fuel type, amount, user, and timestamp
      
      setState(() {
        _isLoading = false;
      });
      
      // Show success dialog
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 32),
                SizedBox(width: 12),
                Text('Request Sent!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your FuelApp Quick request has been sent to the admin.'),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Vehicle: $selectedVehicle'),
                      Text('Fuel Type: $selectedFuelType'),
                      Text('Amount: SAR ${_amountController.text}'),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
  
  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}

class QuickVehicle {
  final String model;
  final String plateNumber;
  final IconData icon;
  
  QuickVehicle({
    required this.model,
    required this.plateNumber,
    required this.icon,
  });
}