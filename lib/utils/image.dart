import 'package:file_picker/file_picker.dart';

Future<PlatformFile?> loadImageFromGallery() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.image,
  );

  PlatformFile? file = result != null ? result.files.first : null;

  return file;
}
