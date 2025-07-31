class Validators {
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    final cleanNumber = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (!RegExp(r'^5\d{8}$').hasMatch(cleanNumber)) {
      return 'Please enter a valid Saudi phone number';
    }
    
    return null;
  }
  
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    return null;
  }
  
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    
    return null;
  }
  
  static String? validateInvitationCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Invitation code is required';
    }
    
    if (value.length < 6) {
      return 'Invalid invitation code';
    }
    
    return null;
  }
  
  static String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}