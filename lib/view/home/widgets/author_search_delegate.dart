import 'package:easy_book/models/author/author.dart';
import 'package:easy_book/view/home/widgets/author_search_result.dart';
import 'package:flutter/material.dart';

class AuthorSearchDelegate extends SearchDelegate<Author?> {
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
    return AuthorSearchResultWidget(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return AuthorSearchResultWidget(query: query);
  }
}
