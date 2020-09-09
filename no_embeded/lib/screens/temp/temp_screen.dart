import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:no_embeded/provider/data_provider.dart';
import 'package:no_embeded/provider/socket_provider.dart';
import 'package:no_embeded/services/sizeconfig.dart';
import 'package:provider/provider.dart';

import 'body.dart';

class TempScreen extends StatefulWidget {
  @override
  _TempScreenState createState() => _TempScreenState();
}

class _TempScreenState extends State<TempScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<DataProvider>(context, listen: false).requestMax("temp");
      Provider.of<DataProvider>(context, listen: false).requestMin("temp");
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
