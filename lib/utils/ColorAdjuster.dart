import 'package:flutter/material.dart';

Color getAdjustedColor(Color originalColor) {
  // Calculate the luminance of the original color
  double luminance = originalColor.computeLuminance();

  // Define a factor to adjust the color darkness or lightness
  double adjustmentFactor = 0.9;

  // Choose the blending color based on luminance
  Color blendingColor = luminance > 0.5 ? Colors.black : Colors.white;

  // Calculate the adjusted color by blending with the chosen color
  Color adjustedColor = Color.lerp(originalColor, blendingColor, adjustmentFactor)!;

  return adjustedColor;
}

bool isDarkColor(Color color) {
  // Formula to determine brightness
  // 0.299 * Red + 0.587 * Green + 0.114 * Blue
  double brightness = color.red * 0.299 + color.green * 0.587 + color.blue * 0.114;
  return brightness < 128; // If brightness is less than 128, it's considered dark
}