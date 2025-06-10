import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pothole_mobile_app/features/auth/application/auth_controller.dart';
import 'package:pothole_mobile_app/shared/widgets/button_widget.dart';
import 'package:pothole_mobile_app/shared/widgets/custom_textformFile.dart';

class FormRegister extends ConsumerStatefulWidget {
  const FormRegister({super.key});

  @override
  ConsumerState<FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends ConsumerState<FormRegister> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String phone = '';
  String password = '';
  bool isLoading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => isLoading = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await ref
          .read(authControllerProvider)
          .registerWithEmail(
            name: name,
            email: email,
            phone: phone,
            password: password,
          );

          await ref.read(authControllerProvider).logout();

      if (mounted) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berhasil mendaftar! Silahkan login.'),
            backgroundColor: Colors.green,
          ),
        );

        context.go('/login');
      }
    } catch (error) {
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mendaftar: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextFormField(
              label: 'Nama Lengkap',
              icon: Icons.person,
              onSaved: (val) => name = val!.trim(),
              validator:
                  (val) =>
                      val != null && val.length >= 3 ? null : 'Minimal 3 huruf',
            ),
            CustomTextFormField(
              label: 'Email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              onSaved: (val) => email = val!.trim(),
              validator:
                  (val) =>
                      val != null && val.contains('@')
                          ? null
                          : 'Email tidak valid',
            ),
            CustomTextFormField(
              label: 'Nomor Telepon',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              onSaved: (val) => phone = val!.trim(),
              validator:
                  (val) =>
                      val != null && val.length >= 10
                          ? null
                          : 'Nomor tidak valid',
            ),
            CustomTextFormField(
              label: 'Password',
              icon: Icons.lock,
              isPassword: true,
              onSaved: (val) => password = val!,
              validator:
                  (val) =>
                      val != null && val.length >= 6
                          ? null
                          : 'Minimal 6 karakter',
            ),
            const SizedBox(height: 20),
            CustomButtonWidget(
              text: 'Daftar',
              isLoading: isLoading,
              onPressed: _register,
            ),
          ],
        ),
      ),
    );
  }
}
