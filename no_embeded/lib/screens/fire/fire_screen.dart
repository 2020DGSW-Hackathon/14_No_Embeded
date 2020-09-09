import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:no_embeded/provider/data_provider.dart';
import 'package:no_embeded/provider/socket_provider.dart';
import 'package:no_embeded/services/sizeconfig.dart';
import 'package:provider/provider.dart';

import 'body.dart';

class FireScreen extends StatefulWidget {
  @override
  _FireScreenState createState() => _FireScreenState();
}

class _FireScreenState extends State<FireScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<DataProvider>(context, listen: false).requestMax("gas");
      Provider.of<DataProvider>(context, listen: false).requestMin("gas");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Consumer<SocketProvider>(
      builder: (ctx, item, _) {
        print("Update request");
        if (item.connection == Connection.connected) return Body();
        return CircularProgressIndicator();
      },
    );
  }
}
