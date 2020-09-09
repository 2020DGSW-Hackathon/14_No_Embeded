import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:no_embeded/components/bottom_information.dart';
import 'package:no_embeded/components/pie_chart.dart';
import 'package:no_embeded/provider/data_provider.dart';
import 'package:no_embeded/provider/socket_provider.dart';
import 'package:no_embeded/services/constants.dart';
import 'package:no_embeded/services/sizeconfig.dart';
import 'package:provider/provider.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Provider.of<DataProvider>(context, listen: false).requestMax("hum");
          },
          mini: false,
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.refresh),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: getProportionateScreenHeight(80),
              ),
              child: Text(
                "현재 습도",
                style: GoogleFonts.notoSans(color: kTextColor, fontSize: 24),
              ),
            ),
            Consumer<SocketProvider>(
              builder: (ctx, item, _) {
                print("Update Request 2");
                if (item.connection == Connection.waiting) {
                  return Column(
                    children: [
                      Text("Request Main Data"),
                      CircularProgressIndicator(),
                    ],
                  );
                }
                return SizedBox(
                  width: getProportionateScreenWidth(260),
                  height: getProportionateScreenHeight(260),
                  child: Circle(
                    information: [
                      "\n너무 낮은 습도에요.\n가습기를 켜주세요.",
                      "\n딱 적당한 습도에요.\n이대로 유지해주세요.",
                      "\n습도가 너무 높아요.\n제습기를 켜주세요."
                    ],
                    informationStop: [0.6, 0.8, 1],
                    gradient: [Color(0xFFC9EEFF), Color(0xFF00B2FF)],
                    stops: [0, 1],
                    value: double.parse(item.hum),
                    maxValue: 100,
                    textStyle:
                        GoogleFonts.notoSans(color: Colors.black, fontSize: 70),
                    subTextStyle:
                        GoogleFonts.notoSans(color: Colors.grey, fontSize: 12),
                  ),
                );
              },
            ),
            SizedBox(
              height: getProportionateScreenHeight(30),
            ),
            Consumer<DataProvider>(builder: (ctx, item, _) {
              if (item.minStatus == Status.loading) {
                return Column(
                  children: [
                    Text("Request min Data"),
                    CircularProgressIndicator(),
                  ],
                );
              } else if (item.maxStatus == Status.loading) {
                return Column(
                  children: [
                    Text("Request max Data"),
                    CircularProgressIndicator(),
                  ],
                );
              } else if (item.minStatus == Status.complete &&
                  item.maxStatus == Status.complete) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: BottomInfo(
                        title: "가장 높았던 날",
                        value: item.max.data[0].hum.toInt(),
                        icon: "%",
                        date: DateFormat('yyyy년 MM월 dd일')
                            .format(item.max.data[0].uploaded),
                        time: DateFormat('hh시 mm분')
                            .format(item.max.data[0].uploaded),
                      ),
                    ),
                    Container(
                      height: getProportionateScreenHeight(178),
                      width: 1,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: BottomInfo(
                        title: "가장 낮았던 날",
                        value: item.min.data[0].hum.toInt(),
                        icon: "%",
                        date: DateFormat('yyyy년 MM월 dd일')
                            .format(item.min.data[0].uploaded),
                        time: DateFormat('hh시 mm분')
                            .format(item.min.data[0].uploaded),
                      ),
                    ),
                  ],
                );
              }
              return CircularProgressIndicator();
            }),
          ],
        ),
      ),
    );
  }
}
