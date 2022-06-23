import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:themoviedb/domain/api_client/image_downloader.dart';

import 'package:themoviedb/ui/navigation/main_navigation.dart';

import 'package:themoviedb/ui/widgets/elements/radial_persent_widget.dart';
import 'package:themoviedb/ui/widgets/movie_details/movie_details_model.dart';

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _TopPosterWidget(),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: _MovieNamedWidget(),
        ),
        _ScoreWidget(),
        _SummaryWidget(),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: _OverviewWidget(),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: _DescriptionWidget(),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: _PeopleWidget(),
        ),
      ],
    );
  }
}

class _PeopleWidget extends StatelessWidget {
  const _PeopleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var crew =
        context.select((MovieDetailsModel model) => model.data.peopleData);
    if (crew.isEmpty) return const SizedBox.shrink();

    return Column(
      children: crew
          .map((chunk) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _PeopleWidgetRow(employes: chunk),
              ))
          .toList(),
      //  [
      //   _PeopleWidgetRow(),
      //   SizedBox(
      //     height: 20,
      //   ),
      //   _PeopleWidgetRow(),
      // ],
    );
  }
}

class _PeopleWidgetRow extends StatelessWidget {
  final List<MovieDetailsMoviePeopleData> employes;
  const _PeopleWidgetRow({Key? key, required this.employes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: employes
          .map((employee) => _PeopleWidgetRowItem(
                employee: employee,
              ))
          .toList(),
      // [
      //   Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text(
      //         'Stefano Sollima',
      //         style: namedStyle,
      //       ),
      //       Text(
      //         'Director',
      //         style: castMovieStyle,
      //       ),
      //     ],
      //   ),

      // ],
    );
  }
}

class _PeopleWidgetRowItem extends StatelessWidget {
  final MovieDetailsMoviePeopleData employee;
  const _PeopleWidgetRowItem({
    Key? key,
    required this.employee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const namedStyle = TextStyle(
        fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400);
    const castMovieStyle = TextStyle(
        fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            employee.name,
            style: namedStyle,
          ),
          Text(
            employee.job,
            style: castMovieStyle,
          ),
        ],
      ),
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final overview =
        context.select((MovieDetailsModel model) => model.data.overview);

    return Text(
      overview,
      style: const TextStyle(
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
    return const Text(
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
    final model = context.watch<MovieDetailsModel>();
    final posterData =
        context.select((MovieDetailsModel model) => model.data.posterData);
    final backdropPath = posterData.backdropPath;
    final posterPath = posterData.posterPath;
//backdropPath
//posterPath
// isFavorite -favoriteIcon
    return AspectRatio(
      aspectRatio: 411 / 231,
      child: Stack(
        children: [
          if (backdropPath != null)
            Image.network(ImageDownloader.imageUrl(backdropPath)),
          if (posterPath != null)
            Positioned(
                top: 20,
                left: 20,
                bottom: 20,
                child: Image.network(ImageDownloader.imageUrl(posterPath))),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              onPressed: () => model.toggleFavorite(context),
              icon: Icon(posterData.favoriteIcon),
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieNamedWidget extends StatelessWidget {
  const _MovieNamedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data =
        context.select((MovieDetailsModel model) => model.data.nameData);

    return Center(
      child: RichText(
        maxLines: 3,
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
              text: data.name,
              style:
                  const TextStyle(fontSize: 21, fontWeight: FontWeight.w600)),
          TextSpan(
              text: data.year,
              style: const TextStyle(
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
    final scoreData =
        context.select((MovieDetailsModel model) => model.data.scoreData);

    final trailerKey = scoreData.trailerKey;

    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Row(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: RadialPersentWidget(
              fillColor: const Color.fromARGB(255, 10, 23, 25),
              freeColor: const Color.fromARGB(255, 25, 54, 31),
              lineColor: const Color.fromARGB(255, 37, 203, 103),
              percent: scoreData.voteAverage / 100,
              lineWidth: 3,
              child: Text(
                scoreData.voteAverage.toStringAsFixed(0),
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
          TextButton(onPressed: () {}, child: const Text('User Score')),
        ],
      ),
      Container(
        width: 1,
        height: 15,
        color: Colors.grey,
      ),
      if (trailerKey != null)
        TextButton(
          onPressed: () => Navigator.of(context).pushNamed(
              MainNavigationRouteNames.movieTrailerWidget,
              arguments: trailerKey),
          child: Row(
            children: const [
              Icon(
                Icons.play_arrow,
                // color: Colors.grey,
              ),
              Text('Play Trailer'),
            ],
          ),
        )
    ]);

    //     trailerKey != null
    //         ? Row(
    //             children: [
    //               Icon(
    //                 Icons.play_arrow,
    //                 color: Colors.grey,
    //               ),
    //               TextButton(onPressed: () {}, child: Text('Play Trailer')),
    //             ],
    //           )
    //         : const SizedBox.shrink(),
    //   ],
    // );
  }
}

class _SummaryWidget extends StatelessWidget {
  const _SummaryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final summary =
        context.select((MovieDetailsModel model) => model.data.summary);

    return ColoredBox(
      color: const Color.fromRGBO(22, 21, 25, 1.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(
          summary,
          // ' R (US 04/29/2021 ) боевик, триллер, военный 1 h 49m',
          maxLines: 3,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
