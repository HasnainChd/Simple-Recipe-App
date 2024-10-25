import 'package:flutter/material.dart';
import 'package:recipe_app/support_widget.dart';

class RecipeDetails extends StatefulWidget {
  final String imagePath;
  final String recipeName;
  final String recipeDetails;

  const RecipeDetails({
    super.key,
    required this.imagePath,
    required this.recipeName,
    required this.recipeDetails,
  });

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Image.network(
              widget.imagePath,
              width: double.infinity,
              height: 400,
              fit: BoxFit.fill,
            ),
            Container(
              width: MediaQuery.sizeOf(context).width,
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              margin:
                  EdgeInsets.only(top: MediaQuery.sizeOf(context).width / 1.1),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                       widget.recipeName,
                      style: AppWidget.fullBold(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                     Text(widget.recipeDetails)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
