import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primary = Color(0xFF3285F3);
const white = Colors.white;
const yellow = Colors.yellow;

TextStyle style({double? fs, FontWeight? fw, Color? color}) {
  return GoogleFonts.poppins(fontSize: fs, fontWeight: fw, color: color);
}
