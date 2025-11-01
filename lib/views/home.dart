import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/data/models/standings_model.dart';
import 'package:tugas_akhir/views/search.dart';
import '../modelviews/home_view_models.dart';
import '../core/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController mainTab;  // Standings / Games
  late TabController standingsTab; // League / Conference / Division

  @override
  void initState() {
    super.initState();
    mainTab = TabController(length: 2, vsync: this);
    standingsTab = TabController(length: 3, vsync: this);

    // Fetch standings once
    Future.microtask(() =>
        Provider.of<StandingsViewModel>(context, listen: false).fetchStandings());

    // Fetch games once
    Future.microtask(() =>
        Provider.of<GamesViewModel>(context, listen: false).loadGames());
  }

  @override
  void dispose() {
    mainTab.dispose();
    standingsTab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.mainBackgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              const _AppHeader(),

              // 🔥 Tab Standings - Games
              TabBar(
                controller: mainTab,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: "Standings"),
                  Tab(text: "Games"),
                ],
              ),

              Expanded(
                child: TabBarView(
                  controller: mainTab,
                  children: [

                    // ✅ STANDINGS TAB PAGE
                    Column(
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
                    ),

                    // ✅ GAMES TAB PAGE
                    const GamesContent(),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class _AppHeader extends StatelessWidget {
  const _AppHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 20, right: 20),
      child: ShaderMask(
        shaderCallback: (bounds) =>
            AppColors.titleShaderGradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        // jangan pakai `const` di sini karena kita butuh context di onPressed
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "NFL Standings",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white, // wajib putih supaya ShaderMask bekerja
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SearchView(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


class StandingsContent extends StatelessWidget {
  final String type; // league / conference / division
  const StandingsContent({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Consumer<StandingsViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.fetchingData) {
          return Center(child: CircularProgressIndicator(color: AppColors.purple300));
        }

        if (viewModel.matches.isEmpty) {
          return Center(
            child: Text("Data tidak ditemukan.", style: TextStyle(color: AppColors.grey300)),
          );
        }

        Map<String, List<MatchModel>> grouped = {};
        if (type == 'league') grouped = viewModel.groupedByLeague;
        if (type == 'conference') grouped = viewModel.groupedByConference;
        if (type == 'division') grouped = viewModel.groupedByDivision;

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          children: grouped.entries.map((entry) {
            return _GroupCard(
              title: entry.key,
              subtitle: "Teams in ${entry.key}",
              teams: entry.value,
            );
          }).toList(),
        );
      },
    );
  }
}

class _GroupCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<MatchModel> teams;

  const _GroupCard({
    required this.title,
    required this.subtitle,
    required this.teams,
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
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: AppColors.grey400, fontSize: 12)),
          const Divider(height: 12, color: AppColors.grey400),
          ...teams.map((t) => _TeamRow(team: t)).toList(),
        ],
      ),
    );
  }
}

class _TeamRow extends StatelessWidget {
  final MatchModel team;
  const _TeamRow({required this.team});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          SizedBox(width: 30, child: Text(team.position.toString(), style: TextStyle(color: AppColors.purple300, fontWeight: FontWeight.bold))),
          const SizedBox(width: 8),
          if (team.teamLogo.isNotEmpty)
            Image.network(team.teamLogo, width: 28, height: 28, errorBuilder: (_, __, ___) => const SizedBox(width: 28, height: 28)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(team.teamName, style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: 8),
          Text('${team.won}-${team.lost}-${team.ties}', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class GamesContent extends StatelessWidget {
  const GamesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GamesViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (vm.games.isEmpty) {
          return const Center(child: Text("No games found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: vm.games.length,
          itemBuilder: (_, i) {
            final game = vm.games[i];
            return ListTile(
              title: Text("${game.home.name} vs ${game.away.name}",
                  style: const TextStyle(color: Colors.white)),
              subtitle: Text(game.date.toString(),
                  style: const TextStyle(color: Colors.grey)),
            );
          },
        );
      },
    );
  }
}
