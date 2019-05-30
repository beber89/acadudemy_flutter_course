import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:acadudemy_flutter_course/bloc-models/app_bloc.dart';


class LogoutListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Logout'),
          onTap: () {
            Provider.of<AppBloc>(context).authBloc.logout();
            Navigator.of(context).pushReplacementNamed('/');
          },
        );
  }
}
