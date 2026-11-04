import 'package:flutter/material.dart';

import '../core/animations.dart';
import '../core/utils.dart';
import '../widgets/common.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _new = TextEditingController();
  final _confirm = TextEditingController();

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    // TODO: call your backend to change the password.
    context.snack('Password updated');
    Navigator.pop(context);
  }

  @override
  void dispose() {
    for (final c in [_current, _new, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Reveal(index: 0, child: AppTextField(controller: _current, label: 'Current Password', isPassword: true, greenBorder: true, validator: Validators.password)),
              const SizedBox(height: 12),
              Reveal(index: 1, child: AppTextField(controller: _new, label: 'New Password', isPassword: true, greenBorder: true, validator: Validators.password)),
              const SizedBox(height: 12),
              Reveal(
                index: 2,
                child: AppTextField(
                  controller: _confirm,
                  label: 'Confirm New Password',
                  isPassword: true,
                  greenBorder: true,
                  validator: (v) => v == _new.text ? null : 'Passwords do not match',
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(label: 'Update Password', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}
