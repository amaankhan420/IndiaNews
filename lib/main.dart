import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'api_service.dart';
import 'post_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'India News'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ApiService apiService = ApiService();
  late Future<List<Post>> futurePosts;
  late List<Post> allPosts;

  @override
  void initState() {
    super.initState();
    allPosts = [];
    futurePosts = apiService.fetchTopNewsIndia();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final posts = await futurePosts;
      setState(() {
        allPosts = posts;
      });
    } catch (error) {
      throw 'Error fetching posts: $error';
    }
  }

  void openUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color.fromRGBO(39, 49, 59, 1),
      ),
      body: allPosts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: allPosts.length,
              itemBuilder: (context, index) {
                return Card(
                  color: const Color.fromRGBO(235, 255, 249, 0.5),
                  child: ListTile(
                    title: Text(
                      allPosts[index].title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(allPosts[index].description),
                        if (allPosts[index].urlToImage.startsWith('http'))
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Image.network(
                                allPosts[index].urlToImage,
                                height: 200,
                                width: double.maxFinite,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                      ],
                    ),
                    contentPadding: const EdgeInsets.all(8.0),
                    onTap: () {
                      openUrl(allPosts[index].url);
                    },
                  ),
                );
              },
            ),
    );
  }
}
