import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fahem_business/core/network/api_constants.dart';
import 'package:fahem_business/core/resources/colors_manager.dart';

class ShowFullImageScreen extends StatefulWidget {
  final String image;
  final String directory;

  const ShowFullImageScreen({Key? key, required this.image, required this.directory}) : super(key: key);

  @override
  State<ShowFullImageScreen> createState() => _ShowFullImageScreenState();
}

class _ShowFullImageScreenState extends State<ShowFullImageScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.black,
      body: CachedNetworkImage(
        imageUrl: ApiConstants.fileUrl(fileName: '${widget.directory}/${widget.image}'),
        placeholder: (context, url) {
          return Shimmer.fromColors(
            baseColor: ColorsManager.grey300,
            highlightColor: ColorsManager.grey100,
            direction: ShimmerDirection.rtl,
            child: Container(
              width: double.infinity,
              color: ColorsManager.grey,
            ),
          );
        },
        errorWidget: (context, url, error) {
          return Container(
            width: double.infinity,
            color: ColorsManager.grey,
            child: Container(),
          );
        },
        imageBuilder: (context, imageProvider) {
          return PhotoView(imageProvider: imageProvider);
        },
      ),
    );
  }
}