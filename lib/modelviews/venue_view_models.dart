import 'package:flutter/material.dart';
import 'package:tugas_akhir/data/models/venue_model.dart';
import 'package:tugas_akhir/data/repositories/venue_repositories.dart';

class VenueViewModels extends ChangeNotifier {
  final VenueRepositories _venueRepositories;

  VenueViewModels(this._venueRepositories);

  bool _isLoading = false;
  VenueModel? _mapModel;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  VenueModel? get mapModel => _mapModel;

  Future<void> loadMaps(String venueName) async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await _venueRepositories.getRouteToVenue(venueName);
      _mapModel = data;
      print(_mapModel);
    } catch (e) {
      print(_mapModel?.routePoints);
      _errorMessage = "Gagal Memuat Peta: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
