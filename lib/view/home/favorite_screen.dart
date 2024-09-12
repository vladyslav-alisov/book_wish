import 'package:easy_book/l10n/translate_extension.dart';
import 'package:easy_book/models/book/book.dart';
import 'package:easy_book/providers/book_provider.dart';
import 'package:easy_book/utils/page_route_transition.dart';
import 'package:easy_book/view/home/details_screen.dart';
import 'package:easy_book/view/home/widgets/book_list.dart';
import 'package:easy_book/view/home/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key, required this.isFavorite});

  final bool isFavorite;

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  BookProvider get _bookProvider => context.read<BookProvider>();

  late final ScrollController _scrollController;

  final int _add = 480;
  final int _limit = 20;
  int _booksOffset = 20;

  int _scrollOffset = 480;
  bool _isButtonVisible = false;

  int get _timeToScroll => _bookProvider.favoriteBooks.length * 2;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
    widget.isFavorite
        ? _bookProvider.initFetchFavoriteBooks(0, _limit)
        : _bookProvider.initFetchAlreadyReadBooks(0, _limit);
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

  void _onLikePress(Book book) {
    _bookProvider.changeFavoriteStatus(book.dbId);
  }

  void _handleScroll() {
    if (_scrollController.offset > _scrollOffset) {
      _scrollOffset += _add;
      _booksOffset += _limit;
      widget.isFavorite
          ? _bookProvider.fetchFavoriteBooks(_booksOffset, _limit)
          : _bookProvider.fetchAlreadyReadBooks(_booksOffset, _limit);
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
              onPressed: () => _scrollController.animateTo(
                0,
                duration: Duration(milliseconds: _timeToScroll),
                curve: Curves.ease,
              ),
            )
          : null,
      appBar: AppBar(
        title: Text(widget.isFavorite ? context.l10n.favoriteBooks : context.l10n.readBooks),
      ),
      body: Consumer<BookProvider>(
        builder: (context, value, child) {
          return (widget.isFavorite ? value.favoriteBooks.isEmpty : value.alreadyRead.isEmpty)
              ? NoDataWidget(
                  widget: widget.isFavorite
                      ? context.l10n.youHaveNotAddedAnyBooksToYourFavoriteYet
                      : context.l10n.yourReadBooksWillShowUpHereOnce)
              : BookList(
                  onItemTap: _onItemPress,
                  scrollController: _scrollController,
                  bookList: widget.isFavorite ? value.favoriteBooks : value.alreadyRead,
                  onLikeTap: _onLikePress,
                );
        },
      ),
    );
  }
}
