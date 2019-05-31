import 'package:flutter/material.dart';
import 'dart:async';


import '../helpers/ensure_visible.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class LocationInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  Uri _staticMapUri;
  final FocusNode _addressInputFocusNode = FocusNode();
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    super.initState();
  }

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  // void getStaticMap() {
  //   final StaticMapProvider staticMapViewProvider =
  //       StaticMapProvider('AIzaSyAcyrReXnRCbN8ZVjA8rV7Z9Q93XVfbvw0');
  //   final Uri staticMapUri = staticMapViewProvider.getStaticUriWithMarkers(
  //       [Marker('position', 'Position', 41.40338, 2.17403)],
  //       center: Location(41.40338, 2.17403),
  //       width: 500,
  //       height: 300,
  //       maptype: StaticMapViewType.roadmap);
  //   setState(() {
  //     _staticMapUri = staticMapUri;
  //   });
  // }

  void _updateLocation() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        EnsureVisibleWhenFocused(
          focusNode: _addressInputFocusNode,
          child: TextFormField(
            focusNode: _addressInputFocusNode,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      ],
    );
  }
}
