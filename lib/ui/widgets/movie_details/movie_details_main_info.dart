import 'package:flutter/material.dart';

import 'package:themoviedb/Labrary/Widgets/inherited/provider.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/entity/movie_details_credits.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

import 'package:themoviedb/ui/widgets/elements/radial_persent_widget.dart';
import 'package:themoviedb/ui/widgets/movie_details/movie_details_model.dart';

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
        const Padding(
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
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    var crew = model?.movieDetails?.credits.crew;
    if (crew == null || crew.isEmpty) return const SizedBox.shrink();
    crew = crew.length > 4 ? crew.sublist(0, 4) : crew;
    var crewChunks = <List<Employee>>[];
    for (var i = 0; i < crew.length; i += 2) {
      crewChunks.add(
        crew.sublist(i, i + 2 > crew.length ? crew.length : i + 2),
      );
    }

    return Column(
      children: crewChunks
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
  final List<Employee> employes;
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
  final Employee employee;
  const _PeopleWidgetRowItem({
    Key? key,
    required this.employee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final namedStyle = TextStyle(
        fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400);
    final castMovieStyle = TextStyle(
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
    final model = NotifierProvider.watch<MovieDetailsModel>(context);

    return Text(
      model?.movieDetails?.overview ?? '',
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
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final backdropPath = model?.movieDetails?.backdropPath;
    final posterPath = model?.movieDetails?.posterPath;

    return AspectRatio(
      aspectRatio: 411 / 231,
      child: Stack(
        children: [
          backdropPath != null
              ? Image.network(ApiClient.imageUrl(backdropPath))
              : const SizedBox.shrink(),
          Positioned(
            top: 20,
            left: 20,
            bottom: 20,
            child: posterPath != null
                ? Image.network(ApiClient.imageUrl(posterPath))
                : const SizedBox.shrink(),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              icon: Icon(model?.isFavorite == true
                  ? Icons.favorite
                  : Icons.favorite_border_outlined),
              onPressed: () => model?.toggleFavorite(),
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
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    var year = model?.movieDetails?.releaseDate?.year.toString();
    year = year != null ? ' ($year)' : '';
    return Center(
      child: RichText(
        maxLines: 3,
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
              text: model?.movieDetails?.title ?? '',
              style:
                  const TextStyle(fontSize: 21, fontWeight: FontWeight.w600)),
          TextSpan(
              text: year,
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
    final movieDetails =
        NotifierProvider.watch<MovieDetailsModel>(context)?.movieDetails;
    var voteAverage = movieDetails?.voteAverage ?? 0;
    voteAverage = voteAverage * 10;
    final videos = movieDetails?.videos.results
        .where((video) => video.type == 'Trailer' && video.site == 'YouTube');
    final trailerKey = videos?.isNotEmpty == true ? videos?.first.key : null;

    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Row(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: RadialPersentWidget(
              fillColor: Color.fromARGB(255, 10, 23, 25),
              freeColor: Color.fromARGB(255, 25, 54, 31),
              lineColor: Color.fromARGB(255, 37, 203, 103),
              percent: voteAverage / 100,
              lineWidth: 3,
              child: Text(
                voteAverage.toStringAsFixed(0),
                style: TextStyle(color: Colors.white, fontSize: 15),
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
      trailerKey != null
          ? TextButton(
              onPressed: () => Navigator.of(context).pushNamed(
                  MainNavigationRouteNames.movieTrailerWidget,
                  arguments: trailerKey),
              child: Row(
                children: [
                  const Icon(
                    Icons.play_arrow,
                    // color: Colors.grey,
                  ),
                  const Text('Play Trailer'),
                ],
              ),
            )
          : const SizedBox.shrink(),
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
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    if (model == null) return const SizedBox.shrink();
    var texts = <String>[];
    final releaseDate = model.movieDetails?.releaseDate;
    if (releaseDate != null) {
      texts.add(model.stringFromDate(releaseDate));
    }
    final productionCountries = model.movieDetails?.productionCountries;
    if (productionCountries != null && productionCountries.isNotEmpty) {
      texts.add('(${productionCountries.first.iso})');
    }
    final genres = model.movieDetails?.genres;
    if (genres != null && genres.isNotEmpty) {
      var genersNames = <String>[];
      for (var genr in genres) {
        genersNames.add(genr.name);
      }
      texts.add(genersNames.join(', '));
    }
    final runtime = model.movieDetails?.runtime ?? 0;
    // final milliseconds = runtime * 60000;
    // final runtimeDate =
    //     DateTime.fromMillisecondsSinceEpoch(milliseconds).toUtc();
    // texts.add(DateFormat.Hm().format(runtimeDate));
    final duration = Duration(minutes: runtime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    texts.add('${hours}h  ${minutes}m');

    return ColoredBox(
      color: const Color.fromRGBO(22, 21, 25, 1.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(
          texts.join(' '),
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
