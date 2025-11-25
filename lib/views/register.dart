import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/core/theme.dart';
import 'package:tugas_akhir/modelviews/register_view_models.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  void _showFeedback(BuildContext context, String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: AppColors.white),
        ),
        backgroundColor: isSuccess ? AppColors.green300 : AppColors.red300,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.mainBackgroundGradient,
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Consumer<RegisterViewModel>(
                  builder: (context, viewModel, _) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) =>
                                AppColors.titleShaderGradient.createShader(bounds),
                            child: Text(
                              'BUAT AKUN BARU',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          
                          const SizedBox(height: 12),
                          Text(
                            'Lengkapi data diri Anda untuk akses penuh.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: AppColors.grey400),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 40),

                          _RegisterTextField(
                            label: 'Nama Lengkap',
                            icon: Icons.person_outline,
                            onChanged: viewModel.setName,
                          ),
                          
                          const SizedBox(height: 16),

                          _RegisterTextField(
                            label: 'Email',
                            icon: Icons.email_outlined,
                            inputType: TextInputType.emailAddress,
                            onChanged: viewModel.setEmail,
                          ),

                          const SizedBox(height: 16),

                          _RegisterTextField(
                            label: 'Password',
                            icon: Icons.lock_outline,
                            isPassword: true,
                            onChanged: viewModel.setPass,
                          ),

                          const SizedBox(height: 16),

                          _RegisterTextField(
                            label: 'Konfirmasi Password',
                            icon: Icons.lock_reset,
                            isPassword: true,
                            onChanged: viewModel.setConfirmPass,
                          ),

                          const SizedBox(height: 32),

                          if (viewModel.errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(
                                viewModel.errorMessage!,
                                style: const TextStyle(color: AppColors.red300),
                                textAlign: TextAlign.center,
                              ),
                            ),

                          _GradientButton(
                            text: "DAFTAR SEKARANG",
                            isLoading: viewModel.isLoading,
                            onPressed: () async {
                              final success = await viewModel.register();
                              if (success && context.mounted) {
                                _showFeedback(context, "Akun berhasil dibuat! Silakan login.", true);
                                Future.delayed(const Duration(milliseconds: 800), () {
                                  Navigator.pop(context);
                                });
                              } 
                            },
                          ),

                          const SizedBox(height: 24),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sudah punya akun? ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: AppColors.grey400),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Text(
                                  'Masuk',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPassword;
  final TextInputType inputType;
  final Function(String) onChanged;

  const _RegisterTextField({
    required this.label,
    required this.icon,
    required this.onChanged,
    this.isPassword = false,
    this.inputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      obscureText: isPassword,
      keyboardType: inputType,
      style: const TextStyle(color: AppColors.white),
      cursorColor: AppColors.pink300, // Aksen kursor pink
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.grey400),
        prefixIcon: Icon(icon, color: AppColors.grey400),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.grey400.withOpacity(0.5)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.pink300),
        ),
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
            )
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      color: AppColors.white, strokeWidth: 2),
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