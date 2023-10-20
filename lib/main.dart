import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ImagePicker picker = ImagePicker();
  File? imageFile;
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload file"),
      ),
      body: Center(
        child: MaterialButton(
          onPressed: () async {
            PermissionStatus status = await Permission.camera.status;
            if (status.isGranted) {
              var filePath = await picker.pickImage(source: ImageSource.camera);
              if (filePath != null) {
                imageFile = File(filePath.path);
                var ref = storage.ref("image/${imageFile?.path.split("/").last}");
                ref.putFile(imageFile!);
              }
            }
            else{
              await Permission.camera.request();
            }
          },
          child: Text("Upload"),
          color: Colors.orange,
        ),
      ),
    );
  }
}
