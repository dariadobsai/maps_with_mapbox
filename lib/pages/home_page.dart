import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:user_location/user_location.dart';

const urlStart = "https://api.mapbox.com/styles/v1/dariniko/";
const urlEnd = "/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MapController mapController = MapController();
  UserLocationOptions userLocationOptions;
  List<Marker> markers = [];

  bool isPresentTime = true;

  @override
  Widget build(BuildContext context) {
    userLocationOptions = UserLocationOptions(
      context: context,
      mapController: mapController,
      zoomToCurrentLocationOnLoad: false,
      updateMapLocationOnPositionChange: false,
      showMoveToCurrentLocationFloatingActionButton: false,
      markers: markers,
    );

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                onLongPress: addPin,
                center: LatLng(47.4990, 19.0437),
                zoom: 12.0,
                minZoom: 10,
                plugins: [
                  UserLocationPlugin(),
                ],
              ),
              layers: [
                new TileLayerOptions(
                  urlTemplate:
                      urlStart + (isPresentTime ? "Your basic style" : "Your style with overlay") + urlEnd,
                  additionalOptions: {
                    'accessToken':
                        'Your accessToken',
                  },
                ),
                MarkerLayerOptions(
                  markers: markers,
                ),
                userLocationOptions,
              ],
              mapController: mapController,
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(height: 60.0, width: 60.0, child: _openPopupMenu()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _openPopupMenu() => PopupMenuButton<int>(
        onSelected: (value) {
          setState(() {
            value == 1 ? isPresentTime = true : isPresentTime = false;
          });
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text("Present time"),
          ),
          PopupMenuItem(
            value: 2,
            child: Text("Budapest 1884"),
          ),
        ],
        icon: Container(
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: Icon(
              Icons.calendar_today_rounded,
              color: Colors.white,
              size: 24.0,
            ),
          ),
          decoration: new BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
      );

  addPin(LatLng latlng) {
    setState(() {
      markers.add(Marker(
        width: 30.0,
        height: 30.0,
        point: latlng,
        builder: (ctx) => Container(
          child: Image.asset('assets/pin.png'),
        ),
      ));
    });
  }
}
