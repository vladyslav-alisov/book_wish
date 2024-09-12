import 'package:easy_book/l10n/translate_extension.dart';
import 'package:easy_book/models/author/author.dart';
import 'package:easy_book/models/genre/genre.dart';
import 'package:easy_book/providers/search_provider.dart';
import 'package:easy_book/view/home/widgets/author_search_delegate.dart';
import 'package:easy_book/view/home/widgets/genre_search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({super.key, required this.query});

  final String query;

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  SearchProvider get _searchProvider => context.read<SearchProvider>();

  void _onAuthorTap() async {
    Author? author = await showSearch<Author?>(context: context, delegate: AuthorSearchDelegate());
    _searchProvider.setAuthorFilter(author);
  }

  void _onGenreTap() async {
    Genre? genre = await showSearch<Genre?>(context: context, delegate: GenreSearchDelegate());
    _searchProvider.setGenreFilter(genre);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 24, left: 12, right: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.filter,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(onPressed: _searchProvider.resetFilters, icon: const Icon(Icons.refresh))
            ],
          ),
          const Divider(
            height: 4,
            thickness: 1,
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.author,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Selector<SearchProvider, Author?>(
                builder: (_, Author? value, __) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TextButton(
                          onPressed: _onAuthorTap,
                          child: Text(value?.name ?? "All"),
                        ),
                      ),
                      if (value != null)
                        IconButton(onPressed: () => _searchProvider.clearAuthorFilter(), icon: const Icon(Icons.clear)),
                    ],
                  );
                },
                selector: (_, SearchProvider provider) => provider.filterAuthor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.genre,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Selector<SearchProvider, Genre?>(
                builder: (_, Genre? value, __) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TextButton(
                          onPressed: _onGenreTap,
                          child: Text(value?.name ?? "All"),
                        ),
                      ),
                      if (value != null)
                        IconButton(onPressed: () => _searchProvider.clearGenreFilter(), icon: const Icon(Icons.clear)),
                    ],
                  );
                },
                selector: (_, SearchProvider provider) => provider.filterGenre,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
