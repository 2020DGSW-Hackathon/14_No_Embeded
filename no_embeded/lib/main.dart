import 'package:flutter/material.dart';
import 'package:no_embeded/provider/bottom_navigation_provider.dart';
import 'package:no_embeded/provider/data_provider.dart';
import 'package:no_embeded/provider/dropdown_provider.dart';
import 'package:no_embeded/provider/socket_provider.dart';
import 'package:no_embeded/screens/connect.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: BottomNavigationProvider()),
        ChangeNotifierProvider.value(value: DataProvider()),
        ChangeNotifierProvider.value(value: SocketProvider()),
        ChangeNotifierProvider.value(value: DropdownProvider()),
      ],
      builder: (ctx, wid) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData.light(),
          home: Consumer<SocketProvider>(
            builder: (ctx, item, _) => ConnectSocket(),
          ),
        );
      },
    );
  }
}
