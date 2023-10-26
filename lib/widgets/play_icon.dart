import 'package:flutter/material.dart';
import 'package:travel_hour/models/icon_data.dart';

class BuildPlayIcon extends StatelessWidget {
  final String videoUrl;

  const BuildPlayIcon({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (videoUrl.isEmpty) {
      return SizedBox();
    } else {
      return PlayIcon().normal;
    }
  }
}
