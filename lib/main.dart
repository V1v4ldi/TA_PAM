import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tugas_akhir/core/provider.dart';
import 'package:tugas_akhir/views/home.dart';
import 'package:tugas_akhir/views/login.dart';
import 'package:tugas_akhir/views/profile.dart';
import 'package:tugas_akhir/views/search.dart';
import 'package:tugas_akhir/views/settings.dart';
import 'package:tugas_akhir/core/notif.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
    
    await initNotifications();

    await Hive.initFlutter();
    await Hive.openLazyBox("cacheBox");

    tz.initializeTimeZones();
  } catch (e) {
    throw Exception("Error Load .env: $e");
  }


  await Supabase.initialize(
    url: dotenv.env['SUPABASEHOST'] ?? "",
    anonKey: dotenv.env['SUPABASEAPI'] ?? "",
  );

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
      providers: appProviders,
      child: MaterialApp(
        title: 'Football Hub',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.purple,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (_) => const Login(),
          '/home': (_) => const HomePage(),
          '/search': (_) => const SearchView(),
          '/profile': (_) => const Profile(),
          '/settings': (_) => const Settings(),
        },
      ),
    );
  }
}
