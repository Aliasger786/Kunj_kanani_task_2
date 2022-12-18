import 'dart:convert';
import 'package:http/http.dart' as http;
import '../movie.dart';

class Webservice {
  Future<List<Movie>> fetchMovies(String keyword) async {
    keyword = keyword.trim();
    final url = "http://www.omdbapi.com/?s=$keyword&apikey=62aa0fc6";
    final response = await http.get(url);
    if(response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final Iterable json = body["Search"];
      return json.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception("Unable to perform request!");
    }
  }
}