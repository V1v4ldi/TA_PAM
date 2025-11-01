import 'package:tugas_akhir/data/repositories/player_repositories.dart';
import 'package:tugas_akhir/data/repositories/team_repositories.dart';
import 'package:tugas_akhir/data/services/players_service.dart';
import 'package:tugas_akhir/data/services/teams_service.dart';

final playerService = PlayerService();
final teamService = TeamsService();
final playerRepo = PlayerRepositories(playerService);
final teamRepo = TeamRepositories(teamService);