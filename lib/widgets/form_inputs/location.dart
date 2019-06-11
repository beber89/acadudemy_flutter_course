import 'package:acadudemy_flutter_course/models/product.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../helpers/ensure_visible.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/location_data.dart';
import 'package:location/location.dart' as geoloc;

class LocationInput extends StatefulWidget {
  final Function setLocation;
  final Product product;

  LocationInput(this.setLocation, this.product);
  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  final FocusNode _addressInputFocusNode = FocusNode();
  String _apiGoogleKey;
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _initMapUri = CameraPosition(
    target: LatLng(41.40338, 2.17403),
    zoom: 14.4746,
  );
  final TextEditingController _addressInputController = TextEditingController();
  LocationData _locationData;

  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    if (widget.product != null) {
      _initMapUri = CameraPosition(
        target: LatLng(widget.product.location.latitude,
            widget.product.location.longitude),
        zoom: 14.4746,
      );
      _locationData = widget.product.location;
      _addressInputController.text = _locationData.address;
    }
    SharedPreferences.getInstance().then((prefs) {
      print(prefs.get("api_google_key"));
      _apiGoogleKey = prefs.get("api_google_key");
    });
    super.initState();
  }

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  void getStaticMap(String address) async {
    if (address.isEmpty) {
      widget.setLocation(null);
      return;
    }
    final Uri uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      {'address': address, 'key': _apiGoogleKey},
    );
    print(_apiGoogleKey);
    final http.Response response = await http.get(uri);
    final decodedResponse = json.decode(response.body);
    print(decodedResponse);
    final formattedAddress = decodedResponse['results'][0]['formatted_address'];
    final coords = decodedResponse['results'][0]['geometry']['location'];
    _locationData = LocationData(
        address: formattedAddress,
        latitude: coords['lat'],
        longitude: coords['lng']);
    widget.setLocation(_locationData);

    final CameraPosition currentMapUri = CameraPosition(
      target: LatLng(_locationData.latitude, _locationData.longitude),
      zoom: 10.4746,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(currentMapUri));
    setState(() {
      _addressInputController.text = _locationData.address;
    });
  }

Future<String> _getAddress(double lat, double lng) async {
    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      {
        'latlng': '${lat.toString()},${lng.toString()}',
        'key': _apiGoogleKey
      },
    );
    final http.Response response = await http.get(uri);
    print(lat);
    print(lng);
    final decodedResponse = json.decode(response.body);
    print(decodedResponse);
    final formattedAddress = decodedResponse['results'][0]['formatted_address'];
    return formattedAddress;
  }

  void _getUserLocation() async {
    final location = geoloc.Location();
    final currentLocation = await location.getLocation();
    final address = await _getAddress(
        currentLocation.latitude, currentLocation.longitude);
    getStaticMap(address);
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
            validator: (String value) {
              if (_locationData == null || value.isEmpty) {
                return 'No valid location found.';
              }
            },
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        FlatButton(
          child: Text('Locate User'),
          onPressed: _getUserLocation,
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
