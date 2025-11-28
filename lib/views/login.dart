import 'package:tugas_akhir/core/theme.dart';
import 'package:tugas_akhir/views/home.dart';
import 'package:tugas_akhir/modelviews/login_view_models.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:tugas_akhir/views/register.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  void _showFeedback(BuildContext context, String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(color: AppColors.white),
        ),
        backgroundColor: isSuccess ? AppColors.green300 : AppColors.red300,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<LoginViewModels>();
      vm.resetState();
      vm.checkBiometrics();
    });

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            body: Consumer<LoginViewModels>(
              builder: (context, viewModel, _) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: MediaQuery.of(context).padding.top + 50),

                      ShaderMask(
                        shaderCallback: (bounds) =>
                            AppColors.titleShaderGradient.createShader(bounds),
                        child: Text(
                          'NFL VIEWER LOGIN',
                          style: Theme.of(context).textTheme.displayLarge!
                              .copyWith(color: AppColors.white),
                        ),
                      ),

                      const SizedBox(height: 12),
                      Text(
                        'Masukkan kredensial Anda untuk melanjutkan.',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.grey400,
                        ),
                      ),

                      const SizedBox(height: 48),

                      TextField(
                        onChanged: viewModel.setEmail,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: AppColors.white),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: AppColors.grey400,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextField(
                        onChanged: viewModel.setPass,
                        obscureText: true,
                        style: const TextStyle(color: AppColors.white),
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: AppColors.grey400,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      if (viewModel.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            viewModel.errorMessage!,
                            style: TextStyle(color: AppColors.red300),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      _GradientButton(
                        text: "MASUK KE APLIKASI",
                        isLoading: viewModel.isLoading,
                        onPressed: () async {
                          final success = await viewModel.login();

                          if (success) {
                            _showFeedback(context, "Login berhasil!", true);
                            Future.delayed(
                              const Duration(milliseconds: 600),
                              () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const HomePage(),
                                ),
                              ),
                            );
                          } else {
                            _showFeedback(
                              context,
                              viewModel.errorMessage ?? "Login gagal",
                              false,
                            );
                          }
                        },
                      ),

                      if (viewModel.canBioLogin) ...[
                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: AppColors.grey400.withOpacity(0.3),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                "ATAU",
                                style: TextStyle(
                                  color: AppColors.grey400,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: AppColors.grey400.withOpacity(0.3),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        _BiometricButton(
                          onTap: () async {
                            final success = await viewModel.loginWFingerprint();

                            if (success && context.mounted) {
                              _showFeedback(context, "Welcome back!", true);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const HomePage(),
                                ),
                              );
                            } else if (viewModel.errorMessage != null &&
                                context.mounted) {
                              _showFeedback(
                                context,
                                viewModel.errorMessage!,
                                false,
                              );
                            }
                          },
                        ),
                      ],

                      const SizedBox(height: 32),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Belum punya akun? ',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(color: AppColors.grey400),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Register(),
                                ),
                              );
                            },
                            child: Text(
                              'Daftar',
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _BiometricButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BiometricButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.purple600.withOpacity(0.5),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16),
              color: AppColors.whiteOpacity10,
            ),
            child: const Icon(
              Icons.fingerprint,
              size: 36,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Masuk dengan Sidik Jari",
            style: TextStyle(color: AppColors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;

  const _GradientButton({
    required this.text,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: AppColors.purplePinkGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowOpacity30,
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  text,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}
