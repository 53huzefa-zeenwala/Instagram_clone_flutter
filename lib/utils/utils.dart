import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

pickImage(ImageSource? source) async {
  final _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source ?? ImageSource.gallery);

  if (_file != null) {
    return _file.readAsBytes();
  }
  print('No image selected');
}

void showSnackbar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

class TimeFormatter {
  static getPostTime(DateTime data) {
    var currentDateTime = DateTime.now();
    var timeDif = currentDateTime.difference(data);
    final monthFormat = DateFormat("dd MMMM");
    final mainFormat = DateFormat("dd MMMM yyyy");
    return timeDif.inSeconds < 60
        ? timeDif.inSeconds.toString() + " second ago"
        : timeDif.inMinutes < 60
        ? timeDif.inMinutes.toString() + " minute ago"
        : timeDif.inHours < 24
        ? timeDif.inHours.toString() + " hour ago"
        : timeDif.inDays < 7
        ? timeDif.inHours.toString() + " hour ago"
        : data.year != currentDateTime.year
        ? mainFormat.format(data)
        : monthFormat.format(data);
  }
}