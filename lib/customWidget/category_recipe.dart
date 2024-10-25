import 'package:flutter/material.dart';
import '../support_widget.dart';

class RecipeCard extends StatefulWidget {
  final String imagePath;
  final String text;

  const RecipeCard({
    super.key,
    required this.imagePath,
    required this.text,
  });

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                widget.imagePath,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              )),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.text,
            style: AppWidget.lightStyle(),
          ),
        ],
      ),
    );
  }
}
