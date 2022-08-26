import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../services/profile_page_utill.dart';
import '../services/remote_service.dart';
import 'detail_page.dart';


class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  static const String id = '/profile_page';
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final TextEditingController textController = TextEditingController();
  String name = "sunnat";
  String email = "@sunnatmakhmayusupov03";

  var imagePicker;

  List defaultImage = [

  ];

  Future <void> refresh() async {
    setState(() {
      defaultImage = [
      ];
    });
  }
  void _openDetailPage() {

    Navigator.pushNamed(context, DetailPage.id);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppBar(
                  backgroundColor: RemoteService.availableBackgroundColors[RemoteService.backgroundColor],
                  elevation: 0,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.black,),
                      onPressed: (){},
                    ),
                    IconButton(
                      icon: const Icon(FontAwesomeIcons.ellipsisH, color: Colors.black, size: 18,),
                      onPressed: (){},
                    ),
                  ],
                ),
                // profile image
                GestureDetector(
                  onTap: () async {
                    var source = ImageSource.gallery;
                    XFile image = await imagePicker.pickImage(
                        source: source, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
                    setState(() {
                      UpdateProfileImage.setImage(File(image.path));
                    });
                  },

                  child: SizedBox(
                      width: 200,
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child:  UpdateProfileImage.getImage() != null
                            ? Image.file(
                          UpdateProfileImage.getImage(),
                          fit: BoxFit.cover,
                        )
                            : const Image(
                          image: AssetImage('assets/images/profile_image.png'),
                          fit: BoxFit.cover,
                        ),
                      )
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Center(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 35, color: Colors.black),)),
                const SizedBox(
                  height: 12,
                ),
                Center(child: Text(email, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: Colors.black),)),
                const SizedBox(
                  height: 12,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 1,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // text field
                SizedBox(
                  height: 38,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextField(
                            controller: textController,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {},
                            onSubmitted: (search){},
                            onTap: (){},
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.search_sharp,
                                color: Colors.black54,
                              ),

                              filled: true,
                              fillColor: Colors.grey.shade200,
                              hintText: 'Search your Pins',
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(45.0)),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(45.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(45.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 28, color: Colors.black,),
                        onPressed: _openDetailPage,
                      ),
                      const SizedBox(width: 20)
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: MasonryGridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(0),
                        itemCount: defaultImage.length,
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        itemBuilder: (context, index){
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: CachedNetworkImage(
                                  imageUrl: defaultImage[index],
                                  placeholder: (context, url) =>
                                  const Image(image: AssetImage('assets/images/img.png')),
                                  errorWidget: (context, url, error) =>
                                  const Image(image: AssetImage('assets/images/img_1.png')),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width/2,
                                height: 20,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: (){},
                                      child: const Icon(FontAwesomeIcons.ellipsisH, color: Colors.black, size: 17,),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}