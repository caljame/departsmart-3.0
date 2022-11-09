import 'package:flutter/material.dart';


class PleaseWaitWidget extends StatelessWidget {
  PleaseWaitWidget({
    Key? key,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Container(
        color:Colors.white.withOpacity(0.8),
        child: const Center(
          child: CircularProgressIndicator(),
        ));
  }
}
