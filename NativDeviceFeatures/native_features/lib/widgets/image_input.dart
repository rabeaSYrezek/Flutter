import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  const ImageInput({Key? key, required this.onSelectImage}) : super(key: key);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    // ignore: deprecated_member_use
    final imageFile = await picker.getImage(
      source: ImageSource.camera, maxWidth: 600,);

    if (imageFile == null) {
      return;
    }

    setState(() {
      _storedImage = File(imageFile.path);
    });

    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await _storedImage!.copy('${appDir.path}/$fileName');
    print('filePath: $savedImage');
    print('app Dir: ${appDir.path}');

    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 200,
          height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage ?? File(''),
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : const Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextButton.icon(
            icon: const Icon(Icons.camera),
            label: const Text('Take a picture'),
            onPressed: _takePicture,
          ),
        ),
      ],
    );
  }
}
