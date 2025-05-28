import 'package:flutter/material.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../utils/colors.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _zoneController = TextEditingController();
  final _daysController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _zoneController.dispose();
    _daysController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName es requerido';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo es requerido';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'El teléfono es requerido';
    }
    if (value.length < 10) {
      return 'Ingresa un número válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirma tu contraseña';
    }
    if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Crear usuario en Firebase Auth
        final result = await _authService.registerWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text,
        );

        if (result != null && result.user != null) {
          // Crear modelo de usuario
          final userModel = UserModel(
            uid: result.user!.uid,
            firstName: _nameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            zone: _zoneController.text.trim(),
            availableDays: _daysController.text.trim(),
            createdAt: DateTime.now(),
          );

          // Guardar datos adicionales en Firestore
          await _authService.saveUserData(userModel);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('¡Cuenta creada exitosamente!'),
                backgroundColor: AppColors.success,
              ),
            );

            // Volver a la pantalla de login
            Navigator.pop(context);
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: AppColors.error,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomHeader(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios),
                      color: AppColors.secondary,
                    ),
                    const Text(
                      'Crear Cuenta',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Únete a la comunidad de huertos urbanos',
                  style: TextStyle(fontSize: 16, color: AppColors.textLight),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Nombres',
                        hint: 'Ingresa tus nombres',
                        controller: _nameController,
                        validator:
                            (value) => _validateRequired(value, 'Nombres'),
                        prefixIcon: Icons.person_outline,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        label: 'Apellidos',
                        hint: 'Ingresa tus apellidos',
                        controller: _lastNameController,
                        validator:
                            (value) => _validateRequired(value, 'Apellidos'),
                        prefixIcon: Icons.person_outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Correo Electrónico',
                  hint: 'Ingresa tu correo electrónico',
                  controller: _emailController,
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Teléfono',
                  hint: 'Ingresa tu número de teléfono',
                  controller: _phoneController,
                  validator: _validatePhone,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Zona de Residencia',
                  hint: 'Ingresa tu zona de residencia',
                  controller: _zoneController,
                  validator:
                      (value) => _validateRequired(value, 'Zona de residencia'),
                  prefixIcon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Días Disponibles',
                  hint: 'Ej: Lunes, Miércoles, Viernes',
                  controller: _daysController,
                  validator:
                      (value) => _validateRequired(value, 'Días disponibles'),
                  prefixIcon: Icons.calendar_today_outlined,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Contraseña',
                  hint: 'Crea una contraseña segura',
                  controller: _passwordController,
                  validator: _validatePassword,
                  isPassword: true,
                  prefixIcon: Icons.lock_outline,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Confirmar Contraseña',
                  hint: 'Confirma tu contraseña',
                  controller: _confirmPasswordController,
                  validator: _validateConfirmPassword,
                  isPassword: true,
                  prefixIcon: Icons.lock_outline,
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Crear Cuenta',
                  onPressed: _register,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: RichText(
                      text: const TextSpan(
                        text: '¿Ya tienes una cuenta? ',
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: 'Inicia sesión',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
