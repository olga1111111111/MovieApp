import 'package:flutter/material.dart';
import 'package:themoviedb/Labrary/Widgets/inherited/provider.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';

import 'package:themoviedb/ui/widgets/movie_details/movie_details_model.dart';

class MovieDetailsMainScreenCastWidget extends StatelessWidget {
  const MovieDetailsMainScreenCastWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Series cast",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(
            height: 250,
            child: Scrollbar(
              child: _ActorListWidget(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child:
                TextButton(onPressed: () {}, child: Text("Full cast & Crew")),
          ),
        ],
      ),
    );
  }
}

class _ActorListWidget extends StatelessWidget {
  const _ActorListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    var cast = model?.movieDetails?.credits.cast;
    if (cast == null || cast.isEmpty) return const SizedBox.shrink();
    return ListView.builder(
      itemCount: 100,
      itemExtent: 120,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, int index) {
        return _ActorListItemWidget(actorIndex: index);
      },
    );
  }
}

class _ActorListItemWidget extends StatelessWidget {
  final int actorIndex;
  const _ActorListItemWidget({
    Key? key,
    required this.actorIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.read<MovieDetailsModel>(context);
    var actor = model!.movieDetails!.credits.cast[actorIndex];
    final profilePath = actor.profilePath;
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black.withOpacity(0.2)),
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: [
                profilePath != null
                    ? Image.network(
                        ApiClient.imageUrl(profilePath),
                        width: 120,
                        height: 120,
                        fit: BoxFit.fitWidth,
                      )
                    : const SizedBox.shrink(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          actor.name,
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          actor.character,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
