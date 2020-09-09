import 'package:flutter/material.dart';
import 'package:no_embeded/provider/data_provider.dart';
import 'package:no_embeded/provider/socket_provider.dart';
import 'package:no_embeded/screens/humidity/body.dart';
import 'package:no_embeded/services/sizeconfig.dart';
import 'package:provider/provider.dart';

class HumidityScreen extends StatefulWidget {
  @override
  _HumidityScreenState createState() => _HumidityScreenState();
}

class _HumidityScreenState extends State<HumidityScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<DataProvider>(context, listen: false).requestMax("hum");
      Provider.of<DataProvider>(context, listen: false).requestMin("hum");
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
