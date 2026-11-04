import 'package:flutter/material.dart';
import '../core/l10n.dart';
import '../core/app_image.dart';
import '../data/models.dart';
import '../widgets/language_widgets.dart';
import 'package:provider/provider.dart';

import '../core/animations.dart';
import '../core/theme.dart';
import '../core/utils.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';
import 'main_shell.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _password = TextEditingController();

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    // TODO: replace with a real authentication call.
    context.read<AppState>().login(_phone.text.trim());
    context.pushReplacementAll(const MainShell());
  }

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Align(alignment: AlignmentDirectional.centerEnd, child: LangToggle()),
                const SizedBox(height: 8),
                const Reveal(index: 0, child: Center(child: AppLogo(size: 64))),
                const SizedBox(height: 22),
                const Reveal(
                  index: 1,
                  child: Center(child: Tr('Welcome Back', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700))),
                ),
                const SizedBox(height: 8),
                Reveal(
                  index: 1,
                  child: Tr('Log in to your account using email\nor social networks',
                      textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: pal.subtext, height: 1.5)),
                ),
                const SizedBox(height: 24),
                Reveal(index: 2, child: _SocialButton(icon: const Icon(Icons.apple, size: 22), label: 'Login with Apple', onTap: () => context.snack('Apple login is a demo'))),
                const SizedBox(height: 12),
                Reveal(
                  index: 3,
                  child: _SocialButton(
                    icon: const Text('G', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF4285F4))),
                    label: 'Login with Google',
                    onTap: () => context.snack('Google login is a demo'),
                  ),
                ),
                const SizedBox(height: 18),
                Reveal(
                  index: 4,
                  child: Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Tr('Or continue with social account', style: TextStyle(fontSize: 11, color: pal.subtext)),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Reveal(index: 5, child: AppTextField(controller: _phone, label: 'Phone Number', keyboardType: TextInputType.phone, validator: Validators.phone)),
                const SizedBox(height: 14),
                Reveal(index: 6, child: AppTextField(controller: _password, label: 'Password', isPassword: true, validator: Validators.password)),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: () => context.snack('Password reset link sent (demo)'),
                    child: const Tr('Forgot Password ?', style: TextStyle(color: AppColors.primary, fontSize: 12)),
                  ),
                ),
                const SizedBox(height: 10),
                Reveal(index: 7, child: PrimaryButton(label: 'Login', onPressed: _submit)),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Tr("Didn't have an account? ", style: TextStyle(fontSize: 12)),
                    GestureDetector(
                      onTap: () => context.push(const SignUpScreen()),
                      child: const Tr('Register', style: TextStyle(color: AppColors.primary, fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.icon, required this.label, required this.onTap});
  final Widget icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: context.pal.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: context.pal.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [icon, const SizedBox(width: 10), Tr(label, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500))],
        ),
      ),
    );
  }
}
