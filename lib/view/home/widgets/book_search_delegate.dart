import 'package:easy_book/view/home/widgets/filter_widget.dart';
import 'package:easy_book/view/home/widgets/search_widget.dart';
import 'package:flutter/material.dart';

class BookSearchDelegate extends SearchDelegate {
  bool _isResult = false;
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query.trim().isEmpty ? close(context, null) : query = '',
      ),
      IconButton(
        icon: const Icon(
          Icons.filter_alt_outlined,
        ),
        onPressed: () => showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          builder: (context) => FilterWidget(
            query: query,
          ),
          context: context,
        ),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) {
    if (!_isResult) _isResult = true;
    return SearchWidget(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (_isResult) _isResult = false;
    return SearchWidget(
      query: query,
    );
  }
}
