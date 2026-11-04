import 'package:flutter/material.dart';
import '../core/l10n.dart';
import '../core/app_image.dart';
import '../widgets/language_widgets.dart';
import 'package:provider/provider.dart';

import '../core/animations.dart';
import '../core/theme.dart';
import '../core/utils.dart';
import '../data/models.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';
import 'main_shell.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    // TODO: replace with a real registration call.
    context.read<AppState>().signUp(UserProfile(
          name: _name.text.trim(),
          email: _email.text.trim(),
          phone: _phone.text.trim(),
        ));
    context.pushReplacementAll(const MainShell());
  }

  @override
  void dispose() {
    for (final c in [_name, _email, _phone, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    return Scaffold(
      appBar: AppBar(actions: const [LangToggle(), SizedBox(width: 12)]),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Reveal(index: 0, child: Center(child: AppLogo(size: 64))),
                const SizedBox(height: 22),
                const Reveal(index: 1, child: Center(child: Tr('Create New Account', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)))),
                const SizedBox(height: 8),
                Reveal(
                  index: 1,
                  child: Tr('Set up your username and password.\nYou can always change it later.',
                      textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: pal.subtext, height: 1.5)),
                ),
                const SizedBox(height: 24),
                Reveal(index: 2, child: AppTextField(controller: _name, label: 'Name', greenBorder: true, validator: Validators.required)),
                const SizedBox(height: 12),
                Reveal(index: 3, child: AppTextField(controller: _email, label: 'Email', greenBorder: true, keyboardType: TextInputType.emailAddress, validator: Validators.email)),
                const SizedBox(height: 12),
                Reveal(index: 4, child: AppTextField(controller: _phone, label: 'Phone Number', greenBorder: true, keyboardType: TextInputType.phone, validator: Validators.phone)),
                const SizedBox(height: 12),
                Reveal(index: 5, child: AppTextField(controller: _password, label: 'Password', greenBorder: true, isPassword: true, validator: Validators.password)),
                const SizedBox(height: 12),
                Reveal(
                  index: 6,
                  child: AppTextField(
                    controller: _confirm,
                    label: 'Confirm Password',
                    greenBorder: true,
                    isPassword: true,
                    validator: (v) => v == _password.text ? null : 'Passwords do not match',
                  ),
                ),
                const SizedBox(height: 22),
                Reveal(index: 7, child: PrimaryButton(label: 'Signup', onPressed: _submit)),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Tr('Already have an account? ', style: TextStyle(fontSize: 12)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Tr('Log in', style: TextStyle(color: AppColors.primary, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
