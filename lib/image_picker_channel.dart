import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ImageSource { photos, camera }

String _stringImageSource(ImageSource imageSource) {
  switch (imageSource) {
    case ImageSource.photos:
      return 'photos';
    case ImageSource.camera:
      return 'camera';
  }
  return null;
}

abstract class ImagePicker {
  void pickImage({ImageSource imageSource, Function(String) onResult});
}

class ImagePickerChannel implements ImagePicker {
  static const platform = const MethodChannel('samples.flutter.dev/image_picker');

  @override
  void pickImage({ImageSource imageSource, Function(String p1) onResult}) async {
    final stringImageSource = _stringImageSource(imageSource);
    final result = await platform.invokeMethod('pickImage', stringImageSource) as String;
    if (result is String) {
      onResult(result);
    } else if (result is FlutterError) {
      throw result;
    }
    return null;
  }
}
