import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/core/session.dart';
import 'package:tugas_akhir/modelviews/games_view_models.dart';
import 'package:tugas_akhir/views/bottom_nav.dart';
import 'package:tugas_akhir/views/games.dart';
import 'package:tugas_akhir/views/search.dart';
import 'package:tugas_akhir/views/standings.dart';
import 'package:tugas_akhir/modelviews/standings_view_models.dart';
import 'package:tugas_akhir/core/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController mainTab;
  late TabController standingsTab;

  void _checkSession() async {
    final hasSession = await Provider.of<SessionCheck>(
      context,
      listen: false,
    ).sessionCheck();

    if (hasSession) {
      Future.microtask(
        () => Provider.of<StandingsViewModels>(
          context,
          listen: false,
        ).fetchStandings(),
      );

      Future.microtask(
        () => Provider.of<GamesViewModels>(context, listen: false).loadGames(),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    mainTab = TabController(length: 2, vsync: this);
    standingsTab = TabController(length: 3, vsync: this);
    _checkSession();
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
                    StandingsPage(standingsTab: standingsTab),
                    const GamesPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(currentIndex: 0),
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
        shaderCallback: (bounds) => AppColors.titleShaderGradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "NFL Standings",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchView()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
