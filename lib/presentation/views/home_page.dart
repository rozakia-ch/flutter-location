import 'package:flutter/material.dart';
import 'package:flutter_location/presentation/methods/app_method.dart';
import 'package:flutter_location/presentation/widgets/drawer_app.dart';
import 'package:location/location.dart';

import '../widgets/enable_in_background.dart';
import '../widgets/change_notification.dart';
import '../widgets/get_location.dart';
import '../widgets/listen_location.dart';
import '../widgets/permission_status.dart';
import '../widgets/service_enabled.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Location location = Location();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerApp(),
      appBar: AppBar(
        title: Text("Location"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => AppMethod().showInfoDialog(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: const <Widget>[
              PermissionStatusWidget(),
              Divider(height: 32),
              ServiceEnabledWidget(),
              Divider(height: 32),
              GetLocationWidget(),
              Divider(height: 32),
              ListenLocationWidget(),
              Divider(height: 32),
              EnableInBackgroundWidget(),
              Divider(height: 32),
              ChangeNotificationWidget()
            ],
          ),
        ),
      ),
    );
  }
}
