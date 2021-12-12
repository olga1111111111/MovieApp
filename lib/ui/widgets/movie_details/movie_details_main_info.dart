import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:themoviedb/resources/resources.dart';
import 'package:themoviedb/ui/widgets/elements/radial_persent_widget.dart';

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TopPosterWidget(),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: _MovieNamedWidget(),
        ),
        _ScoreWidget(),
        _SummaryWidget(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: _OverviewWidget(),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: _DescriptionWidget(),
        ),
        SizedBox(
          height: 20,
        ),
        _PeopleWidget(),
      ],
    );
  }
}

class _PeopleWidget extends StatelessWidget {
  const _PeopleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final namedStyle = TextStyle(
        fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400);
    final castMovieStyle = TextStyle(
        fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400);
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stefano Sollima',
                  style: namedStyle,
                ),
                Text(
                  'Director',
                  style: castMovieStyle,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stefano Sollima',
                  style: namedStyle,
                ),
                Text(
                  'Director',
                  style: castMovieStyle,
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stefano Sollima',
                  style: namedStyle,
                ),
                Text(
                  'Director',
                  style: castMovieStyle,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stefano Sollima',
                  style: namedStyle,
                ),
                Text(
                  'Director',
                  style: castMovieStyle,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Коллеги и жена Джона Келли убиты. Чудом оставшийся в живых мужчина решает найти преступников и отомстить.',
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class _OverviewWidget extends StatelessWidget {
  const _OverviewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Overview',
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class _TopPosterWidget extends StatelessWidget {
  const _TopPosterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image(image: AssetImage(AppImages.topHeaderBackground)),
        Positioned(
            top: 20,
            left: 20,
            bottom: 20,
            child: Image(image: AssetImage(AppImages.subHeader))),
      ],
    );
  }
}

class _MovieNamedWidget extends StatelessWidget {
  const _MovieNamedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        maxLines: 3,
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
              text: 'Без жалости ',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600)),
          TextSpan(
              text: '  2021',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey))
        ]),
      ),
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: RadialPersentWidget(
                  child: Text(
                    '72%',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  fillColor: Color.fromARGB(255, 10, 23, 25),
                  freeColor: Color.fromARGB(255, 25, 54, 31),
                  lineColor: Color.fromARGB(255, 37, 203, 103),
                  percent: 0.72,
                  lineWidth: 3),
            ),
            TextButton(onPressed: () {}, child: Text('User Score')),
          ],
        ),
        Container(
          width: 1,
          height: 15,
          color: Colors.grey,
        ),
        Row(
          children: [
            Icon(
              Icons.play_arrow,
              color: Colors.grey,
            ),
            TextButton(onPressed: () {}, child: Text('Play Trailer')),
          ],
        ),
      ],
    );
  }
}

class _SummaryWidget extends StatelessWidget {
  const _SummaryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Color.fromRGBO(22, 21, 25, 1.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
        child: Text(
          ' R 04/29/2021 (US) боевик, триллер, военный 1 h 49m',
          maxLines: 3,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
