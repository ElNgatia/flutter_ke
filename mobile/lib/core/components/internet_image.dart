import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/components/loading_indicator.dart';

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
        return switch (state.extendedImageLoadState) {
          .completed => state.completedWidget,
          .failed => const Icon(
              Icons.image_not_supported_rounded,
              color: Colors.grey,
            ),
          .loading => const LoadingIndicator()
        };
      },
    );
  }
}
