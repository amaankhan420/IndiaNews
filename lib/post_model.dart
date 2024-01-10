class Post {
  final String title;
  final String description;
  final String url;
  final String urlToImage;

  Post({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
    );
  }
}
