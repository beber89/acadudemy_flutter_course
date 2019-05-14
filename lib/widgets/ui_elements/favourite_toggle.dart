import "package:flutter/material.dart";


class FavouriteToggle extends StatefulWidget {
  Function onPressed;
  FavouriteToggle({this.onPressed});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FavouriteToggleState(onPressed);
  }
}

class _FavouriteToggleState extends State<FavouriteToggle>{
  bool isFavourite=false;
  Function onToggle;
  _FavouriteToggleState(this.onToggle);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return IconButton(
      icon: Icon(isFavourite? Icons.favorite:Icons.favorite_border),
      onPressed: () {
        setState(() {
          isFavourite = !isFavourite;
          onToggle(isFavourite);
          });
        },
      );
  }
}
