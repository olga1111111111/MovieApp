import 'package:flutter/material.dart';
 

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // static Widget create() {
  //   return Provider(
  //     create: (context) => LoaderViewModel(context),
  //     child: const LoaderWidget(),
  //     lazy: false,
  //   );
  // }
}
