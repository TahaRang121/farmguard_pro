import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/biometric_login_widget.dart';
import './widgets/email_input_widget.dart';
import './widgets/language_selector_widget.dart';
import './widgets/phone_input_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isEmailLogin = false;
  String _selectedLanguage = 'en';
  String? _phoneError;
  String? _emailError;
  bool _isBiometricAvailable = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Mock credentials for testing
  final Map<String, String> _mockCredentials = {
    'phone': '9876543210',
    'email': 'farmer@farmguard.com',
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkBiometricAvailability();
    _loadSavedPhoneNumber();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    _fadeController.forward();
  }

  void _checkBiometricAvailability() {
    // Simulate biometric availability check
    setState(() {
      _isBiometricAvailable = true;
    });
  }

  void _loadSavedPhoneNumber() {
    // Simulate loading saved phone number
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _phoneController.text = '';
        });
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  bool _isValidPhoneNumber(String phone) {
    return phone.length == 10 && RegExp(r'^[6-9]\d{9}$').hasMatch(phone);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _validateInputs() {
    setState(() {
      if (_isEmailLogin) {
        _emailError = null;
        if (_emailController.text.isEmpty) {
          _emailError = 'Email address is required';
        } else if (!_isValidEmail(_emailController.text)) {
          _emailError = 'Please enter a valid email address';
        }
      } else {
        _phoneError = null;
        if (_phoneController.text.isEmpty) {
          _phoneError = 'Mobile number is required';
        } else if (!_isValidPhoneNumber(_phoneController.text)) {
          _phoneError = 'Please enter a valid 10-digit mobile number';
        }
      }
    });
  }

  Future<void> _sendOTP() async {
    _validateInputs();

    if ((_isEmailLogin && _emailError != null) ||
        (!_isEmailLogin && _phoneError != null)) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate OTP sending
      await Future.delayed(const Duration(seconds: 2));

      // Check mock credentials
      final input =
          _isEmailLogin ? _emailController.text : _phoneController.text;
      final expectedInput =
          _isEmailLogin ? _mockCredentials['email'] : _mockCredentials['phone'];

      if (input == expectedInput) {
        // Simulate successful OTP send
        HapticFeedback.lightImpact();
        Fluttertoast.showToast(
          msg: _isEmailLogin
              ? 'OTP sent to your email address'
              : 'OTP sent to +91 ${_phoneController.text}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          textColor: AppTheme.lightTheme.colorScheme.onPrimary,
        );

        // Navigate to dashboard (simulating successful login)
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/farm-dashboard');
        }
      } else {
        // Show error for wrong credentials
        setState(() {
          if (_isEmailLogin) {
            _emailError =
                'Invalid email address. Use: ${_mockCredentials['email']}';
          } else {
            _phoneError =
                'Invalid mobile number. Use: ${_mockCredentials['phone']}';
          }
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Network error. Please check your connection and try again.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        textColor: AppTheme.lightTheme.colorScheme.onError,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleBiometricLogin() async {
    HapticFeedback.lightImpact();

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate biometric authentication
      await Future.delayed(const Duration(seconds: 1));

      Fluttertoast.showToast(
        msg: 'Biometric authentication successful',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        textColor: AppTheme.lightTheme.colorScheme.onPrimary,
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/farm-dashboard');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Biometric authentication failed. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        textColor: AppTheme.lightTheme.colorScheme.onError,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _toggleLoginMethod() {
    setState(() {
      _isEmailLogin = !_isEmailLogin;
      _phoneError = null;
      _emailError = null;
    });
  }

  void _onLanguageChanged(String languageCode) {
    setState(() {
      _selectedLanguage = languageCode;
    });

    Fluttertoast.showToast(
      msg: 'Language changed successfully',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Top section with language selector
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            child: CustomIconWidget(
                              iconName: 'arrow_back_ios',
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                              size: 20,
                            ),
                          ),
                        ),
                        LanguageSelectorWidget(
                          selectedLanguage: _selectedLanguage,
                          onLanguageChanged: _onLanguageChanged,
                        ),
                      ],
                    ),

                    SizedBox(height: 4.h),

                    // App logo and branding
                    Container(
                      width: 20.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'agriculture',
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          size: 32,
                        ),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    Text(
                      'FarmGuard Pro',
                      style: AppTheme.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),

                    SizedBox(height: 1.h),

                    Text(
                      'Smart Farming for Better Harvest',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 5.h),

                    // Login form
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Login method toggle
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppTheme.lightTheme.colorScheme.outline,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      if (_isEmailLogin) _toggleLoginMethod();
                                    },
                                    borderRadius: BorderRadius.circular(7),
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 1.5.h),
                                      decoration: BoxDecoration(
                                        color: !_isEmailLogin
                                            ? AppTheme
                                                .lightTheme.colorScheme.primary
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Mobile',
                                          style: AppTheme
                                              .lightTheme.textTheme.bodyMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: !_isEmailLogin
                                                ? AppTheme.lightTheme
                                                    .colorScheme.onPrimary
                                                : AppTheme
                                                    .lightTheme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      if (!_isEmailLogin) _toggleLoginMethod();
                                    },
                                    borderRadius: BorderRadius.circular(7),
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 1.5.h),
                                      decoration: BoxDecoration(
                                        color: _isEmailLogin
                                            ? AppTheme
                                                .lightTheme.colorScheme.primary
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Email',
                                          style: AppTheme
                                              .lightTheme.textTheme.bodyMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: _isEmailLogin
                                                ? AppTheme.lightTheme
                                                    .colorScheme.onPrimary
                                                : AppTheme
                                                    .lightTheme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 3.h),

                          // Input field
                          _isEmailLogin
                              ? EmailInputWidget(
                                  controller: _emailController,
                                  errorText: _emailError,
                                  isEnabled: !_isLoading,
                                  onChanged: (_) {
                                    if (_emailError != null) {
                                      setState(() {
                                        _emailError = null;
                                      });
                                    }
                                  },
                                )
                              : PhoneInputWidget(
                                  controller: _phoneController,
                                  errorText: _phoneError,
                                  isEnabled: !_isLoading,
                                  onChanged: (_) {
                                    if (_phoneError != null) {
                                      setState(() {
                                        _phoneError = null;
                                      });
                                    }
                                  },
                                ),

                          SizedBox(height: 4.h),

                          // Send OTP button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _sendOTP,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppTheme.lightTheme.colorScheme.primary,
                                foregroundColor:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 2,
                              ),
                              child: _isLoading
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          AppTheme
                                              .lightTheme.colorScheme.onPrimary,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      'Send OTP',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyLarge
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme
                                            .lightTheme.colorScheme.onPrimary,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Biometric login
                    BiometricLoginWidget(
                      onBiometricLogin: _handleBiometricLogin,
                      isAvailable: _isBiometricAvailable,
                    ),

                    const Spacer(),

                    // Register link
                    Padding(
                      padding: EdgeInsets.only(bottom: 3.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'New farmer? ',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Navigate to registration screen
                              Fluttertoast.showToast(
                                msg: 'Registration feature coming soon',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                            },
                            child: Text(
                              'Register here',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    AppTheme.lightTheme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
