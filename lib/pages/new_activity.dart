import 'dart:math';
import 'package:fitonyashki_projeckt/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:fitonyashki_projeckt/maps_sheet.dart';
import 'package:geolocator/geolocator.dart';

class CurrentActivity extends StatefulWidget {
  const CurrentActivity({Key? key}) : super(key: key);

  @override
  State<CurrentActivity> createState() => _CurrentActivityState();
}

class _CurrentActivityState extends State<CurrentActivity> {
  late var currentActivity;
  double? destinationLatitude = null;
  double? destinationLongitude = null;
  double? originLatitude = null;
  double? originLongitude = null;
  int counter = 0;
  late LocationPermission permission;
  DirectionsMode directionsMode = DirectionsMode.walking;
  @override
  Widget build(BuildContext context) {
    RouteSettings settings = ModalRoute.of(context)!.settings;
    currentActivity = settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current activity',
          style: TextStyle( fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF87A2D6),
        actions: [IconButton(
          icon:
          Icon(Icons.help),
          onPressed: (){
            Navigator.pushNamed(context, '/Help');
          },
        ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Container(
                   //width: 70,
                   //height: 40,
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Center(
                       child: Text('You will burn: ${currentActivity.kcals} kcals',
                         style: const TextStyle(color: Color(0xFF616B83), fontSize: 18, fontWeight: FontWeight.bold),
                         textAlign: TextAlign.center,
                       ),
                     ),
                   ),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(40),
                     color: const Color(0xFFC6D0EB),
                   )
                 ),
                SizedBox(height: 15),
                Container(
                   //width: 70,
                   //height: 40,
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Center(
                       child: Text('You need to cover the distance ${currentActivity.distance} km',
                         style: const TextStyle(color: Color(0xFF616B83), fontSize: 18, fontWeight: FontWeight.bold),
                         textAlign: TextAlign.center,
                       ),
                     ),
                   ),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(40),
                     color: const Color(0xFFC6D0EB),
                   )
                 ),
                SizedBox(height: 20),
                ElevatedButton(onPressed: (){
                  newRoute();
                },
                  child: const Text(
                    'New route',
                    style: TextStyle(color: Color(0xFF616B83), fontSize: 18, fontWeight: FontWeight.bold),
                    //fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFFC6D0EB),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: (){
                      Navigator.pop(context, 'canceled');
                    },
                      child: const Text(' Cancel ',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(primary: Color(0xFF616B83),),
                    ),
                    const SizedBox(width: 50,),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context, 'completed');
                      },
                      child: const Text('Complete',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                        style: ElevatedButton.styleFrom(primary: const Color(0xFF87A2D6),)
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void newRoute() async{
    await getCurrentLocation();
    calcCoords(currentActivity.distance/2);
    MapsSheet.show(
      context: context,
      onMapTap: (map) {
        map.showDirections(
          destination: Coords(
              originLatitude!,
              originLongitude!
          ),
          origin: Coords(
              originLatitude!,
              originLongitude!
          ),
          waypoints: <Coords>[
              Coords(
              destinationLatitude!,
              destinationLongitude!,
            ),
          ],
          directionsMode: directionsMode,
        );
        Navigator.pop(context);
      },
    );

  }

  Future<void> getCurrentLocation()async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return ;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return ;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return ;
    }
    await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        //.timeout(const Duration(seconds: 1))
        .then((Position position) {
      setState(() {
        originLatitude= position.latitude;
        originLongitude = position.longitude;
      });

    }).catchError((e) {
      print(e);
    });

  }

  double PI = 3.141592653589793238;

  double degreeToRadian(double degree) {
    return degree * PI / 180;
  }

  double radianToDegree(double radian) {
    return radian * 180 / PI;
  }

  void calcCoords(double dist){
    dist *= 0.8;
    var earthRadius = 6378137.0;
    var startLat = degreeToRadian(originLatitude!);
    var startLong = degreeToRadian(originLongitude!);
    if(counter == 0){
      var endLat = startLat;
      double endLong = startLong + acos((cos(dist*1000/earthRadius)-sin(endLat)*sin(startLat))/(cos(startLat)*cos(endLat)));
      setState(() {
        destinationLongitude = radianToDegree(endLong);
        destinationLatitude = originLatitude;

      });

    }

    if(counter == 1){
      var endLat = startLat;
      double endLong = startLong - acos((cos(dist*1000/earthRadius)-sin(endLat)*sin(startLat))/(cos(startLat)*cos(endLat)));
      setState(() {
        destinationLongitude = radianToDegree(endLong);
        destinationLatitude = originLatitude;

      });

    }

    if(counter == 2) {
      double endLong = startLong;
      double endLat = 2 * atan((tan(startLat) + sqrt(pow(tan(startLat), 2) -
          pow((cos(dist * 1000 / earthRadius) / cos(startLat)), 2) +
          pow(cos(startLong - endLong), 2))) /
          ((cos(dist * 1000 / earthRadius) / cos(startLat)) +
              cos(startLong - endLong)));
      setState(() {
        destinationLongitude = originLongitude;
        destinationLatitude = radianToDegree(endLat);

      });

    }

    if(counter == 3) {
      double endLong = startLong;
      double endLat = 2 * atan((tan(startLat) - sqrt(pow(tan(startLat), 2) -
          pow((cos(dist * 1000 / earthRadius) / cos(startLat)), 2) +
          pow(cos(startLong - endLong), 2))) /
          ((cos(dist * 1000 / earthRadius) / cos(startLat)) +
              cos(startLong - endLong)));
      setState(() {
        destinationLongitude = originLongitude;
        destinationLatitude = radianToDegree(endLat);

      });

    }

    counter++;
    if(counter>3)counter = 0;
    return ;
  }
}

