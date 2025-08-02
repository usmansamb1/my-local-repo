import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';
import '../../utils/constants.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _plateController = TextEditingController();
  final _makerController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _colorController = TextEditingController();
  
  bool _isLoading = false;
  String? _selectedMaker;
  String? _selectedModel;
  String? _selectedYear;
  String? _selectedColor;

  final List<String> _carMakers = [
    'BMW',
    'Toyota',
    'Mercedes',
    'Audi',
    'Honda',
    'Nissan',
    'Hyundai',
    'Kia',
    'Ford',
    'Chevrolet',
  ];

  final List<String> _carModels = [
    'Camry',
    'Corolla',
    'Accord',
    'Civic',
    'Altima',
    'Sonata',
    'Elantra',
    'F-150',
    'Silverado',
    'X5',
  ];

  final List<String> _years = List.generate(
    30,
    (index) => (DateTime.now().year - index).toString(),
  );

  final List<String> _colors = [
    'White',
    'Black',
    'Silver',
    'Gray',
    'Blue',
    'Red',
    'Green',
    'Brown',
    'Gold',
    'Beige',
  ];

  @override
  void dispose() {
    _plateController.dispose();
    _makerController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Add Vehicle'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 24),
              _buildVehicleIcon(),
              const SizedBox(height: 32),
              _buildAddVehicleDataSection(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.directions_car,
        size: 50,
        color: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildAddVehicleDataSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Vehicle Data',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          _buildPlateNumberField(),
          const SizedBox(height: 16),
          _buildVehicleMakerField(),
          const SizedBox(height: 16),
          _buildVehicleModelField(),
          const SizedBox(height: 16),
          _buildManufacturingYearField(),
          const SizedBox(height: 16),
          _buildVehicleColorField(),
        ],
      ),
    );
  }

  Widget _buildPlateNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Plate number',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: AppTheme.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _plateController,
                decoration: InputDecoration(
                  hintText: 'e.g. ABC 1234',
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'ك س ع',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            '🇸🇦',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter plate number';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVehicleMakerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vehicle Maker',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedMaker,
          decoration: const InputDecoration(
            hintText: 'ex: BMW',
          ),
          items: _carMakers.map((maker) {
            return DropdownMenuItem(
              value: maker,
              child: Text(maker),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedMaker = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select vehicle maker';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildVehicleModelField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vehicle model',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedModel,
          decoration: const InputDecoration(
            hintText: 'ex: E 350',
          ),
          items: _carModels.map((model) {
            return DropdownMenuItem(
              value: model,
              child: Text(model),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedModel = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select vehicle model';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildManufacturingYearField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Manufacturing Year',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedYear,
          decoration: const InputDecoration(
            hintText: 'ex: 2023',
          ),
          items: _years.map((year) {
            return DropdownMenuItem(
              value: year,
              child: Text(year),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedYear = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select manufacturing year';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildVehicleColorField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vehicle Color',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedColor,
          decoration: const InputDecoration(
            hintText: 'ex: Black',
          ),
          items: _colors.map((color) {
            return DropdownMenuItem(
              value: color,
              child: Text(color),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedColor = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select vehicle color';
            }
            return null;
          },
        ),
      ],
    );  
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: PrimaryButton(
        text: 'Add Vehicle',
        onPressed: _isLoading ? null : _handleAddVehicle,
        isLoading: _isLoading,
      ),
    );
  }

  Future<void> _handleAddVehicle() async {
    if (_formKey.currentState!.validate()) {
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
                  'Vehicle Added Successfully!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '${_selectedMaker} ${_selectedModel} has been added to your vehicles',
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
                      Navigator.of(context).pop(); // Go back to vehicles screen
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
}