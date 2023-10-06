import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food/component/app_button.dart';
import 'package:food/component/text_field.dart';
import 'package:food/firebase/firebase_auth/firebase_auth_helpher.dart';
import 'package:food/models/userModel/user_model.dart';
import 'package:food/utils/colors/my_color.dart';
import 'package:food/utils/validation_utils/my_utilities.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../firebase/firebase_auth/firebase_storage.dart';
import '../../provider/my_provider.dart';
import '../../utils/constants/constants.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  Uint8List? image;
  void takeMyPicture() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    setState(() {
      image = img;
    });
  }

  Future<Uint8List?> pickImage(ImageSource source) async {
    XFile? _image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_image != null) {
      return _image.readAsBytes();
    }
  }
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  FirebaseStorageHelper _firebaseStorageHelper = FirebaseStorageHelper();
  FirebaseAuthHelper _firebaseAuthHelper = FirebaseAuthHelper();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<MyProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        title: Text(
          "Edit Screen",
          style: textStyle,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    image == null
                        ? Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: MyColor.primaryColor, width: 2),
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.white,
                            ),
                          )
                        : CircleAvatar(
                            radius: 70,
                            backgroundImage: MemoryImage(image!),
                          ),
                    Positioned(
                      bottom: -7,
                      right: -8,
                      child: IconButton(
                          onPressed: () {
                            takeMyPicture();
                          },
                          icon: Icon(
                            Icons.camera_alt,
                            color: MyColor.primaryColor,
                            size: 30,
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                TextFormFieldComponent(
                  controller: _nameController,
                  onFieldSubmittedValue: (value) {},
                  onValidator: (value) {
                    return null;
                  },
                  prefixIcon: Icons.person,
                  keyBoardType: TextInputType.name,
                  hint: myProvider.userModel!.name,
                  obsecureText: false,
                ),
                SizedBox(height: 30,),
                TextFormFieldComponent(
                  controller: _phoneController,
                  onFieldSubmittedValue: (value) {},
                  onValidator: (value) {
                    return null;
                  },
                  prefixIcon: Icons.phone,
                  keyBoardType: TextInputType.phone,
                  hint: myProvider.userModel!.phoneNumber,
                  obsecureText: false,
                ),
                SizedBox(
                  height: 30,
                ),
                AppButton(
                    text: "update",
                    onPress: () async {
                      showDialogBox(context);
                      String documentId =
                          FirebaseAuth.instance.currentUser!.uid;
                      String? imageUrl = image == null
                          ? myProvider.userModel!.image
                          : await _firebaseStorageHelper.uploadImage(image!);
                      await _firebaseAuthHelper.updateUserDataInFirestore(
                          documentId,
                          imageUrl!,
                          _nameController.text,
                          _phoneController.text,
                          context);
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
