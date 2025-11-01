import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_akhir/data/repositories/player_repositories.dart';
import 'package:tugas_akhir/data/repositories/team_repositories.dart';
import 'package:tugas_akhir/data/services/players_service.dart';
import 'package:tugas_akhir/data/services/teams_service.dart';
import 'package:tugas_akhir/modelviews/home_view_models.dart';
import 'package:tugas_akhir/modelviews/login_view_models.dart';
import 'package:tugas_akhir/views/home.dart';
import 'package:tugas_akhir/views/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MaterialApp(home: FootballApp()));
  });
}

class FootballApp extends StatelessWidget {
  const FootballApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModels()),
        ChangeNotifierProvider(create: (_) => StandingsViewModel()),
        ChangeNotifierProvider(create: (_) => GamesViewModel()),
        Provider(create: (_) => PlayerService()),
        Provider(create: (context) => PlayerRepositories(context.read<PlayerService>())),
        Provider(create: (_) => TeamsService()),
        Provider(create: (context) => TeamRepositories(context.read<TeamsService>())),
      ],
      child: MaterialApp(
        title: 'Football Hub',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.purple,
        ),
        home: const HomePage(),
      ),
    );
  }
}
