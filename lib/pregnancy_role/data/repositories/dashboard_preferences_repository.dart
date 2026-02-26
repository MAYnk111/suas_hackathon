import 'package:hive_flutter/hive_flutter.dart';
import 'package:sudha_app/pregnancy_role/data/models/dashboard_card_model.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/user_provider.dart';

import 'package:sudha_app/pregnancy_role/core/constants/app_constants.dart';

class DashboardPreferencesRepository {
  late Box<DashboardCardModel> _box;
  // Separate defaults for different user types
  static const String _pregnantPrefix = 'pregnant_';
  static const String _toddlerPrefix = 'toddler_';
  static const String _tryingPrefix = 'trying_';

  DashboardPreferencesRepository();

  Future<void> init() async {
    _box = await Hive.openBox<DashboardCardModel>(AppConstants.dashboardBox);
    
    // TEMPORARY: Clear old TTC cards and reinitialize with ovulation_prediction
    print('DEBUG: Checking for old TTC card data...');
    final oldTTCCards = _box.values.where((card) => card.id.startsWith(_tryingPrefix)).toList();
    if (oldTTCCards.isNotEmpty) {
      print('DEBUG: Found ${oldTTCCards.length} old TTC cards, checking if ovulation_prediction exists...');
      final hasOvulation = oldTTCCards.any((card) => card.widgetType == 'ovulation_prediction');
      if (!hasOvulation) {
        print('DEBUG: No ovulation_prediction card found, clearing and reinitializing TTC defaults');
        // Remove old cards
        for (var card in oldTTCCards) {
          _box.delete(card.id);
        }
        // Reinitialize with new defaults
        _initializeDefaults(UserProfileType.tryingToConceive);
      }
    }
  }

  // Get cards for a specific user type
  List<DashboardCardModel> getCards(UserProfileType type) {
    final prefix = type == UserProfileType.pregnant
        ? _pregnantPrefix
        : type == UserProfileType.tryingToConceive 
            ? _tryingPrefix 
            : _toddlerPrefix;
    final cards = _box.values.where((card) => card.id.startsWith(prefix)).toList();
    
    print('DEBUG DashboardRepo: getCards for $type, prefix=$prefix, found ${cards.length} cards');
    for (var card in cards) {
      print('  - ${card.widgetType}: ${card.title} (id: ${card.id})');
    }
    
    if (cards.isEmpty) {
      print('DEBUG DashboardRepo: No cards found, initializing defaults');
      return _initializeDefaults(type);
    }
    
    cards.sort((a, b) => a.order.compareTo(b.order));
    return cards;
  }

  // Update card order
  Future<void> updateCardOrder(UserProfileType type, List<DashboardCardModel> orderedCards) async {
    for (int i = 0; i < orderedCards.length; i++) {
      final card = orderedCards[i];
      card.order = i;
      await card.save();
    }
  }

  // Toggle visibility
  Future<void> toggleCardVisibility(String cardId, bool visible) async {
    final card = _box.values.firstWhere((c) => c.id == cardId);
    card.isVisible = visible;
    await card.save();
  }

  // Initialize default cards if none exist
  List<DashboardCardModel> _initializeDefaults(UserProfileType type) {
    List<DashboardCardModel> defaults = [];
    final prefix = type == UserProfileType.pregnant
        ? _pregnantPrefix
        : type == UserProfileType.tryingToConceive 
            ? _tryingPrefix 
            : _toddlerPrefix;

    if (type == UserProfileType.pregnant) {
      defaults = [
        DashboardCardModel(id: '${prefix}daily_summary', title: 'Daily Summary', widgetType: 'daily_summary', order: 0),
        DashboardCardModel(id: '${prefix}weekly_stats', title: 'Weekly Insights', widgetType: 'weekly_stats', order: 1),
        DashboardCardModel(id: '${prefix}hospital_bag', title: 'Hospital Bag', widgetType: 'hospital_bag', order: 2),
        DashboardCardModel(id: '${prefix}symptoms', title: 'Symptom Tracker', widgetType: 'symptom_tracker', order: 3),
        DashboardCardModel(id: '${prefix}kick_counter', title: 'Kick Counter', widgetType: 'kick_counter', order: 4),
        DashboardCardModel(id: '${prefix}tips', title: 'Daily Tips', widgetType: 'daily_tips', order: 5),
      ];
    } else if (type == UserProfileType.tryingToConceive) {
      defaults = [
        DashboardCardModel(id: '${prefix}fertility_overview', title: 'Fertility Overview', widgetType: 'fertility_overview', order: 0),
        DashboardCardModel(id: '${prefix}ovulation_window', title: 'Ovulation Window', widgetType: 'ovulation_window', order: 1),
        DashboardCardModel(id: '${prefix}ovulation_prediction', title: 'ML Ovulation Prediction', widgetType: 'ovulation_prediction', order: 2),
        DashboardCardModel(id: '${prefix}tips', title: 'Fertility Tips', widgetType: 'daily_tips', order: 3),
      ];
    } else {
      defaults = [
        DashboardCardModel(id: '${prefix}tracker_hub', title: 'Daily Trackers', widgetType: 'tracker_hub', order: 0),
        DashboardCardModel(id: '${prefix}daily_summary', title: 'Daily Summary', widgetType: 'daily_summary', order: 1),
        DashboardCardModel(id: '${prefix}weekly_stats', title: 'Weekly Insights', widgetType: 'weekly_stats', order: 2),
        DashboardCardModel(id: '${prefix}milestones', title: 'Milestones', widgetType: 'milestones', order: 3),
        DashboardCardModel(id: '${prefix}vaccinations', title: 'Vaccinations', widgetType: 'vaccinations', order: 4),
        DashboardCardModel(id: '${prefix}growth', title: 'Growth Chart', widgetType: 'growth_chart', order: 5),
        DashboardCardModel(id: '${prefix}activity', title: 'Activity Ideas', widgetType: 'activity_suggestions', order: 6),
        DashboardCardModel(id: '${prefix}tips', title: 'Parenting Tips', widgetType: 'daily_tips', order: 7),
      ];
    }

    _box.putAll({for (var c in defaults) c.id: c});
    return defaults;
  }
}

