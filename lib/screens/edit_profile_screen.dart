import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/animations.dart';
import '../core/theme.dart';
import '../core/utils.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';
import 'profile_screen.dart';

const _avatars = ['🙂', '😎', '🧑‍🍳', '👩‍🦰', '🧔', '🦊', '🐼', '🐯', '🐸', '🦄', '🍓', '🥑'];

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _user = context.read<AppState>().user;
  late final _name = TextEditingController(text: _user.name);
  late final _email = TextEditingController(text: _user.email);
  late final _phone = TextEditingController(text: _user.phone);
  late final _address = TextEditingController(text: _user.address);
  late String _avatar = _user.avatar;

  Future<void> _pickAvatar() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Choose your avatar', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  for (final a in _avatars)
                    GestureDetector(
                      onTap: () => Navigator.pop(context, a),
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(color: context.pal.tile, shape: BoxShape.circle),
                        child: Center(child: Text(a, style: const TextStyle(fontSize: 28))),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (picked != null) setState(() => _avatar = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final state = context.read<AppState>();
    state.updateProfile(state.user.copyWith(
      name: _name.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim(),
      address: _address.text.trim(),
      avatar: _avatar,
    ));
    context.snack('Profile updated');
    Navigator.pop(context);
  }

  @override
  void dispose() {
    for (final c in [_name, _email, _phone, _address]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      GestureDetector(onTap: _pickAvatar, child: AvatarBadge(emoji: _avatar, size: 76)),
                      const SizedBox(height: 22),
                      Reveal(index: 0, child: AppTextField(controller: _name, label: 'Name', greenBorder: true, validator: Validators.required)),
                      const SizedBox(height: 12),
                      Reveal(index: 1, child: AppTextField(controller: _email, label: 'Email Address', greenBorder: true, keyboardType: TextInputType.emailAddress, validator: (v) => (v == null || v.trim().isEmpty) ? null : Validators.email(v))),
                      const SizedBox(height: 12),
                      Reveal(index: 2, child: AppTextField(controller: _phone, label: 'Mobile Number', greenBorder: true, keyboardType: TextInputType.phone, validator: Validators.phone)),
                      const SizedBox(height: 12),
                      Reveal(index: 3, child: AppTextField(controller: _address, label: 'Enter Address', greenBorder: true, validator: Validators.required)),
                    ],
                  ),
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.fromLTRB(20, 8, 20, 12), child: PrimaryButton(label: 'Update', onPressed: _save)),
          ],
        ),
      ),
    );
  }
}
