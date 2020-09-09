import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:no_embeded/provider/bottom_navigation_provider.dart';
import 'package:no_embeded/provider/socket_provider.dart';
import 'package:no_embeded/screens/temp/temp_screen.dart';
import 'package:no_embeded/services/sizeconfig.dart';
import 'package:provider/provider.dart';

import 'analytics/analytics_screen.dart';
import 'fire/fire_screen.dart';
import 'humidity/humidity_screen.dart';

class ConnectSocket extends StatefulWidget {
  @override
  _ConnectSocketState createState() => _ConnectSocketState();
}

class _ConnectSocketState extends State<ConnectSocket> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<SocketProvider>(context, listen: false).connect();
    });
    super.initState();
  }

  final bottomItems = ["습도", "가스", "온도", "통계"];
  final bottomAssets = [
    "water.svg",
    "fire.svg",
    "temperature.svg",
    "graphic.svg"
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: Consumer<SocketProvider>(
        builder: (ctx, item, _) {
          if (item.connection == Connection.connected)
            return Consumer<BottomNavigationProvider>(
              builder: (ctx, item, _) {
                return Scaffold(
                  body: [
                    HumidityScreen(),
                    FireScreen(),
                    TempScreen(),
                    AnalyticsScreen(),
                  ][item.currentIndex],
                  bottomNavigationBar: Consumer<BottomNavigationProvider>(
                    builder: (ctx, item, _) {
                      SizeConfig().init(ctx);
                      return BottomNavigationBar(
                        onTap: (idx) => item.currentIndex = idx,
                        unselectedIconTheme:
                            IconThemeData(color: Color(0xFFAAAAAA)),
                        selectedIconTheme: IconThemeData(color: Colors.red),
                        currentIndex: item.currentIndex,
                        items: List.generate(
                          bottomItems.length,
                          (index) => BottomNavigationBarItem(
                            icon: SvgPicture.asset(
                              "assets/icons/${bottomAssets[index]}",
                              width: getProportionateScreenHeight(40),
                              color: item.currentIndex == index
                                  ? Colors.black
                                  : Color(0xFFAAAAAA),
                            ),
                            title: Text(
                              bottomItems[index],
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
