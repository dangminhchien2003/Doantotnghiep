import 'package:booking_petcare/Services/TranslationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Language extends StatefulWidget {
  const Language({super.key});

  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  String selectedLanguage = ''; // Lưu trữ ngôn ngữ đã chọn

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('language'.tr, style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          children: [
            _item(
                languageCode: 'vi_VN',
                svg: 'assets/icons/flagviet.svg',
                title: 'Tiếng Việt'),
            _item(
                languageCode: 'en_US',
                svg: 'assets/icons/flagus.svg',
                title: 'English')
          ],
        ),
      ),
    );
  }

  _item(
      {required String svg,
      required String title,
      required String languageCode}) {
    return GestureDetector(
      onTap: () {
        if (languageCode == 'vi_VN') {
          TranslationService.changeLocale('vi');
        } else {
          TranslationService.changeLocale('en');
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1, color: Color.fromRGBO(228, 230, 236, 1)))),
        child: Row(
          children: [
            SvgPicture.asset(svg),
            SizedBox(
              width: 16,
            ),
            Expanded(
                child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
            )),
            SizedBox(
              width: 10,
            ),
            Get.locale.toString() == languageCode
                ? Icon(
                    Icons.done_rounded,
                    size: 22,
                    color: Color.fromRGBO(17, 185, 145, 1),
                  )
                : SizedBox(
                    height: 22,
                  )
          ],
        ),
      ),
    );
  }
}
