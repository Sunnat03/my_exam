import 'dart:io';
import 'package:my_exam/models/post_model.dart';
import 'package:my_exam/services/auth_service.dart';
import 'package:my_exam/services/db_service.dart';
import 'package:my_exam/services/rtdb_service.dart';
import 'package:my_exam/services/stor_service.dart';
import 'package:my_exam/services/util_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/remote_service.dart';

class DetailPage extends StatefulWidget {
  static const id = "/detail_page";
  final DetailState state;
  final Post? post;

  const DetailPage({this.state = DetailState.create, this.post, Key? key})
      : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  bool isLoading = false;
  Post? updatePost;

  // for image
  final ImagePicker _picker = ImagePicker();
  File? file;

  @override
  void initState() {
    super.initState();
    _detectState();
  }

  void _detectState() {
    if (widget.state == DetailState.update && widget.post != null) {
      updatePost = widget.post;
      nameController.text = updatePost!.name;
      numberController.text = updatePost!.number;
      priceController.text = updatePost!.price;
      descriptionController.text = updatePost!.description;
      addressController.text = updatePost!.address;
      dateController.text = updatePost!.date;
      setState(() {});
    }
  }

  void _getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        file = File(image.path);
      });
    } else {
      if (mounted) Utils.fireSnackBar("Please select image for post", context);
    }
  }

  void _addPost() async {
    String name = nameController.text.trim();
    String price = priceController.text.trim();
    String description = descriptionController.text.trim();
    String address = addressController.text.trim();
    String number = numberController.text.trim();
    String date = dateController.text.trim();
    String? imageUrl;

    if (name.isEmpty ||
        price.isEmpty ||
        description.isEmpty ||
        number.isEmpty ||
        address.isEmpty ||
        date.isEmpty) {
      Utils.fireSnackBar("Please fill all fields", context);
      return;
    }
    isLoading = true;
    setState(() {});

    String? userId = await DBService.loadUserId();

    if (userId == null) {
      if (mounted) {
        Navigator.pop(context);
        AuthService.signOutUser(context);
      }
      return;
    }

    if (file != null) {
      imageUrl = await StorageService.uploadImage(file!);
    }

    Post post = Post(
        postKey: "",
        userId: userId,
        name: name,
        price: price,
        number: number,
        date: date,
        description: description,
        address: address,
        image: imageUrl);

    await RTDBService.storePost(post).then((value) {
      Navigator.of(context).pop();
    });

    isLoading = false;
    setState(() {});
  }

  void _updatePost() async {
    String name = nameController.text.trim();
    String price = priceController.text.trim();
    String description = descriptionController.text.trim();
    String address = addressController.text.trim();
    String number = numberController.text.trim();
    String date = dateController.text.trim();
    String? imageUrl;

    if (name.isEmpty ||
        price.isEmpty ||
        description.isEmpty ||
        address.isEmpty ||
        number.isEmpty ||
        date.isEmpty) {
      Utils.fireSnackBar("Please fill all fields", context);
      return;
    }
    isLoading = true;
    setState(() {});

    if (file != null) {
      imageUrl = await StorageService.uploadImage(file!);
    }

    Post post = Post(
        postKey: updatePost!.postKey,
        userId: updatePost!.userId,
        name: name,
        price: price,
        date: date,
        number: number,
        description: description,
        address: address,
        image: imageUrl ?? updatePost!.image);

    await RTDBService.updatePost(post).then((value) {
      Navigator.of(context).pop();
    });

    isLoading = false;
    setState(() {});
  }

  void _selectDate() async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2122),
    ).then((date) {
      if (date != null) {
        dateController.text = date.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 246, 246, 1),
      appBar: AppBar(
        backgroundColor: RemoteService.availableBackgroundColors[RemoteService.backgroundColor],
        title: widget.state == DetailState.update
            ? const Text("Update Post")
            : const Text("Add Post"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // #image
                  GestureDetector(
                    onTap: _getImage,
                    child: SizedBox(
                      height: 125,
                      width: 125,
                      child: (updatePost != null &&
                              updatePost!.image != null &&
                              file == null)
                          ? Image.network(updatePost!.image!)
                          : (file == null
                              ? const Image(
                                  image: AssetImage("assets/images/logo.png"),
                                )
                              : Image.file(file!)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // #firstname
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: "Name",
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // #lastname
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      hintText: "Price",
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // #content
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      hintText: "Description",
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      hintText: "Address",
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: numberController,
                    decoration: const InputDecoration(
                      hintText: "Number",
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // #date
                  TextField(
                    controller: dateController,
                    readOnly: true,
                    onTap: _selectDate,
                    decoration: const InputDecoration(
                      hintText: "Date",
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // #add_update
                  ElevatedButton(
                    onPressed: () {
                      if (widget.state == DetailState.update) {
                        _updatePost();
                      } else {
                        _addPost();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50)),
                    child: Text(
                      widget.state == DetailState.update ? "Update" : "Add",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: isLoading,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }
}

enum DetailState {
  create,
  update,
}
