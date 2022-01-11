import 'package:json_annotation/json_annotation.dart';
import 'package:themoviedb/domain/entity/movie.dart';

part 'popular_movie_response.g.dart';
//snake: преобразавание полей в змеиный формат
// explisitToJson: для также сгенерированного поля List<Movie>

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PopularMovieResponse {
  final int page;
  @JsonKey(name: 'results')
  final List<Movie> movie;
  final int totalResults;
  final int totalPages;

  PopularMovieResponse(
    this.page,
    this.movie,
    this.totalResults,
    this.totalPages,
  );

  factory PopularMovieResponse.fromJson(Map<String, dynamic> json) =>
      _$PopularMovieResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PopularMovieResponseToJson(this);
}
