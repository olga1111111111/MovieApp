import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/ui/widgets/loader_widget/loader_view_model.dart';

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

  static Widget create() {
    return Provider(
      create: (context) => LoaderViewModel(context),
      child: const LoaderWidget(),
      lazy: false,
    );
  }
}
