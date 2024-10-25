import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:recipe_app/Services/database_service.dart';
import 'package:recipe_app/support_widget.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  final nameController = TextEditingController();
  final detailController = TextEditingController();

  String? value;
  File? selectedImage;

  final ImagePicker _picker = ImagePicker();

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

  uploadRecipe() async {
    setState(() {
      isLoading = true;
    });
    if (selectedImage != null &&
        nameController.text != '' &&
        detailController.text != '') {
      String id = randomAlphaNumeric(5);

      Reference firebaseStorageRef =
      FirebaseStorage.instance.ref().child('RecipeImages').child(id);
      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      var downloadUrl = await (await task).ref.getDownloadURL();

      Map<String, dynamic> addRecipe = {
        'Name': nameController.text,
        'Details': detailController.text,
        'Image': downloadUrl,
        'Category': value,
        'Key': nameController.text.substring(0, 1).toUpperCase(),
        'searchName': nameController.text.toUpperCase(),
      };
      await DatabaseService().addRecipe(addRecipe).then((vale) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.black,
            content: Text(
              'Recipe Added Successfully',
              style: TextStyle(color: Colors.white),
            )));
        selectedImage = null;
        nameController.text = '';
        detailController.text = '';
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  List<String> recipeNames = [
    'Soup Recipe',
    'Indian Recipe',
    'Chinese Recipe',
    'Italian Recipe',
    'Main Recipe'
  ];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 50),
        width: MediaQuery.sizeOf(context).width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(child: Text('Add Recipe', style: AppWidget.fullBold())),
              const SizedBox(height: 30),
              InkWell(
                  onTap: () {
                    getImage();
                  },
                  child: selectedImage != null
                      ? Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                      : InkWell(
                    onTap: () {
                      getImage();
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 30,
                      ),
                    ),
                  )),
              const SizedBox(height: 20),
              //Recipe Name Container
              Container(
                padding: const EdgeInsets.only(left: 10),
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: 'Recipe Name'),
                ),
              ),
              const SizedBox(height: 20),

              //category dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: recipeNames
                        .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: AppWidget.lightStyle(),
                      ),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        this.value = value;
                      });
                    },
                    dropdownColor: Colors.white,
                    hint: const Text('Select Category'),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    value: value,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: detailController,
                  minLines: 4,
                  maxLines: 8,
                  decoration: const InputDecoration(
                      hintText: 'Recipe Details', border: InputBorder.none),
                ),
              ),
              const SizedBox(height: 20),

              //Save button
              InkWell(
                onTap: () {
                  uploadRecipe();
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black)),
                  child: const Center(
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
