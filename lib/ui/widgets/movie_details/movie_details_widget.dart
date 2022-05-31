import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:themoviedb/Labrary/Widgets/inherited/provider.dart';

import 'package:themoviedb/ui/widgets/movie_details/movie_details_main_info.dart';
import 'package:themoviedb/ui/widgets/movie_details/movie_details_main_screen_cast_widget.dart';
import 'package:themoviedb/ui/widgets/movie_details/movie_details_model.dart';

class MovieDetailsWidget extends StatefulWidget {
  const MovieDetailsWidget({Key? key}) : super(key: key);

  @override
  State<MovieDetailsWidget> createState() => _MovieDetailsWidgetState();
}

class _MovieDetailsWidgetState extends State<MovieDetailsWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MovieDetailsModel>().setupLocale(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _TitleWidget(),
      ),
      backgroundColor: Colors.black,
      body: const ColoredBox(
        color: Color.fromRGBO(24, 23, 27, 1.0),
        child: _BodyWidget(),
      ),
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title =
        context.select((MovieDetailsModel model) => model.movieDetails?.title);
    return Text(title ?? 'Загрузка...');
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieDetails =
        context.select((MovieDetailsModel model) => model.movieDetails);

    if (movieDetails == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      children: const [
        MovieDetailsMainInfoWidget(),
        SizedBox(height: 30),
        MovieDetailsMainScreenCastWidget(),
      ],
    );
  }
}
