import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'app_drawer.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VideosScreenState createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  List<Map<String, dynamic>> videos = [];
  // late VideoPlayerController _controller;

//  @override
//  void initState() {
//    super.initState();
  // ignore: deprecated_member_use
//    _controller = VideoPlayerController.network('URL_DO_VIDEO')
//      ..initialize().then((_) => setState(() {}));
//  }

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    final response =
        await http.get(Uri.parse('http://192.168.0.141:5000/api/videos'));
    setState(() {
      videos = List<Map<String, dynamic>>.from(json.decode(response.body));
    });
  }

  void _addVideo() {
    TextEditingController urlController = TextEditingController();
    TextEditingController tituloController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Adicionar Vídeo'),
        content: Column(
          children: [
            TextField(
              controller: tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(labelText: 'URL do Vídeo'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              await http.post(
                Uri.parse('http://192.168.0.141:5000/api/videos'),
                body: json.encode({
                  'titulo': tituloController.text,
                  'url': urlController.text,
                }),
              );
              Navigator.pop(context);
              _fetchVideos();
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vídeos'),
        backgroundColor: Colors.blueGrey, // Cor do AppBar
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addVideo,
        child: const Icon(Icons.add),
      ),
      drawer: const AppDrawer(currentScreen: 'Home'), // Adiciona o Drawer
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return VideoPlayerWidget(url: video['url']);
        },
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  const VideoPlayerWidget({super.key, required this.url});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // ignore: deprecated_member_use
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : const CircularProgressIndicator();
  }
}
