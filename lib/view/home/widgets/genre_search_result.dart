import 'package:easy_book/models/genre/genre.dart';
import 'package:easy_book/providers/search_provider.dart';
import 'package:easy_book/view/home/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GenreSearchResultWidget extends StatefulWidget {
  const GenreSearchResultWidget({super.key, required this.query});

  final String query;
  @override
  State<GenreSearchResultWidget> createState() => _GenreSearchResultWidgetState();
}

class _GenreSearchResultWidgetState extends State<GenreSearchResultWidget> {
  late final ScrollController _scrollController;

  final int _add = 480;
  final int _limit = 20;
  int _searchOffset = 20;

  int _scrollOffset = 480;
  bool _isButtonVisible = false;

  SearchProvider get _searchProvider => context.read<SearchProvider>();

  int get _timeToScroll => _genreList.length * 2;

  final List<Genre> _genreList = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
    _searchProvider.searchGenre(0, widget.query).then(
      (value) {
        setState(() {
          _genreList.addAll(value);
        });
      },
    );
  }

  @override
  void didUpdateWidget(covariant GenreSearchResultWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) {
      _genreList.clear();
      _searchProvider.searchGenre(0, widget.query).then(
        (value) {
          setState(() {
            _genreList.addAll(value);
          });
        },
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onItemPress(Genre genre) => Navigator.pop(context, genre);

  void _handleScroll() {
    if (_scrollController.offset > _scrollOffset) {
      _scrollOffset += _add;
      _searchOffset += _limit;
      _searchProvider.searchGenre(_searchOffset, widget.query).then((value) => setState(() {
            _genreList.addAll(value);
          }));
    }
    if (_scrollController.offset > 1000 && !_isButtonVisible) {
      setState(() => _isButtonVisible = true);
    }
    if (_scrollController.offset <= 1000 && _isButtonVisible) {
      setState(() => _isButtonVisible = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _isButtonVisible
          ? FloatingActionButton(
              child: const Icon(Icons.arrow_upward),
              onPressed: () =>
                  _scrollController.animateTo(0, duration: Duration(milliseconds: _timeToScroll), curve: Curves.ease),
            )
          : null,
      body: Consumer<SearchProvider>(
        builder: (context, value, child) {
          return _genreList.isEmpty
              ? NoDataWidget()
              : ListView.builder(
                  itemCount: _genreList.length,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () => _onItemPress(_genreList[index]),
                      title: Text(_genreList[index].name),
                    );
                  },
                );
        },
      ),
    );
  }
}
