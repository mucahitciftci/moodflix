import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/localization/l10n/generated/app_localizations.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../widgets/chameleon_mascot.dart';

/// Email/password sign up. Pops itself once [authStateProvider] reports a
/// signed-in user — `LoginScreen` underneath does the same, so the two
/// pops cascade back to whatever screen originally prompted login.
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authViewModelProvider);

    ref.listen(authStateProvider, (previous, next) {
      if (next.valueOrNull != null && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.signUpScreenTitle)),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.6, 1.0],
            colors: [
              AppColors.primaryDark.withValues(alpha: 0.55),
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimens.spaceM),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppDimens.authFormMaxWidth),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ChameleonMascot(
                    size: AppDimens.iconXl * 2,
                    effect: MascotEffect.colorShift,
                  ),
                  const SizedBox(height: AppDimens.spaceM),
                  Text(
                    l10n.appTitle,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: AppDimens.spaceXs),
                  Text(
                    l10n.authTagline,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimens.spaceL),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: l10n.displayNameLabel),
                  ),
                  const SizedBox(height: AppDimens.spaceM),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: l10n.emailLabel),
                  ),
                  const SizedBox(height: AppDimens.spaceM),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: l10n.passwordLabel,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceM),
                  if (authState.hasError)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppDimens.spaceM),
                      child: Text(
                        l10n.authErrorGeneric,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: authState.isLoading
                          ? null
                          : () => ref.read(authViewModelProvider.notifier).signUp(
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                                displayName: _nameController.text.trim(),
                              ),
                      child: authState.isLoading
                          ? const SizedBox(
                              width: AppDimens.iconM,
                              height: AppDimens.iconM,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.signUpScreenTitle),
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceM),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.goToLoginLabel),
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
