import 'package:flutter/material.dart';
import 'dart:async';

import '../helpers/ensure_visible.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';



class LocationInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  final FocusNode _addressInputFocusNode = FocusNode();
  Completer<GoogleMapController> _controller = Completer();
  final CameraPosition _initMapUri = CameraPosition(
    target: LatLng(41.40338, 2.17403),
    zoom: 14.4746,
  );
  final TextEditingController _addressInputController = TextEditingController();


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

  void getStaticMap(String address) async {
    if (address.isEmpty) {
      return;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiGoogleKey = prefs.get("api_google_key");
    final Uri uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      {'address': address, 'key': apiGoogleKey},
    );
    print(apiGoogleKey);
    final http.Response response = await http.get(uri);
    final decodedResponse = json.decode(response.body);
    print(decodedResponse);
    final formattedAddress = decodedResponse['results'][0]['formatted_address'];
    final coords = decodedResponse['results'][0]['geometry']['location'];


    final CameraPosition currentMapUri = CameraPosition(
    target: LatLng(coords['lat'], coords['lng']),
    zoom: 10.4746,
  );
     final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(currentMapUri));
    setState(() {
      _addressInputController.text = formattedAddress;
    });
  }

  void _updateLocation() {
    if (!_addressInputFocusNode.hasFocus) {
      getStaticMap(_addressInputController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        EnsureVisibleWhenFocused(
          focusNode: _addressInputFocusNode,
          child: TextFormField(
            focusNode: _addressInputFocusNode,
            controller: _addressInputController,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
            height: 300,
            width: 500,
            child: GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _initMapUri,

              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          )
      ],
    );
  }
}
