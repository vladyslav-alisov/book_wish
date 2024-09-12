import 'package:easy_book/models/genre/genre.dart';
import 'package:easy_book/view/home/widgets/genre_search_result.dart';
import 'package:flutter/material.dart';

class GenreSearchDelegate extends SearchDelegate<Genre?> {
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query.trim().isEmpty ? close(context, null) : query = '',
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) {
    return GenreSearchResultWidget(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return GenreSearchResultWidget(query: query);
  }
}
