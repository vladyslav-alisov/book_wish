import 'package:easy_book/models/book/book.dart';
import 'package:easy_book/providers/search_provider.dart';
import 'package:easy_book/utils/page_route_transition.dart';
import 'package:easy_book/view/home/details_screen.dart';
import 'package:easy_book/view/home/widgets/book_list.dart';
import 'package:easy_book/view/home/widgets/no_data_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key, required this.query});

  final String query;
  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late final ScrollController _scrollController;

  final int _add = 480;
  final int _limit = 20;
  int _booksOffset = 20;

  int _scrollOffset = 480;
  bool _isButtonVisible = false;
  bool _isLoading = false;

  SearchProvider get _searchProvider => context.read<SearchProvider>();

  int get _timeToScroll => _searchProvider.searchBooks.length * 2;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _scrollController = ScrollController()..addListener(_handleScroll);
    _searchProvider.search(0, _limit, input: widget.query).then(
          (value) => setState(() => _isLoading = false),
        );
  }

  @override
  void didUpdateWidget(covariant SearchWidget oldWidget) {
    if (oldWidget.query != widget.query) {
      _searchProvider.search(0, _limit, input: widget.query);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onItemPress(Book book) => Navigator.push(
        context,
        createRoute(DetailsScreen(book: book)),
      );

  void _handleScroll() {
    if (_scrollController.offset > _scrollOffset) {
      _scrollOffset += _add;
      _booksOffset += _limit;
      _searchProvider.fetchMore(_booksOffset, _limit);
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<SearchProvider>(
            builder: (context, value, child) {
              return _isLoading
                  ? const Center(
                      child: CupertinoActivityIndicator(),
                    )
                  : value.searchBooks.isEmpty
                      ? const NoDataWidget()
                      : Expanded(
                          child: BookList(
                            onItemTap: _onItemPress,
                            scrollController: _scrollController,
                            bookList: value.searchBooks,
                          ),
                        );
            },
          ),
        ],
      ),
    );
  }
}
