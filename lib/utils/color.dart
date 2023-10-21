import 'dart:math';
import 'dart:ui';

class ColorExtension {
  static Color randomRedColor() {
    final random = Random();

    final red = random.nextInt(256);
    final green = random.nextInt(256);
    final blue = random.nextInt(256);

    final maxGreenBlue = max(green, blue);
    final newGreen = max(0, green - maxGreenBlue);
    final newBlue = max(0, blue - maxGreenBlue);

    return Color.fromARGB(255, red, newGreen, newBlue);
  }

  static Color randomBlueColor() {
    final random = Random();

    final red = random.nextInt(256);
    final green = random.nextInt(256);
    final blue = random.nextInt(256);

    final maxRedGreen = max(red, green);
    final newRed = max(0, red - maxRedGreen);
    final newGreen = max(0, green - maxRedGreen);

    return Color.fromARGB(255, newRed, newGreen, blue);
  }
}
