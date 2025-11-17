import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/core/theme.dart';
import 'package:tugas_akhir/data/models/standings_model.dart';
import 'package:tugas_akhir/modelviews/standings_view_models.dart';
import 'package:tugas_akhir/views/team_detail.dart';

class StandingsPage extends StatelessWidget {
  const StandingsPage({super.key, required this.standingsTab});
  final TabController standingsTab;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: standingsTab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'League'),
            Tab(text: 'Conference'),
            Tab(text: 'Division'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: standingsTab,
            children: const [
              StandingsContent(type: "league"),
              StandingsContent(type: "conference"),
              StandingsContent(type: "division"),
            ],
          ),
        ),
      ],
    );
  }
}

class StandingsContent extends StatelessWidget {
  final String type;
  const StandingsContent({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Consumer<StandingsViewModels>(
      builder: (context, viewModel, child) {
        if (viewModel.fetchingData) {
          return Center(child: CircularProgressIndicator(color: AppColors.purple300));
        }

        if (viewModel.matches.isEmpty) {
          return Center(child: Text("Data tidak ditemukan.", style: TextStyle(color: AppColors.grey300)));
        }

        Map<String, List<StandingsModel>> grouped = {};
        if (type == 'league') {
          final list = viewModel.leagueSorted;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, i) {
              return _LeagueTeamCard(
                index: i + 1,
                team: list[i],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TeamDetail(teamId: list[i].teamId),
                    ),
                  );
                },
              );
            },
          );
        }
        if (type == 'conference') grouped = viewModel.groupedByConference;
        if (type == 'division') grouped = viewModel.groupedByDivision;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: grouped.entries.map((entry) {
            return _GroupCard(title: entry.key,
              subtitle: "Teams in ${entry.key}",
              teams: entry.value,
              isLeague: type == "league",);
          }).toList(),
        );
      },
    );
  }
}

class _LeagueTeamCard extends StatelessWidget {
  final StandingsModel team;
  final int index;
  final VoidCallback onTap;

  const _LeagueTeamCard({
    required this.team,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.whiteOpacity10,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.whiteOpacity20),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Text(
                "$index",
                style: TextStyle(
                  color: AppColors.purple300,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 8),

            Image.network(team.teamLogo, width: 32, height: 32),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                team.teamName,
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Text(
              "${team.won}-${team.lost}-${team.ties}",
              style: TextStyle(color: AppColors.white),
            )
          ],
        ),
      ),
    );
  }
}


class _GroupCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<StandingsModel> teams;
  final bool isLeague;

  const _GroupCard({
    required this.title,
    required this.subtitle,
    required this.teams,
    required this.isLeague,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.whiteOpacity10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.whiteOpacity20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          Text(subtitle, style: TextStyle(color: AppColors.grey400, fontSize: 12)),
          const Divider(height: 10, color: AppColors.grey400),
          ...List.generate(teams.length, (i) {
            return _TeamRow(team: teams[i], index: i + 1);
          }).toList()
        ],
      ),
    );
  }
}

class _TeamRow extends StatelessWidget {
  final StandingsModel team;
  final int index;

  const _TeamRow({required this.team, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 30, child: Text(index.toString(),
            style: TextStyle(color: AppColors.purple300, fontWeight: FontWeight.bold)
        )),
        SizedBox(width: 8),
        Image.network(team.teamLogo, width: 28, height: 28),
        SizedBox(width: 8),
        Expanded(child: Text(team.teamName, style: TextStyle(color: AppColors.white))),
        Text('${team.won}-${team.lost}-${team.ties}', style: TextStyle(color: AppColors.white)),
      ],
    );
  }
}