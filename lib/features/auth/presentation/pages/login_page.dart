import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_stack_mobile_app/features/auth/presentation/bloc/auth_bloc.dart';

import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<LoginBloc>().add(
      LoginSubmitted(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          context.read<AuthBloc>().authenticated();
        }

        if (state is LoginFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.failure.message)));
        }
      },
      builder: (context, state) {
        final isLoading = state is LoginLoading;
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppDimensions.maxContentWidth,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: AppSpacing.xl),
                        _buildForm(isLoading),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 36,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
            .animate()
            .scale(duration: 500.ms, curve: Curves.easeOutBack)
            .fadeIn(duration: 400.ms),
        const SizedBox(height: AppSpacing.lg),
        Text(
              'Welcome Back',
              style: AppTextStyles.headingLarge.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            )
            .animate()
            .fadeIn(delay: 150.ms, duration: 500.ms)
            .slideY(
              begin: 0.2,
              end: 0,
              delay: 150.ms,
              duration: 500.ms,
              curve: Curves.easeOut,
            ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Sign in to continue shopping',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 250.ms, duration: 500.ms),
      ],
    );
  }

  Widget _buildForm(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              prefixIcon: const Icon(Icons.email_outlined),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }

                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }

                return null;
              },
            )
            .animate()
            .fadeIn(delay: 350.ms, duration: 500.ms)
            .slideX(
              begin: 0.08,
              end: 0,
              delay: 350.ms,
              duration: 500.ms,
              curve: Curves.easeOut,
            ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
              controller: _passwordController,
              label: 'Password',
              hint: 'Enter your password',
              obscureText: _obscurePassword,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
              onSubmitted: (_) => _submit(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }

                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }

                return null;
              },
            )
            .animate()
            .fadeIn(delay: 450.ms, duration: 500.ms)
            .slideX(
              begin: 0.08,
              end: 0,
              delay: 450.ms,
              duration: 500.ms,
              curve: Curves.easeOut,
            ),
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              // Forgot password will be implemented later.
            },
            child: const Text('Forgot password?'),
          ),
        ).animate().fadeIn(delay: 550.ms, duration: 400.ms),
        const SizedBox(height: AppSpacing.md),
        AppButton(
              label: 'Sign In',
              isLoading: isLoading,
              onPressed: isLoading ? null : _submit,
            )
            .animate()
            .fadeIn(delay: 650.ms, duration: 500.ms)
            .slideY(
              begin: 0.15,
              end: 0,
              delay: 650.ms,
              duration: 500.ms,
              curve: Curves.easeOut,
            ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text('OR', style: AppTextStyles.bodyMedium),
            ),
            const Expanded(child: Divider()),
          ],
        ).animate().fadeIn(delay: 750.ms, duration: 400.ms),
        const SizedBox(height: AppSpacing.lg),
        OutlinedButton.icon(
          onPressed: () {
            // Google authentication will be implemented later.
          },
          icon: const Icon(Icons.g_mobiledata),
          label: const Text('Continue with Google'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
          ),
        ).animate().fadeIn(delay: 850.ms, duration: 500.ms),
        const SizedBox(height: AppSpacing.xl),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have an account?", style: AppTextStyles.bodyMedium),
            TextButton(
              onPressed: () {
                // Registration will be implemented later.
              },
              child: const Text('Sign Up'),
            ),
          ],
        ).animate().fadeIn(delay: 950.ms, duration: 500.ms),
      ],
    );
  }
}
