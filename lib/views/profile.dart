import 'package:flutter/material.dart';
import 'package:tugas_akhir/core/theme.dart';
import 'package:tugas_akhir/views/bottom_nav.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    const String userName = "Rikza Hasanudin";
    const String userNim = "124230054";
    const String userKesan =
        "Belajar Flutter sangat menantang tapi hasilnya memuaskan. Logic state management seru banget!";
    const String userPesan =
        "Jangan pernah menyerah saat ketemu error merah. StackOverflow dan AI adalah teman terbaik.";
    const String profileImageUrl =
        "https://media1.tenor.com/m/2f7m0vNLcGMAAAAd/lebron-lebron-james.gif";

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.mainBackgroundGradient,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildProfilePicture(profileImageUrl),

              const SizedBox(height: 24),

              ShaderMask(
                shaderCallback: (bounds) =>
                    AppColors.titleShaderGradient.createShader(bounds),
                child: const Text(
                  userName,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "NIM: $userNim",
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.grey300,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 40),

              _buildInfoCard(
                title: "Kesan",
                content: userKesan,
                icon: Icons.favorite_outline,
              ),

              const SizedBox(height: 20),

              _buildInfoCard(
                title: "Pesan",
                content: userPesan,
                icon: Icons.chat_bubble_outline,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(currentIndex: 2),
    );
  }

  Widget _buildProfilePicture(String imageUrl) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.purplePinkGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.darkSlate900, width: 4),
        ),
        child: CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage(imageUrl),
          backgroundColor: AppColors.purple900,
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteOpacity10,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.whiteOpacity20, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.purple300, size: 20),
              const SizedBox(width: 10),
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.purple300,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              color: AppColors.grey300,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}