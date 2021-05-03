import 'package:flutter/material.dart';
import 'package:flutter_location/presentation/views/home_page.dart';
import 'package:flutter_location/presentation/views/location_page.dart';
import 'package:flutter_location/presentation/views/google_maps_page.dart';

class DrawerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          _createHeader(),
          _createDrawerItem(
            icon: Icons.contacts,
            text: 'Location',
            onTap: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyHomePage())),
          ),
          _createDrawerItem(
            icon: Icons.event,
            text: 'Location Flutter Bloc',
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LocationPage()),
            ),
          ),
          _createDrawerItem(
            icon: Icons.map,
            text: 'Google Map',
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => GoogleMapsPage()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.lightBlue,
        // image: DecorationImage(
        //   fit: BoxFit.fill,
        //   image: AssetImage('path/to/header_background.png'),
        // ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 12.0,
            left: 16.0,
            child: Text(
              "Flutter Step-by-Step",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem(
      {required IconData icon, required String text, required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
