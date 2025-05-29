import 'package:booking_petcare/Global/ColorHex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({
    Key? key,
    required this.title,
    required this.imgSrc,
    required this.content,
  }) : super(key: key);

  final String title, imgSrc, content;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          imgSrc,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          title,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: ColorHex.textContent),
        ),
      ],
    );
  }
}
