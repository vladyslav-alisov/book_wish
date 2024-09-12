import 'package:easy_book/const/assets.gen.dart';
import 'package:easy_book/l10n/translate_extension.dart';
import 'package:easy_book/models/book/book.dart';
import 'package:easy_book/providers/book_provider.dart';
import 'package:easy_book/providers/search_provider.dart';
import 'package:easy_book/utils/page_route_transition.dart';
import 'package:easy_book/view/home/details_screen.dart';
import 'package:easy_book/view/home/favorite_screen.dart';
import 'package:easy_book/view/home/widgets/book_search_delegate.dart';
import 'package:easy_book/view/settings/settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController _scrollController;

  final int _add = 480;
  final int _limit = 20;
  int _booksOffset = 20;

  int _scrollOffset = 480;
  bool _isButtonVisible = false;

  BookProvider get _homeProvider => context.read<BookProvider>();

  int get _timeToScroll => _homeProvider.books.length * 2;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
    _homeProvider.initBooks(0, _limit);
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

  void _onLikePress(Book book) => _homeProvider.changeFavoriteStatus(book.dbId);

  void _handleScroll() {
    if (_scrollController.offset > _scrollOffset) {
      _scrollOffset += _add;
      _booksOffset += _limit;
      _homeProvider.fetchMore(_booksOffset, _limit);
    }
    if (_scrollController.offset > 1000 && !_isButtonVisible) {
      setState(() => _isButtonVisible = true);
    }
    if (_scrollController.offset <= 1000 && _isButtonVisible) {
      setState(() => _isButtonVisible = false);
    }
  }

  void _handleSearchPress() async {
    await showSearch(
      context: context,
      delegate: BookSearchDelegate(),
    );
    if (mounted) context.read<SearchProvider>().resetSearch();
  }

  void _handleSettingsPress() {
    Navigator.push(
      context,
      createRoute(SettingsScreen()),
    );
  }

  void _handleFavoritePress() {
    Navigator.push(
      context,
      createRoute(FavoriteScreen(isFavorite: true)),
    );
  }

  void _handleDidReadPress() {
    Navigator.push(
      context,
      createRoute(FavoriteScreen(isFavorite: false)),
    );
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
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            expandedHeight: 190,
            flexibleSpace: FlexibleSpaceBar(
              background: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: _handleSearchPress,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: const BoxDecoration(
                              color: CupertinoColors.tertiarySystemFill,
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Theme.of(context).hintColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  context.l10n.search,
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            OutlinedButton(
                              style: ButtonStyle(
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                              ),
                              onPressed: _handleFavoritePress,
                              child: Text(context.l10n.favorite),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            OutlinedButton(
                              style: ButtonStyle(
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                              ),
                              onPressed: _handleDidReadPress,
                              child: Text(context.l10n.alreadyRead),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            title: Row(
              children: [
                Image.asset(
                  Assets.images.logoBgRemoved.path,
                  height: 60,
                  width: 60,
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  "Book Wish",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  // style: GoogleFonts.playfairDisplay(),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: _handleSettingsPress,
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
          Consumer<BookProvider>(
            builder: (context, value, child) => SliverPadding(
              padding: const EdgeInsets.only(right: 12, left: 12, bottom: 12, top: 4),
              sliver: SliverList.separated(
                itemCount: value.books.length,
                itemBuilder: (context, index) {
                  Book book = value.books[index];
                  return GestureDetector(
                    onTap: () => _onItemPress(book),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          book.didRead
                              ? Banner(
                                  message: context.l10n.alreadyRead,
                                  location: BannerLocation.topStart,
                                  color: Colors.green,
                                  child: Image.network(
                                    book.image,
                                    height: 100,
                                    width: 70,
                                    fit: BoxFit.fill,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.error_outline);
                                    },
                                  ),
                                )
                              : Image.network(
                                  book.image,
                                  height: 100,
                                  width: 70,
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error_outline);
                                  },
                                ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        book.title,
                                        style: Theme.of(context).textTheme.titleLarge,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      book.genre.first.name,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  book.author.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Theme.of(context).hintColor),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  book.description,
                                  maxLines: 3,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 12,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
