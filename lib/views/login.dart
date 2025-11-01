import 'package:tugas_akhir/views/home.dart';
import '../modelviews/login_view_models.dart';
import '../core/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


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
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Scaffold(
          backgroundColor:
              Colors.transparent, // Agar background gradient terlihat
          body: Consumer<LoginViewModels>(
            builder: (context, viewModel, child) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(32.0), // Large gap: 32px
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top + 50),

                    // --- Header: Main Title (H1) ---
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          AppColors.titleShaderGradient.createShader(bounds),
                      child: Text(
                        'FOOTBALL HUB LOGIN',
                        style: Theme.of(context).textTheme.displayLarge!
                            .copyWith(
                              color: AppColors.white, // Warna fallback
                            ),
                      ),
                    ),
                    const SizedBox(height: 12), // Small gap
                    Text(
                      'Masukkan kredensial Anda untuk melanjutkan.',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.grey400,
                      ),
                    ),

                    const SizedBox(height: 48), // Gap yang cukup besar
                    // --- Input Email ---
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

                    const SizedBox(height: 16), // Regular gap
                    // --- Input Password ---
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

                    const SizedBox(height: 32), // Large gap
                    // --- Error Message ---
                    if (viewModel.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          viewModel.errorMessage!,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(color: AppColors.red300),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    // --- Login Button menggunakan component terpisah ---
                    // GradientButton(
                    //   // <-- PENGGUNAAN WIDGET YANG SUDAH DIPISAHKAN
                    //   text: 'MASUK KE APLIKASI',
                    //   isLoading: viewModel.isLoading,
                    //   onPressed: () async {
                    //     // Panggil ViewModel untuk logic login hardcoded
                    //     bool success = await viewModel.login();
                    //     if (success) {
                    //       Navigator.of(context).pushReplacement(
                    //         MaterialPageRoute(
                    //           builder: (context) => const Home(),
                    //         ),
                    //       );
                    //     } else if (viewModel.errorMessage != null) {
                    //       _showFeedback(
                    //         context,
                    //         viewModel.errorMessage!,
                    //         false,
                    //       );
                    //     }
                    //   },
                    // ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
