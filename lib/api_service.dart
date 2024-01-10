import 'dart:convert';
import 'package:http/http.dart' as http;
import 'post_model.dart';

class ApiService {
  static const String apiUrl = 'https://newsapi.org/v2/top-headlines';
  static const String apiKey = '8073fcbff65f45649ea5836315e7f0b0';

  Future<List<Post>> fetchTopNewsIndia() async {
    final response = await http.get(
      Uri.parse('$apiUrl?country=in&apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> articles = data['articles'];
      return articles.map((article) => Post.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load sports news');
    }
  }
}
