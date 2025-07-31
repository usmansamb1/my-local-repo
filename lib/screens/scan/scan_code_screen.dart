import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import 'dart:math' as math;

class ScanCodeScreen extends StatefulWidget {
  const ScanCodeScreen({super.key});

  @override
  State<ScanCodeScreen> createState() => _ScanCodeScreenState();
}

class _ScanCodeScreenState extends State<ScanCodeScreen> {
  String? selectedVehicle;
  final ScrollController _scrollController = ScrollController();
  
  final List<Vehicle> vehicles = [
    Vehicle(model: 'Hyundai', plateNumber: '9876 ABC', isSelected: false),
    Vehicle(model: 'Toyota Camry', plateNumber: '1234 XYZ', isSelected: false),
    Vehicle(model: 'Honda Accord', plateNumber: '5678 DEF', isSelected: false),
    Vehicle(model: 'Nissan Altima', plateNumber: '2468 GHI', isSelected: false),
    Vehicle(model: 'Ford Fusion', plateNumber: '1357 JKL', isSelected: false),
    Vehicle(model: 'Mazda 6', plateNumber: '9753 MNO', isSelected: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B4B99),
        foregroundColor: Colors.white,
        title: const Text('Scan QR', style: TextStyle(fontSize: 18)),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Fixed QR Code Area
          Container(
            height: 350,
            decoration: const BoxDecoration(
              color: Color(0xFF4B4B99),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // QR Code Display
                if (selectedVehicle != null) ...[
                  Container(
                    width: 220,
                    height: 220,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: CustomPaint(
                      size: const Size(200, 200),
                      painter: QRCodePainter(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'QR Code for $selectedVehicle',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ] else ...[
                  const Icon(
                    Icons.qr_code_scanner,
                    size: 120,
                    color: Colors.white30,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Select a vehicle to generate QR code',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Choose Vehicle Header
          Container(
            padding: const EdgeInsets.all(16),
            child: const Row(
              children: [
                Text(
                  'Choose Vehicle',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                Spacer(),
                Text(
                  'Show All',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Scrollable Vehicle List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];
                final isSelected = selectedVehicle == vehicle.model;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppTheme.primaryColor.withOpacity(0.1)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.directions_car,
                        color: isSelected ? AppTheme.primaryColor : Colors.grey[600],
                        size: 28,
                      ),
                    ),
                    title: Text(
                      vehicle.model,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: isSelected ? AppTheme.primaryColor : Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      vehicle.plateNumber,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    trailing: Radio<String>(
                      value: vehicle.model,
                      groupValue: selectedVehicle,
                      onChanged: (value) {
                        setState(() {
                          selectedVehicle = value;
                        });
                        HapticFeedback.lightImpact();
                      },
                      activeColor: AppTheme.primaryColor,
                    ),
                    onTap: () {
                      setState(() {
                        selectedVehicle = vehicle.model;
                      });
                      HapticFeedback.lightImpact();
                    },
                  ),
                );
              },
            ),
          ),
          
          // Bottom Action Button
          if (selectedVehicle != null)
            Container(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('QR Code generated for $selectedVehicle'),
                      action: SnackBarAction(
                        label: 'Share',
                        onPressed: () {},
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Use This QR Code',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class Vehicle {
  final String model;
  final String plateNumber;
  final bool isSelected;
  
  Vehicle({
    required this.model,
    required this.plateNumber,
    required this.isSelected,
  });
}

// Custom QR Code Painter
class QRCodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    
    final random = math.Random(42); // Fixed seed for consistent pattern
    final moduleSize = size.width / 25;
    
    // Draw QR code pattern
    for (int row = 0; row < 25; row++) {
      for (int col = 0; col < 25; col++) {
        // Create position detection patterns
        if ((row < 7 && col < 7) || 
            (row < 7 && col >= 18) || 
            (row >= 18 && col < 7)) {
          // Draw position detection pattern
          if ((row == 0 || row == 6 || col == 0 || col == 6) ||
              (row >= 2 && row <= 4 && col >= 2 && col <= 4)) {
            canvas.drawRect(
              Rect.fromLTWH(
                col * moduleSize,
                row * moduleSize,
                moduleSize,
                moduleSize,
              ),
              paint,
            );
          }
        } else if (random.nextBool()) {
          // Random pattern for data area
          canvas.drawRect(
            Rect.fromLTWH(
              col * moduleSize,
              row * moduleSize,
              moduleSize,
              moduleSize,
            ),
            paint,
          );
        }
      }
    }
    
    // Draw timing patterns
    for (int i = 8; i < 17; i++) {
      if (i % 2 == 0) {
        canvas.drawRect(
          Rect.fromLTWH(6 * moduleSize, i * moduleSize, moduleSize, moduleSize),
          paint,
        );
        canvas.drawRect(
          Rect.fromLTWH(i * moduleSize, 6 * moduleSize, moduleSize, moduleSize),
          paint,
        );
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}