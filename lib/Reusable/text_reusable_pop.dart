import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextResPopp extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final Color color; // 👈 add color parameter

  TextResPopp(
    this.fontWeight,
    this.text,
    this.fontSize, {
    this.textAlign, //  default start
    this.color = Colors.black, //  default black

    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign, //  use here
      style: GoogleFonts.poppins(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
