class Movie {

  final String title;
  final String poster;
  final String imdbID;

  Movie({required this.title, required this.poster, required this.imdbID});
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        title: json["Title"],
        poster: json["Poster"],
        imdbID: json["imdbID"]
    );
  }
}