import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tugas_akhir/data/repositories/auth_repositories.dart';
import 'package:tugas_akhir/data/repositories/bookmark_repositories.dart';
import 'package:tugas_akhir/data/repositories/game_repositories.dart';
import 'package:tugas_akhir/data/repositories/player_repositories.dart';
import 'package:tugas_akhir/data/repositories/standing_repositories.dart';
import 'package:tugas_akhir/data/repositories/team_repositories.dart';
import 'package:tugas_akhir/data/repositories/user_repositories.dart';
import 'package:tugas_akhir/data/repositories/venue_repositories.dart';
import 'package:tugas_akhir/data/services/cache_service.dart';
import 'package:tugas_akhir/data/services/currency_service.dart';
import 'package:tugas_akhir/data/services/db_service.dart';
import 'package:tugas_akhir/data/services/games_service.dart';
import 'package:tugas_akhir/data/services/locator_service.dart';
import 'package:tugas_akhir/data/services/players_service.dart';
import 'package:tugas_akhir/data/services/standings_service.dart';
import 'package:tugas_akhir/data/services/teams_service.dart';
import 'package:tugas_akhir/modelviews/game_detail_view_models.dart';
import 'package:tugas_akhir/modelviews/games_view_models.dart';
import 'package:tugas_akhir/modelviews/login_view_models.dart';
import 'package:tugas_akhir/modelviews/player_detail_view_models.dart';
import 'package:tugas_akhir/modelviews/search_view_models.dart';
import 'package:tugas_akhir/modelviews/setting_view_models.dart';
import 'package:tugas_akhir/modelviews/standings_view_models.dart';
import 'package:tugas_akhir/modelviews/team_detail_view_model.dart';
import 'package:tugas_akhir/modelviews/venue_view_models.dart';


List<SingleChildWidget> get appProviders => [  
  Provider(create: (_) => GameService()),
  Provider(create: (_) => PlayerService()),
  Provider(create: (_) => TeamsService()),
  Provider(create: (_) => StandingsService()),
  Provider(create: (_) => LocationService()),
  Provider(create: (_) => AuthService()),
  Provider(create: (_) => CurrencyService()),
  Provider(create: (_) => CacheService()),

  Provider(create: (context) => GameRepository(context.read<GameService>(), context.read<CacheService>())),
  Provider(create: (context) => PlayerRepositories(context.read<PlayerService>(), context.read<CurrencyService>())),
  Provider(create: (context) => TeamRepositories(context.read<TeamsService>())),
  Provider(create: (context) => StandingRepositories(context.read<StandingsService>())),
  Provider(create: (context) => AuthRepositories(context.read<AuthService>())),
  Provider(create: (context) => BookmarkRepositories(context.read<AuthService>())),
  Provider(create: (context) => VenueRepositories(context.read<LocationService>())),
  Provider(create: (context) => TeamRepositories(context.read<TeamsService>())),
  Provider(create: (context) => UserRepositories(context.read<CacheService>())),
  
  
  ChangeNotifierProvider(create: (context) => LoginViewModels(context.read<AuthRepositories>())),
  ChangeNotifierProvider(create: (context) => SearchViewModels(context.read<PlayerRepositories>(), context.read<TeamRepositories>())),
  ChangeNotifierProvider(create: (context) => GamesViewModels(context.read<GameRepository>())),
  ChangeNotifierProvider(create: (context) => GameDetailViewModels(context.read<GameRepository>())),
  ChangeNotifierProvider(create: (context) => TeamDetailViewModel(context.read<TeamRepositories>(), context.read<BookmarkRepositories>())),
  ChangeNotifierProvider(create: (context) => StandingsViewModels(context.read<StandingRepositories>())),
  ChangeNotifierProvider(create: (context) => VenueViewModels(context.read<VenueRepositories>())),
  ChangeNotifierProvider(create: (context) => SettingsViewModel(context.read<UserRepositories>())),
  ChangeNotifierProvider(create: (context) => PlayerDetailViewModels(context.read<PlayerRepositories>(), context.read<UserRepositories>())),
];