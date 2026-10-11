import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/providers/app_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController(text: 'operator@melongrow.ai');
  final _password = TextEditingController(text: 'password123');
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref.read(authProvider.notifier).login(_email.text, _password.text);
      if (mounted) context.go('/greenhouses');
    } catch (error) {
      setState(() => _error = error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(LucideIcons.sprout, color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 28),
                  Text('MelonGrow AI', style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(height: 8),
                  Text(
                    'Masuk untuk memantau greenhouse aeroponik melon secara real-time.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.secondaryText),
                  ),
                  const SizedBox(height: 28),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(prefixIcon: Icon(LucideIcons.mail), labelText: 'Email'),
                          validator: (value) => value != null && value.contains('@') ? null : 'Email tidak valid',
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _password,
                          obscureText: true,
                          decoration: const InputDecoration(prefixIcon: Icon(LucideIcons.lock), labelText: 'Password'),
                          validator: (value) => value != null && value.length >= 6 ? null : 'Minimal 6 karakter',
                        ),
                      ],
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 14),
                    Text(_error!, style: const TextStyle(color: AppColors.danger)),
                  ],
                  const SizedBox(height: 22),
                  ElevatedButton.icon(
                    onPressed: _loading ? null : _submit,
                    icon: _loading
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(LucideIcons.logIn),
                    label: const Text('Masuk'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
