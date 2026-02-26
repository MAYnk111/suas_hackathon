import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudha_app/pregnancy_role/data/models/dashboard_card_model.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/repository_providers.dart';
import 'package:sudha_app/pregnancy_role/presentation/viewmodels/user_provider.dart';
import 'package:sudha_app/pregnancy_role/data/repositories/dashboard_preferences_repository.dart';

class CustomizableDashboard extends ConsumerStatefulWidget {
  final Widget Function(BuildContext context, DashboardCardModel card) cardBuilder;
  final Widget header;

  const CustomizableDashboard({
    super.key,
    required this.cardBuilder,
    required this.header,
  });

  @override
  ConsumerState<CustomizableDashboard> createState() => _CustomizableDashboardState();
}

class _CustomizableDashboardState extends ConsumerState<CustomizableDashboard> {
  bool _isEditMode = false;

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final preferencesRepo = ref.watch(dashboardPreferencesProvider);
    
    print('DEBUG CustomizableDashboard: userProfile=$userProfile, loading widgets...');

    return preferencesRepo.when(
      data: (repo) {
        print('DEBUG CustomizableDashboard: Dashboard preferences loaded, userProfile=$userProfile');
        if (userProfile == null) {
          print('DEBUG CustomizableDashboard: userProfile is null, showing loading indicator');
          return const Center(child: CircularProgressIndicator());
        }
        
        final cards = repo.getCards(userProfile);
        final visibleCards = _isEditMode ? cards : cards.where((c) => c.isVisible).toList();
        print('DEBUG CustomizableDashboard: Total cards: ${cards.length}, Visible cards: ${visibleCards.length}');
        for (var card in visibleCards) {
          print('DEBUG CustomizableDashboard: Card - ${card.widgetType} (${card.title}), visible=${card.isVisible}');
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard'),
            centerTitle: true,
            automaticallyImplyLeading: false, 
          ),
          floatingActionButton: _isEditMode
              ? FloatingActionButton.extended(
                  onPressed: () {
                    setState(() {
                      _isEditMode = false;
                    });
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Done'),
                  heroTag: 'fab_dashboard_edit',
                )
              : null,
          body: ReorderableListView(
            header: Column(
              children: [
                widget.header,
                if (!_isEditMode)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _isEditMode = true;
                            });
                          },
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text('Customize'),
                        ),
                      ],
                    ),
                  ),
                if (_isEditMode)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Drag to reorder • Tap eye to toggle visibility',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            padding: const EdgeInsets.only(bottom: 80),
            onReorder: (oldIndex, newIndex) async {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final item = cards.removeAt(oldIndex);
              cards.insert(newIndex, item);
              
              // Optimistic update
              setState(() {});
              
              // Persist
              await repo.updateCardOrder(userProfile, cards);
            },
            children: [
              if (visibleCards.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.dashboard_customize, size: 64, color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                        const SizedBox(height: 24),
                        Text(
                          'No cards visible',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Click "Customize" to show cards on your dashboard',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                for (final card in visibleCards)
                  _buildCardWrapper(context, card, repo, userProfile),
            ],
          ),
        );
      },
      loading: () {
        print('DEBUG CustomizableDashboard: Loading preferences...');
        return const Center(child: CircularProgressIndicator());
      },
      error: (e, s) {
        print('DEBUG CustomizableDashboard: Error loading preferences: $e');
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
              const SizedBox(height: 16),
              Text('Error loading dashboard: $e', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(dashboardPreferencesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCardWrapper(
    BuildContext context, 
    DashboardCardModel card, 
    DashboardPreferencesRepository repo,
    UserProfileType userType,
  ) {
    return Container(
      key: ValueKey(card.id),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        children: [
          // The actual card content
          Opacity(
            opacity: _isEditMode && !card.isVisible ? 0.5 : 1.0,
            child: widget.cardBuilder(context, card),
          ),
          
          // Edit mode overlay
          if (_isEditMode)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                    )
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    card.isVisible ? Icons.visibility : Icons.visibility_off,
                    color: card.isVisible 
                        ? Theme.of(context).colorScheme.primary 
                        : Colors.grey,
                  ),
                  onPressed: () async {
                    await repo.toggleCardVisibility(card.id, !card.isVisible);
                    setState(() {});
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

