import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class DialogCustom extends StatelessWidget {
  DialogCustom(
      {Key? key,
      required this.title,
      required this.description,
      required this.svg,
      this.svgColor,
      this.btnColor,
      required this.onTap})
      : super(key: key);

  String title;
  String description;
  String svg;
  Color? svgColor;
  Color? btnColor;
  GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      child: Container(
        margin: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svg,
              colorFilter: svgColor == null
                  ? null
                  : ColorFilter.mode(
                      svgColor!,
                      BlendMode.srcIn,
                    ),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 7,
            ),
            Text(
              description,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 17, vertical: 9),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(241, 244, 249, 1),
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      'Hủy'.tr,
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 17, vertical: 9),
                    decoration: BoxDecoration(
                        color: btnColor ?? Color.fromRGBO(55, 114, 255, 1),
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      'Xác nhận'.tr,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
