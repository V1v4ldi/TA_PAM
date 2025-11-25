import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/core/session.dart';
import 'package:tugas_akhir/core/theme.dart';
import 'package:tugas_akhir/modelviews/search_view_models.dart';
import 'package:tugas_akhir/views/bottom_nav.dart';
import 'package:tugas_akhir/views/team_detail.dart';
import 'package:tugas_akhir/views/player_detail.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    void checkSession() async {
      final hasSession = await Provider.of<SessionCheck>(
        context,
        listen: false,
      ).sessionCheck();

      if (hasSession) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<SearchViewModels>();
        });
      }
    }

    checkSession();
    return _SearchContent();
  }
}

class _SearchContent extends StatelessWidget {
  const _SearchContent();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchViewModels>();

    return Scaffold(
      backgroundColor: AppColors.darkSlate900,
      appBar: AppBar(
        backgroundColor: AppColors.darkSlate900,
        title: TextField(
          autofocus: true,
          style: const TextStyle(color: AppColors.white),
          decoration: const InputDecoration(
            hintText: 'Cari player atau club...',
            hintStyle: TextStyle(color: AppColors.grey400),
            border: InputBorder.none,
          ),
          onSubmitted: (value) {
            final text = value.trim();

            if (text.length >= 3) {
              vm.search(text); // ← Kirim value
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Minimal 3 karakter untuk mencari"),
                ),
              );
            }
          },
          onChanged: (value) {
            final text = value.trim();
            if (text.length >= 3) {
              vm.search(text);
            }
          },
        ),
        actions: [
          if (vm.query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.grey300),
              onPressed: vm.clear,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Builder(
          builder: (_) {
            if (vm.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.pink600),
              );
            }

            if (vm.query.isEmpty) {
              return const Center(
                child: Text(
                  'Mulai ketik untuk mencari player atau club',
                  style: TextStyle(color: AppColors.grey400, fontSize: 16),
                ),
              );
            }

            final totalResults = vm.players.length + vm.teams.length;

            if (totalResults == 0) {
              return const Center(
                child: Text(
                  'Tidak ada hasil ditemukan 😕',
                  style: TextStyle(color: AppColors.grey300, fontSize: 16),
                ),
              );
            }

            return ListView(
              children: [
                if (vm.players.isNotEmpty)
                  _ResultSection(
                    title: "Players",
                    results: vm.players
                        .map(
                          (p) => _ResultCard(
                            title: p.name,
                            subtitle:
                                "${p.position ?? '-'} • ${p.college ?? '-'}",
                            imageUrl: p.image ?? '',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PlayerDetail(playerId: p.id),
                                ),
                              );
                            },
                          ),
                        )
                        .toList(),
                  ),

                if (vm.teams.isNotEmpty)
                  _ResultSection(
                    title: "Teams",
                    results: vm.teams
                        .map(
                          (t) => _ResultCard(
                            title: t.name,
                            subtitle: t.city ?? 'No city info',
                            imageUrl: t.logo ?? '',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TeamDetail(teamId: t.id),
                                ),
                              );
                            },
                          ),
                        )
                        .toList(),
                  ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNav(currentIndex: 1),
    );
  }
}

class _ResultSection extends StatelessWidget {
  final String title;
  final List<Widget> results;

  const _ResultSection({required this.title, required this.results});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.titleShaderGradient.createShader(bounds),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
        ),
        ...results,
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback onTap;

  const _ResultCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.whiteOpacity10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
        leading: CircleAvatar(
          backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
          backgroundColor: AppColors.whiteOpacity20,
          radius: 24,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: AppColors.grey400),
        ),
        onTap: onTap,
      ),
    );
  }
}
