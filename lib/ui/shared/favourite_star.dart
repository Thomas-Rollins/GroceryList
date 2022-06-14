import 'package:flutter/material.dart';

class FavouriteStar extends StatelessWidget {
  const FavouriteStar({Key? key, required this.isFavourite, this.size = 30}) : super(key: key);

  final bool isFavourite;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(
        isFavourite ? Icons.star : Icons.star_border,
        color: Colors.amber,
        size: size,
      ),
    );
  }
}
