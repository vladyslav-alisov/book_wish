import 'package:easy_book/models/author/author.dart';
import 'package:easy_book/providers/search_provider.dart';
import 'package:easy_book/view/home/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthorSearchResultWidget extends StatefulWidget {
  const AuthorSearchResultWidget({super.key, required this.query});

  final String query;
  @override
  State<AuthorSearchResultWidget> createState() => _AuthorSearchResultWidgetState();
}

class _AuthorSearchResultWidgetState extends State<AuthorSearchResultWidget> {
  late final ScrollController _scrollController;

  final int _add = 480;
  final int _limit = 20;
  int _searchOffset = 20;

  int _scrollOffset = 480;
  bool _isButtonVisible = false;

  SearchProvider get _searchProvider => context.read<SearchProvider>();

  int get _timeToScroll => _authorList.length * 2;

  final List<Author> _authorList = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
    _searchProvider.searchAuthors(0, widget.query).then(
      (value) {
        setState(() => _authorList.addAll(value));
      },
    );
  }

  @override
  void didUpdateWidget(covariant AuthorSearchResultWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) {
      _searchProvider.searchAuthors(0, widget.query).then(
        (value) {
          print("value len: ${value.length}");
          _authorList.clear();
          setState(() {
            _authorList.addAll(value);
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

  void _onItemPress(Author author) => Navigator.pop(context, author);

  void _handleScroll() {
    if (_scrollController.offset > _scrollOffset) {
      _scrollOffset += _add;
      _searchOffset += _limit;
      _searchProvider.searchAuthors(_searchOffset, widget.query).then((value) {
        if (value.isNotEmpty) {
          setState(() {
            _authorList.addAll(value);
          });
        }
      });
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
      body: _authorList.isEmpty
          ? const NoDataWidget()
          : ListView.builder(
              controller: _scrollController,
              itemCount: _authorList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => _onItemPress(_authorList[index]),
                  title: Text(_authorList[index].name),
                );
              },
            ),
    );
  }
}
