import 'package:flutter/material.dart';
import 'package:mobile/core/core.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({required this.size, this.image, super.key});

  final String? image;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFF4F6F9),
      ),
      child: image != null
          ? InternetImage(imageUrl: image!)
          : const Icon(Icons.group, color: Colors.grey),
    );
  }
}
