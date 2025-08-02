import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/language_toggle.dart';
import '../../widgets/joil_logo.dart';
import '../../utils/validators.dart';
import '../../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  
  // OTP Flow states
  bool _showOtpInput = false;
  final _otpController = TextEditingController();
  String _generatedOtp = '';
  int _otpCountdown = 60;
  bool _canResendOtp = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_showOtpInput) {
      // Step 1: Send OTP
      if (!_formKey.currentState!.validate()) return;
      
      setState(() {
        _isLoading = true;
      });

      // Simulate sending SMS OTP
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // Generate random 4-digit OTP for demo
      _generatedOtp = (1000 + (9999 - 1000) * DateTime.now().millisecondsSinceEpoch % 1).toInt().toString();
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          _showOtpInput = true;
        });
        
        _startOtpCountdown();
        
        // Show OTP in demo (remove in production)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Demo OTP sent: $_generatedOtp'),
            duration: const Duration(seconds: 5),
            backgroundColor: AppTheme.accentGreen,
          ),
        );
      }
    } else {
      // Step 2: Verify OTP
      if (_otpController.text.length != 4) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid 4-digit OTP'),
            backgroundColor: AppTheme.accentRed,
          ),
        );
        return;
      }
      
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(milliseconds: 800));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // In production, verify OTP with backend
        if (_otpController.text == _generatedOtp || _otpController.text == '1234') {
          Navigator.pushReplacementNamed(context, Constants.mainRoute);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid OTP. Please try again.'),
              backgroundColor: AppTheme.accentRed,
            ),
          );
          _otpController.clear();
        }
      }
    }
  }

  void _startOtpCountdown() {
    _otpCountdown = 60;
    _canResendOtp = false;
    
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_otpCountdown > 0) {
            _otpCountdown--;
          } else {
            _canResendOtp = true;
            timer.cancel();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _resendOtp() async {
    if (!_canResendOtp) return;
    
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Generate new OTP
    _generatedOtp = (1000 + (9999 - 1000) * DateTime.now().millisecondsSinceEpoch % 1).toInt().toString();
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      
      _startOtpCountdown();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New OTP sent: $_generatedOtp'),
          backgroundColor: AppTheme.accentGreen,
        ),
      );
    }
  }

  void _goBackToPhone() {
    setState(() {
      _showOtpInput = false;
      _otpController.clear();
      _canResendOtp = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildMainContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.primaryColor,
            AppTheme.secondaryColor,
          ],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 60),
          // JOIL Corporate Logo
          const JoilLogo(size: 80, showText: true),
          const SizedBox(height: 24),
          Text(
            _showOtpInput ? 'Verify Your Phone' : 'Welcome Back',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w300,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _showOtpInput 
              ? 'Enter the 4-digit code sent to\n+966 ${_phoneController.text}'
              : 'Sign in to continue to your account',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_showOtpInput) ...[
              _buildPhoneInputSection(),
            ] else ...[
              _buildOtpInputSection(),
            ],
            const SizedBox(height: 32),
            _buildActionButton(),
            const SizedBox(height: 24),
            _buildLanguageSection(),
            if (!_showOtpInput) ...[
              const SizedBox(height: 24),
              _buildSignUpSection(),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phone Number',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.dividerColor, width: 1.5),
            color: Colors.grey[50],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '🇸🇦',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '+966',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: _phoneController,
                  validator: Validators.validatePhone,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(9),
                  ],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                  ),
                  decoration: const InputDecoration(
                    hintText: '5X XXX XXXX',
                    hintStyle: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOtpInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (_showOtpInput)
          TextButton.icon(
            onPressed: _goBackToPhone,
            icon: const Icon(Icons.arrow_back, size: 20),
            label: const Text('Change Phone Number'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            ),
          ),
        const SizedBox(height: 24),
        const Text(
          'Verification Code',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 20),
        Stack(
          children: [
            // Invisible TextField for OTP input
            Opacity(
              opacity: 0,
              child: TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                onChanged: (value) {
                  setState(() {});
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
              ),
            ),
            // Visible OTP digit boxes
            GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                // Trigger keyboard for invisible field
                Future.delayed(const Duration(milliseconds: 100), () {
                  FocusScope.of(context).requestFocus(FocusNode());
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) => _buildOtpDigitBox(index)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (_canResendOtp)
          TextButton(
            onPressed: _resendOtp,
            child: Text(
              'Resend Code',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        else
          Text(
            'Resend code in ${_otpCountdown}s',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
      ],
    );
  }

  Widget _buildOtpDigitBox(int index) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _otpController.text.length > index 
            ? AppTheme.primaryColor 
            : AppTheme.dividerColor,
          width: 2,
        ),
        color: _otpController.text.length > index 
          ? AppTheme.primaryColor.withOpacity(0.1)
          : Colors.grey[50],
      ),
      child: Center(
        child: Text(
          _otpController.text.length > index ? _otpController.text[index] : '',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          shadowColor: AppTheme.primaryColor.withOpacity(0.3),
        ),
        child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              _showOtpInput ? 'Verify & Continue' : 'Send Verification Code',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
      ),
    );
  }

  Widget _buildLanguageSection() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppTheme.dividerColor.withOpacity(0.5)),
        ),
        child: const LanguageToggle(),
      ),
    );
  }

  Widget _buildSignUpSection() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account? ",
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 16,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, Constants.registerRoute);
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Sign Up',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}