import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/core/session.dart';
import 'package:tugas_akhir/core/theme.dart';
import 'package:tugas_akhir/data/models/game_detail_model.dart';
import 'package:tugas_akhir/modelviews/game_detail_view_models.dart';

class GameDetail extends StatelessWidget {
  final int gameId;
  const GameDetail({super.key, required this.gameId});

  @override
  Widget build(BuildContext context) {
    void checkSession() async {
      final hasSession = await Provider.of<SessionCheck>(
        context,
        listen: false,
      ).sessionCheck();

      if (hasSession) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<GameDetailViewModels>().loadDetailGame(gameId);
        });
      }
    }

    checkSession();
    return _GameContent();
  }
}

class _GameContent extends StatelessWidget {
  const _GameContent();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GameDetailViewModels>();

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.homeTeam == null || vm.awayTeam == null) {
      return const Center(child: Text("No data"));
    }

    final home = vm.homeTeam!;
    final away = vm.awayTeam!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("${home.team.name} vs ${away.team.name}"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _teamHeader(home, away),
            const SizedBox(height: 20),
            _statsCard(home, away),
          ],
        ),
      ),
    );
  }

  Widget _teamHeader(GameDetailModel home, GameDetailModel away) {
    final int homeSeconds = _parseSeconds(home.statistics.possession);
    final int awaySeconds = _parseSeconds(away.statistics.possession);
    
    final int totalMatchSeconds = homeSeconds + awaySeconds;

    int homePoss = 0;
    int awayPoss = 0;

    if (totalMatchSeconds > 0) {
      homePoss = ((homeSeconds / totalMatchSeconds) * 100).round();
      awayPoss = 100 - homePoss; 
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteOpacity10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _teamColumn(home),
              Text(
                "${away.statistics.pointsAgainst} - ${home.statistics.pointsAgainst}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _teamColumn(away),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                flex: homePoss, 
                child: Container(
                  height: 8, 
                  decoration: const BoxDecoration(
                    color: AppColors.purple600,
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(4)),
                  ),
                ),
              ),
              Expanded(
                flex: awayPoss,
                child: Container(
                  height: 8, 
                  decoration: const BoxDecoration(
                    color: AppColors.pink600,
                    borderRadius: BorderRadius.horizontal(right: Radius.circular(4)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$homePoss%", style: const TextStyle(color: Colors.white)),
              Text("Possession", style: const TextStyle(color: Colors.grey, fontSize: 10)),
              Text("$awayPoss%", style: const TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  int _parseSeconds(String time) {
    try {
      final parts = time.split(":");
      final minutes = int.parse(parts[0]);
      final seconds = int.parse(parts[1]);
      return (minutes * 60) + seconds;
    } catch (e) {
      return 0; 
    }
  }

  Widget _teamColumn(GameDetailModel team) {
    return Column(
      children: [
        CircleAvatar(radius: 26, backgroundImage: NetworkImage(team.team.logo)),
        const SizedBox(height: 6),
        SizedBox(
          width: 90,
          child: Text(
            team.team.name,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _statsCard(GameDetailModel home, GameDetailModel away) {
    statsRow(String title, dynamic h, dynamic a) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$h", style: const TextStyle(color: Colors.white)),
          Text(title, style: const TextStyle(color: AppColors.grey400)),
          Text("$a", style: const TextStyle(color: Colors.white)),
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteOpacity10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          statsRow(
            "First Downs",
            home.statistics.firstDowns.total,
            away.statistics.firstDowns.total,
          ),
          statsRow("Total Yards", home.statistics.yards, away.statistics.yards),
          statsRow(
            "Passing",
            home.statistics.passing.total,
            away.statistics.passing.total,
          ),
          statsRow(
            "Rushing",
            home.statistics.rushing.total,
            away.statistics.rushing.total,
          ),
          statsRow(
            "Penalties",
            home.statistics.penalties,
            away.statistics.penalties,
          ),
          statsRow("Sacks", home.statistics.sacks, away.statistics.sacks),
          statsRow(
            "Turnovers",
            home.statistics.turnovers,
            away.statistics.turnovers,
          ),
          statsRow(
            "Red Zone",
            home.statistics.redZone,
            away.statistics.redZone,
          ),
        ],
      ),
    );
  }
}
