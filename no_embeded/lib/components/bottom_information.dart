import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:no_embeded/services/sizeconfig.dart';

class BottomInfo extends StatelessWidget {
  const BottomInfo({
    Key key,
    this.title,
    this.value,
    this.icon,
    this.date,
    this.time,
  }) : super(key: key);
  final String title;
  final int value;
  final String icon;
  final String date;
  final String time;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.notoSans(color: Colors.grey, fontSize: 18),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: getProportionateScreenHeight(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$value",
                style: GoogleFonts.notoSans(color: Colors.grey, fontSize: 36),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: getProportionateScreenHeight(4),
                ),
                child: Text(
                  icon,
                  style: GoogleFonts.notoSans(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(
          date,
          style: GoogleFonts.notoSans(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        Text(
          time,
          style: GoogleFonts.notoSans(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
