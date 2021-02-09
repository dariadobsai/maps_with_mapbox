import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:user_location/user_location.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MapController mapController = MapController();
  UserLocationOptions userLocationOptions;
  List<Marker> markers = [];

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

    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          onLongPress: addPin,
          center: LatLng(47.4990, 19.0437), // Széchenyi Chain Bridge Coordinates
          zoom: 12.0, // Changed zoom level from 16 to 12, to better see the whole overlay area from further distance
          minZoom: 10,
          plugins: [
            UserLocationPlugin(),
          ],
        ),
        layers: [
          new TileLayerOptions(
            urlTemplate:
                "https://api.mapbox.com/styles/v1/{user}/{style}/tiles/256/{z}/{x}/{y}?access_token={accessToken}", // TODO: Paste your style here

            // TODO: add access token here OR if you keep it in one line in `urlTemplate`, then delete `additionalOptions`.
            additionalOptions: {
              'accessToken': 'Your accessToken',
            },
          ),
          MarkerLayerOptions(
            markers: markers,
          ),
          userLocationOptions,
        ],
        mapController: mapController,
      ),
    );
  }

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
