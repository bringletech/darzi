import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextResuableRob extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final Color color; // 👈 add color parameter

  const TextResuableRob(
    this.fontWeight,
    this.text,
    this.fontSize, {
    this.textAlign,
    this.color = Colors.black, // 👈 default black
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.roboto(
        color: color, // 👈 use color dynamically
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
