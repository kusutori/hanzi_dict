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
    final favorites = Provider.of<FavoritesProvider>(context).favorites;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.favorites)),
      body:
          favorites.isEmpty
              ? Center(child: Text(localizations.noFavoritesYet))
              : ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  return HanziCard(item: favorites[index]);
                },
              ),
    );
  }
}
