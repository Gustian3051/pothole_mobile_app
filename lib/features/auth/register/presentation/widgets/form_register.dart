import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pothole_mobile_app/features/auth/application/auth_controller.dart';

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
    try {
      await ref
          .read(authControllerProvider)
          .registerWithEmail(
            name: name,
            email: email,
            phone: phone,
            password: password,
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil mendaftar! Silakan login.')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mendaftar: ${error.toString()}')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                onSaved: (val) => name = val!.trim(),
                validator:
                    (val) =>
                        val != null && val.length >= 3
                            ? null
                            : 'Minimal 3 huruf',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (val) => email = val!.trim(),
                validator:
                    (val) =>
                        val != null && val.contains('@')
                            ? null
                            : 'Email tidak valid',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nomor Telepon'),
                keyboardType: TextInputType.phone,
                onSaved: (val) => phone = val!.trim(),
                validator:
                    (val) =>
                        val != null && val.length >= 10
                            ? null
                            : 'Nomor tidak valid',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (val) => password = val!,
                validator:
                    (val) =>
                        val != null && val.length >= 6
                            ? null
                            : 'Minimal 6 karakter',
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: _register,
                    child: const Text('Daftar'),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
