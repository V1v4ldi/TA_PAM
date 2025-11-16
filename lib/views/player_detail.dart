import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/modelviews/player_detail_view_models.dart';

class PlayerDetail extends StatelessWidget {
  final int playerId;
  const PlayerDetail({required this.playerId ,super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlayerDetailViewModels>().getPlayer(playerId);
    });
    return const _PlayerDetailContent();
  }
}

class _PlayerDetailContent extends StatelessWidget {
  const _PlayerDetailContent();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PlayerDetailViewModels>();

    return Scaffold(
      appBar: AppBar(
        title: Text(vm.player?.name ?? 'Player Detail'),
      ),
      body: Builder(
        builder: (_) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.player == null) {
            return const Center(child: Text("Data tidak ditemukan"));
          }

          final p = vm.player!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Foto Player
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    p.image ?? '',
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 80),
                  ),
                ),
                const SizedBox(height: 16),

                // Nama
                Text(
                  p.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Posisi & Nomor Jersey
                Text(
                  "${p.position ?? '-'} • #${p.number ?? '-'}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                const SizedBox(height: 20),
                Divider(height: 1),

                const SizedBox(height: 16),

                _infoTile("Age", p.age),
                _infoTile("Height", p.height),
                _infoTile("Weight", p.weight),
                _infoTile("College", p.college),
                _infoTile("Group", p.group),
                _infoTile("Experience", p.experience),
                _infoTile("Salary", p.salary),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoTile(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value?.toString() ?? '-',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
