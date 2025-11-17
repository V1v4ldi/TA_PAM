import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/core/theme.dart';
import 'package:tugas_akhir/data/models/games_model.dart';
import 'package:tugas_akhir/modelviews/games_view_models.dart';
import 'package:tugas_akhir/views/game_detail.dart';
import 'package:tugas_akhir/views/venue.dart';

class GamesPage extends StatelessWidget {
  const GamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // load first time only
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.watch<GamesViewModels>();
      if (!vm.isLoading) vm.loadGames();
    });

    return const _GamesContent();
  }
}

class _GamesContent extends StatelessWidget {
  const _GamesContent();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GamesViewModels>();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _seasonBtn(context, "Pre Season"),
                _seasonBtn(context, "Regular Season"),
                _seasonBtn(context, "Post Season"),
              ],
            ),
          ),

          if (vm.selectedSeason == "Regular Season")
            SizedBox(
              height: 45,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: vm.weeks.map((w) => _weekBtn(context, w)).toList(),
              ),
            ),

          const SizedBox(height: 12),

          ...vm.filteredGames.map((g) => GameTile(game: g)),
        ],
      ),
    );
  }
}

Widget _seasonBtn(BuildContext context, String s) {
  final vm = context.watch<GamesViewModels>();
  final selected = vm.selectedSeason == s;

  return GestureDetector(
    onTap: () => vm.setSeason(s),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? AppColors.purple600 : AppColors.whiteOpacity10,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        s,
        style: TextStyle(
          color: Colors.white,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ),
  );
}

Widget _weekBtn(BuildContext context, String w) {
  final vm = context.watch<GamesViewModels>();
  final selected = vm.selectedWeek == w;

  return GestureDetector(
    onTap: () => vm.setWeek(w),
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? AppColors.pink600 : AppColors.whiteOpacity10,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        w,
        style: TextStyle(
          color: Colors.white,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ),
  );
}

class SeasonSection extends StatelessWidget {
  final String title;
  final List<GameModel> games;

  const SeasonSection({super.key, required this.title, required this.games});

  @override
  Widget build(BuildContext context) {
    if (games.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        ...games.map((g) => GameTile(game: g)),
      ],
    );
  }
}

class GameTile extends StatelessWidget {
  final GameModel game;

  const GameTile({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (ctx) => GameDetail(gameId: game.id)),
        );
      },

      child: _buildCard(context),
    );
  }

  Widget _buildCard(BuildContext context) {
    final home = game.home;
    final away = game.away;

    final date = "${game.date.day}/${game.date.month}/${game.date.year}";
    final time =
        "${game.date.hour.toString().padLeft(2, '0')}:${game.date.minute.toString().padLeft(2, '0')}";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.whiteOpacity10,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowOpacity30,
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                game.week.isNotEmpty ? game.week : '-',
                style: TextStyle(color: AppColors.grey400, fontSize: 11),
              ),
              _statusBadge(game.status),
            ],
          ),

          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$date  •  $time",
                style: TextStyle(color: AppColors.grey400, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _teamItem(home),
              Text(
                "${home.score ?? '-'}  :  ${away.score ?? '-'}",
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              _teamItem(away),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => VenuePage(venueName: game.venueName))
                    );
                  },
                  child: Text(
                    game.venueName,
                    style: TextStyle(
                      color: AppColors.pink300,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              Expanded(
                child: Text(
                  game.venueCity,
                  style: TextStyle(color: AppColors.grey400, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _teamItem(TeamGame team) {
    return Row(
      children: [
        CircleAvatar(radius: 18, backgroundImage: NetworkImage(team.logo)),
        const SizedBox(width: 8),
        SizedBox(
          width: 100,
          child: Text(
            team.name,
            style: TextStyle(color: AppColors.white, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(String status) {
    bool finished = status == "FT";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: finished
            ? AppColors.laLigaBadgeGradient
            : AppColors.purplePinkGradient,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        finished ? "Finished" : "Upcoming",
        style: TextStyle(color: AppColors.white, fontSize: 10),
      ),
    );
  }
}

class RegularSeasonSection extends StatelessWidget {
  final List<GameModel> games;
  const RegularSeasonSection({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<GamesViewModels>();
    final grouped = vm.regularSeasonByWeek;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: grouped.entries.map((entry) {
        return SeasonSection(title: entry.key, games: entry.value);
      }).toList(),
    );
  }
}
