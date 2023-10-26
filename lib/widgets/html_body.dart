import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../services/app_service.dart';
import '../utils/next_screen.dart';
import 'image_view.dart';
import 'video_player_widget.dart';

// final String demoText =
//     "<p>Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s</p>" +
//         '''<iframe width="560" height="315" src="https://www.youtube.com/embed/-WRzl9L4z3g" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>''' +
// //'''<video controls src="https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"></video>''' +
// //'''<iframe src="https://player.vimeo.com/video/226053498?h=a1599a8ee9" width="640" height="360" frameborder="0" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen></iframe>''' +
//         "<p>Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s</p>";

class HtmlBodyWidget extends StatefulWidget {
  final String? content;
  final bool isVideoEnabled;
  final bool isimageEnabled;
  final bool isIframeVideoEnabled;
  final double? fontSize;

  const HtmlBodyWidget({
    Key? key,
    required this.content,
    required this.isVideoEnabled,
    required this.isimageEnabled,
    required this.isIframeVideoEnabled,
    this.fontSize,
  }) : super(key: key);

  @override
  State<HtmlBodyWidget> createState() => _HtmlBodyWidgetState();
}

class _HtmlBodyWidgetState extends State<HtmlBodyWidget> {
  var expanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var seeMoreAvail = _detectSeeMoreAvail(constraints);
      return Wrap(
        children: [
          Html(
            data: widget.content,
            onLinkTap: (url, _, __) {
              AppService().openLinkWithCustomTab(context, url!);
            },
            style: {
              "body": Style(
                margin: Margins.zero,
                padding: HtmlPaddings.symmetric(horizontal: 20, vertical: 5),
                textAlign: TextAlign.justify,
                fontSize: FontSize(17),
                lineHeight: LineHeight(1.7),
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w400,
                color: Colors.blueGrey[600],
                maxLines: seeMoreAvail && !expanded ? 12 : null,
                textOverflow:
                    seeMoreAvail && !expanded ? TextOverflow.ellipsis : null,
              ),
              // "figure": Style(margin: Margins.zero, padding: EdgeInsets.zero),

              //Disable this line to disable full width image/video
              "p,h1,h2,h3,h4,h5,h6": Style(margin: Margins.all(20)),
            },
            extensions: [
              TagExtension(
                  tagsToExtend: {"iframe"},
                  builder: (ExtensionContext eContext) {
                    final String videoSource =
                        eContext.attributes['src'].toString();
                    if (widget.isIframeVideoEnabled == false)
                      return Container();
                    if (videoSource.contains('youtu')) {
                      return VideoPlayerWidget(
                          videoUrl: videoSource, videoType: 'youtube');
                    } else if (videoSource.contains('vimeo')) {
                      return VideoPlayerWidget(
                          videoUrl: videoSource, videoType: 'vimeo');
                    }
                    return Container();
                  }),
              TagExtension(
                  tagsToExtend: {"video"},
                  builder: (ExtensionContext eContext) {
                    final String videoSource =
                        eContext.attributes['src'].toString();
                    if (widget.isVideoEnabled == false) return Container();
                    return VideoPlayerWidget(
                        videoUrl: videoSource, videoType: 'network');
                  }),
              TagExtension(
                  tagsToExtend: {"img"},
                  builder: (ExtensionContext eContext) {
                    String imageUrl = eContext.attributes['src'].toString();
                    if (widget.isimageEnabled == false) return Container();
                    return InkWell(
                        onTap: () => nextScreen(
                            context, FullScreenImage(imageUrl: imageUrl)),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                        ));
                  }),
            ],
          ),
          !expanded && seeMoreAvail
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: _onSeeMoreTap,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Text(
                          'View more',
                          style: TextStyle(
                            fontSize: 17,
                            height: 1.7,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey[600],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : SizedBox(),
        ],
      );
    });
  }

  _onSeeMoreTap() {
    setState(() {
      expanded = true;
    });
  }

  _detectSeeMoreAvail(BoxConstraints constraints) {
    if (widget.content!.toLowerCase().contains('<video')) {
      return false;
    } else if (widget.content!.toLowerCase().contains('<iframe')) {
      return false;
    } else if (widget.content!.toLowerCase().contains('<img')) {
      return false;
    }

    final span = TextSpan(
      text: widget.content,
      style: TextStyle(
        fontSize: 17,
        height: 1.7,
        fontFamily: 'Open Sans',
        fontWeight: FontWeight.w400,
      ),
    );
    final tp = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.justify,
    );
    tp.layout(maxWidth: constraints.maxWidth);
    final numLines = tp.computeLineMetrics().length;
    if (numLines > 12) {
      return true;
    } else {
      return false;
    }
  }
}
