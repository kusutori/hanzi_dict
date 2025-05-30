import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/hanzi_card.dart';
// import 'models/mcp_dict.dart';
import 'models/favorites_provider.dart';
import 'l10n/app_localizations.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.favorites),
        actions: [
          if (favoritesProvider.favorites.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Text(
                  localizations.favoritesCount(
                    favoritesProvider.favoritesCount,
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
        ],
      ),
      body:
          !favoritesProvider.isInitialized
              ? const Center(child: CircularProgressIndicator())
              : favoritesProvider.favorites.isEmpty
              ? Center(child: Text(localizations.noFavoritesYet))
              : ListView.builder(
                itemCount: favoritesProvider.favorites.length,
                itemBuilder: (context, index) {
                  return HanziCard(item: favoritesProvider.favorites[index]);
                },
              ),
    );
  }
}
