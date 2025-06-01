import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pothole_mobile_app/features/setting/application/change_password_controller.dart';

class FormChangePassword extends ConsumerStatefulWidget {
  const FormChangePassword({super.key});

  @override
  ConsumerState<FormChangePassword> createState() => _FormChangePasswordState();
}

class _FormChangePasswordState extends ConsumerState<FormChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() != true) return;

    setState(() => _isLoading = true);
    try {
      final controller = ref.read(changePasswordControllerProvder);
      await controller.changePassword(
        currentPassword: _currentPasswordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to change password: $error')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _currentPasswordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Current Password'),
            validator:
                (value) => (value == null || value.isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _newPasswordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'New Password'),
            validator:
                (value) =>
                    (value == null || value.length < 6)
                        ? 'Must be at least 6 characters'
                        : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Confirm New Password',
            ),
            validator:
                (value) =>
                    (value != _newPasswordController.text)
                        ? 'Passwords do not match'
                        : null,
          ),
          const SizedBox(height: 24),
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                onPressed: _submit,
                child: const Text('Change Password'),
              ),
        ],
      ),
    );
  }
}
