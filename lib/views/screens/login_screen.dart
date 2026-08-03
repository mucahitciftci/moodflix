import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/localization/l10n/generated/app_localizations.dart';
import '../../core/routing/app_router.dart';
import '../../services/auth_service.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../widgets/chameleon_mascot.dart';
import '../widgets/google_sign_in_render_button.dart';

/// Email/password login — also the app's startup screen when no one is
/// signed in (see `AuthGateScreen`), in which case a "continue as guest"
/// option is shown too (browsing/watchlist never required an account; only
/// reviews do). When reached by pushing on top of another screen (e.g. the
/// "write a review" flow), it pops itself automatically once
/// [authStateProvider] reports a signed-in user — including when reached
/// via `SignUpScreen`, whose own success-pop cascades back through this
/// screen too.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _showForgotPasswordDialog() async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: _emailController.text);

    final email = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.forgotPasswordLabel),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(labelText: l10n.emailLabel),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancelLabel),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(controller.text.trim()),
            child: Text(l10n.sendResetLinkLabel),
          ),
        ],
      ),
    );
    controller.dispose();

    if (email == null || email.isEmpty || !mounted) return;
    await ref.read(authViewModelProvider.notifier).sendPasswordResetEmail(email);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.resetLinkSentMessage)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authViewModelProvider);
    final isStartupGate = !Navigator.of(context).canPop();

    ref.listen(authStateProvider, (previous, next) {
      if (next.valueOrNull != null && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.loginScreenTitle)),
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _showForgotPasswordDialog,
                      child: Text(l10n.forgotPasswordLabel),
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
                          : () => ref.read(authViewModelProvider.notifier).signIn(
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                              ),
                      child: authState.isLoading
                          ? const SizedBox(
                              width: AppDimens.iconM,
                              height: AppDimens.iconM,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.loginScreenTitle),
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceL),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.spaceS,
                        ),
                        child: Text(
                          l10n.orContinueWithLabel,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.spaceM),
                  if (kIsWeb)
                    FutureBuilder<void>(
                      future: ref
                          .read(authViewModelProvider.notifier)
                          .ensureGoogleSignInReady(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const SizedBox(
                            height: AppDimens.iconXl,
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }
                        if (!ref.read(authServiceProvider).googleSignInAvailable) {
                          return SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: null,
                              icon: const Icon(Icons.g_mobiledata_rounded, size: AppDimens.iconL),
                              label: Text(l10n.continueWithGoogleLabel),
                            ),
                          );
                        }
                        return Center(child: renderGoogleSignInButton());
                      },
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: authState.isLoading
                            ? null
                            : () => ref
                                .read(authViewModelProvider.notifier)
                                .signInWithGoogle(),
                        icon: const Icon(Icons.g_mobiledata_rounded, size: AppDimens.iconL),
                        label: Text(l10n.continueWithGoogleLabel),
                      ),
                    ),
                  if (!kIsWeb && Platform.isIOS) ...[
                    const SizedBox(height: AppDimens.spaceM),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: authState.isLoading
                            ? null
                            : () => ref
                                .read(authViewModelProvider.notifier)
                                .signInWithApple(),
                        icon: const Icon(Icons.apple, size: AppDimens.iconL),
                        label: Text(l10n.continueWithAppleLabel),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppDimens.spaceM),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushNamed(AppRoutes.signUp),
                    child: Text(l10n.goToSignUpLabel),
                  ),
                  if (isStartupGate)
                    TextButton(
                      onPressed: () =>
                          ref.read(guestModeProvider.notifier).continueAsGuest(),
                      child: Text(l10n.continueAsGuestLabel),
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
