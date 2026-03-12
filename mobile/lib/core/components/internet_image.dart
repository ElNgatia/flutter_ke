import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/core.dart';

class InternetImage extends StatelessWidget {
  const InternetImage({
    required this.imageUrl,
    this.height,
    this.width,
    super.key,
  });

  final String imageUrl;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      width: width,
      height: height,
      imageUrl,
      fit: BoxFit.cover,
      shape: BoxShape.circle,
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {
          case LoadState.completed:
            return state.completedWidget;
          case LoadState.failed:
            return const Icon(
              Icons.image_not_supported_rounded,
              color: Colors.grey,
            );
          case LoadState.loading:
            return const LoadingIndicator();
        }
      },
    );
  }
}
