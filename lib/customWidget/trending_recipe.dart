import 'package:flutter/material.dart';
import 'package:recipe_app/support_widget.dart';

class TrendingRecipe extends StatefulWidget {
  final String imagePath;
  final String recipeName;

  const TrendingRecipe(
      {super.key, required this.imagePath, required this.recipeName});

  @override
  State<TrendingRecipe> createState() => _TrendingRecipeState();
}

class _TrendingRecipeState extends State<TrendingRecipe> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              widget.imagePath,
              height: 250,
              width: 250,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(height: 10,),
          Text(widget.recipeName,style: AppWidget.boldStyle(),)
        ],
      ),
    );
  }
}
