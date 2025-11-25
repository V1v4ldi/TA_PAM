import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tugas_akhir/core/session.dart';
import 'package:tugas_akhir/core/theme.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/modelviews/team_detail_view_model.dart';

class TeamDetail extends StatelessWidget {
  final int teamId;
  const TeamDetail({required this.teamId, super.key});

  @override
  Widget build(BuildContext context) {
    void checkSession() async {
      final hasSession = await Provider.of<SessionCheck>(
        context,
        listen: false,
      ).sessionCheck();

      if (hasSession) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final user = Supabase.instance.client.auth.currentUser;
          final userId = user?.id;

          if (userId != null) {
            await context.read<TeamDetailViewModel>().init(
              teamId: teamId,
              userId: userId,
            );
          }
        });
      }
    }
    checkSession();
    return _TeamDetailContent();
  }
}

class _TeamDetailContent extends StatelessWidget {
  const _TeamDetailContent();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TeamDetailViewModel>();

    return Scaffold(
      backgroundColor: AppColors.darkSlate900,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          vm.team?.name ?? "Team Detail",
          style: const TextStyle(color: AppColors.white),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          IconButton(
            icon: ShaderMask(
              shaderCallback: (bounds) =>
                  AppColors.purplePinkGradient.createShader(bounds),
              child: Icon(
                vm.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: vm.isBookmarked
                    ? Colors.white
                    : AppColors.white, // warna dasar icon
              ),
            ),
            onPressed: () async {
              await vm.toggleBookmark();
            },
          ),
        ],
      ),
      body: Builder(
        builder: (_) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final t = vm.team;
          if (t == null) {
            return const Center(
              child: Text(
                "Data tidak ditemukan",
                style: TextStyle(color: AppColors.grey300),
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Logo
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.whiteOpacity10,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.network(
                    t.logo ?? "",
                    height: 120,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.shield,
                      size: 80,
                      color: AppColors.grey400,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // TEAM NAME
                Text(
                  t.name,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),

                if (t.city != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    t.city!,
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.grey300,
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Info Card
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.whiteOpacity10,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow("Coach", t.coach),
                      _infoRow("Owner", t.owner),
                      _infoRow("Stadium", t.stadium),
                      _infoRow("Founded", t.established?.toString()),
                      _infoRow("Country", t.country?.name),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: AppColors.grey300, fontSize: 16),
          ),
          Text(
            value ?? "-",
            style: const TextStyle(color: AppColors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
