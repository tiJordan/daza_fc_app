import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

import 'app_drawer.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VideosScreenState createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // ignore: deprecated_member_use
    _controller = VideoPlayerController.network('URL_DO_VIDEO')
      ..initialize().then((_) => setState(() {}));
  }

  Widget _column() {
    return Column(
      children: [
        const Text('Vídeos'),
        const SizedBox(height: 20),
        _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Vídeos'),
          backgroundColor: Colors.blueGrey, // Cor do AppBar
        ),
        drawer: const AppDrawer(currentScreen: 'Home'), // Adiciona o Drawer
        body: _column());
  }
}
