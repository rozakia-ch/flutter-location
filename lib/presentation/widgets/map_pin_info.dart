import 'package:flutter/material.dart';
import 'package:flutter_location/logic/models/pin_information.dart';

class MapPinInfo extends StatefulWidget {
  MapPinInfo({Key? key, this.selectedPin}) : super(key: key);
  final PinInformation? selectedPin;
  @override
  _MapPinInfoState createState() => _MapPinInfoState();
}

class _MapPinInfoState extends State<MapPinInfo> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      bottom: 0,
      right: 0,
      left: 0,
      duration: Duration(milliseconds: 200),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.all(10),
          height: 100,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              boxShadow: <BoxShadow>[
                BoxShadow(blurRadius: 20, offset: Offset.zero, color: Colors.grey.withOpacity(0.5))
              ]),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Container(
                //   width: 50,
                //   height: 50,
                //   margin: EdgeInsets.only(left: 10),
                //   child: ClipOval(
                //       child: Image.asset(widget.currentlySelectedPin.avatarPath, fit: BoxFit.cover)),
                // ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.selectedPin!.locationName!,
                          style: TextStyle(color: widget.selectedPin!.labelColor),
                        ),
                        Text(
                          widget.selectedPin!.locationAddress!,
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        Text(
                          'Latitude: ${widget.selectedPin!.location!.latitude.toString()}',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        Text(
                          'Longitude: ${widget.selectedPin!.location!.longitude.toString()}',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Icon(Icons.place),
                  // child: Image.asset(widget.selectedPin!.pinPath!, width: 50, height: 50),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
