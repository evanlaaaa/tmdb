import 'package:flutter/material.dart';
import 'package:tmdb/model/trailer.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {
  final String videoId;
  final Site site;

  const VideoScreen({super.key, required this.videoId, required this.site});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {

  YoutubePlayerController? controller;

  @override
  void initState() {
    super.initState();

    if(widget.site.isYoutube) {
      controller = YoutubePlayerController(
        initialVideoId: widget.videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
        )
      ),
      body: Column(
        children: [
          Expanded(
            child: widget.site.isYoutube
              ? YoutubePlayer(
                controller: controller!,
                showVideoProgressIndicator: true,
              )
              : VimeoPlayer(
                videoId: widget.videoId,
              )
          ),
        ],
      ),
    );
  }
}