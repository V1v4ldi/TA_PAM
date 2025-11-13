import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/modelviews/games_view_models.dart';
import 'package:tugas_akhir/views/bottom_nav.dart';
import 'package:tugas_akhir/views/games.dart';
import 'package:tugas_akhir/views/search.dart';
import 'package:tugas_akhir/views/standings.dart';
import '../modelviews/standings_view_models.dart';
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
        Provider.of<StandingsViewModels>(context, listen: false).fetchStandings());

    // Fetch games once
    Future.microtask(() =>
        Provider.of<GamesViewModels>(context, listen: false).loadGames());
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
                  StandingsPage(standingsTab: standingsTab),
                  const GamesPage(),
                  ],
                ),
              )
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