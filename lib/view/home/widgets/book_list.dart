import 'package:easy_book/models/book/book.dart';
import 'package:flutter/material.dart';

class BookList extends StatelessWidget {
  const BookList({
    super.key,
    required ValueChanged<Book> onItemTap,
    required List<Book> bookList,
    required ScrollController scrollController,
    ValueChanged<Book>? onLikeTap,
  })  : _scrollController = scrollController,
        _onItemTap = onItemTap,
        _bookList = bookList,
        _onLikeTap = onLikeTap;

  final ValueChanged<Book> _onItemTap;
  final ScrollController _scrollController;
  final List<Book> _bookList;
  final ValueChanged<Book>? _onLikeTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 12,
        );
      },
      controller: _scrollController,
      itemBuilder: (context, index) {
        Book book = _bookList[index];
        return GestureDetector(
          onTap: () => _onItemTap(_bookList[index]),
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
                Image.network(
                  book.image,
                  height: 100,
                  width: 70,
                  fit: BoxFit.cover,
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
                          Text(
                            book.genre.first.name,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        book.author.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor),
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
      itemCount: _bookList.length,
    );
  }
}
