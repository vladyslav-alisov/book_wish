import 'dart:io';

import 'package:easy_book/models/book/book.dart';
import 'package:easy_book/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.book});

  final Book book;

  void _onReadPress(BuildContext context, bool value) {
    context.read<BookProvider>().changeDidReadStatus(book.dbId);
  }

  void _onLikePress(BuildContext context, bool value) {
    context.read<BookProvider>().changeFavoriteStatus(book.dbId);
  }

  static const double kImageHeight = 460;
  static const double kBottomHeight = 25;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          persistentFooterButtons: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                FavoriteButton(
                  initState: book.isFavourite,
                  onLikePress: (bool value) => _onLikePress(context, value),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: ToReadSwitch(
                    initValue: book.didRead,
                    onSwitchPress: (bool value) => _onReadPress(context, value),
                  ),
                ),
              ],
            ),
          ],
          body: ListView(
            children: [
              SizedBox(
                height: kImageHeight,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Image.network(
                          book.image,
                          height: kImageHeight - kBottomHeight,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          opacity: const AlwaysStoppedAnimation(.05),
                        ),
                        const SizedBox(
                          height: kBottomHeight,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          book.title,
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          book.author.name,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 20),
                        Image.network(
                          book.image,
                          height: 240,
                          width: 150,
                        ),
                        const SizedBox(
                          height: kBottomHeight * 2,
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: kBottomHeight * 2,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RatingBarIndicator(
                              rating: book.rating,
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                            ),
                            Text("(${book.rating})"),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8),
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Genre",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: List.generate(
                        book.genre.length,
                        (index) {
                          return Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.all(Radius.circular(12)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: const Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Text(book.genre[index].name),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Overview",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      book.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Publication date: ${book.publicationDate}",
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ToReadSwitch extends StatefulWidget {
  const ToReadSwitch({
    super.key,
    required this.initValue,
    required this.onSwitchPress,
  });

  final bool initValue;
  final ValueChanged<bool> onSwitchPress;
  @override
  State<ToReadSwitch> createState() => _ToReadSwitchState();
}

class _ToReadSwitchState extends State<ToReadSwitch> {
  late bool _didRead;

  @override
  void initState() {
    super.initState();
    _didRead = widget.initValue;
  }

  void _onPress() {
    widget.onSwitchPress(!_didRead);
    setState(() => _didRead = !_didRead);
  }

  @override
  Widget build(BuildContext context) {
    return _didRead
        ? OutlinedButton.icon(
            onPressed: _onPress,
            icon: const Icon(Icons.check),
            label: const Text("Already read"),
          )
        : OutlinedButton(
            onPressed: _onPress,
            style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primary)),
            child: Text(
              "Want to read",
              style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
            ),
          );
  }
}

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key, required this.initState, required this.onLikePress});

  final bool initState;
  final ValueChanged<bool> onLikePress;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.initState;
  }

  void _onLikePress() {
    widget.onLikePress(!_isFavorite);
    setState(() => _isFavorite = !_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _onLikePress(),
      child: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        color: _isFavorite ? Colors.red : null,
      ),
    );
  }
}
