import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart' show LinkPreviewData;
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:mobile/services/helper_service/helper_service.dart';
import 'package:mobile/services/validator_service/validator_service.dart';
import 'package:mobile/ui/shared_widgets/internet_image.dart';
import 'package:mobile/ui/theme/app_spacing.dart';

class MessageBubble extends StatefulWidget {
  const MessageBubble({
    required this.sender,
    required this.text,
    required this.isMe,
    super.key,
  });

  final String sender;
  final String text;
  final bool isMe;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  LinkPreviewData? _linkPreviewData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    final bubbleColor = widget.isMe
        ? theme.colorScheme.primary
        : theme.colorScheme.tertiary;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: widget.isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            widget.sender,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.tertiary,
            ),
          ),
          const SizedBox(height: 5),
          Material(
            borderRadius: widget.isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
            elevation: 5,
            color: bubbleColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.md,
                horizontal: AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  if (ValidatorService.containsLink(widget.text))
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.md),
                      child: LinkPreview(
                        onTap: HelperService.launchURL,
                        text: widget.text,
                        linkPreviewData: _linkPreviewData,
                        onLinkPreviewDataFetched: (data) {
                          setState(() => _linkPreviewData = data);
                        },
                        imageBuilder: (imageUrl) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(AppSpacing.md),
                            child: InternetImage(
                              imageUrl: imageUrl,
                              width: double.infinity,
                              height: 160,
                              shape: BoxShape.rectangle,
                            ),
                          );
                        },
                        maxWidth: size.width * 0.7,
                        backgroundColor: bubbleColor.withValues(alpha: 0.9),
                        borderRadius: AppSpacing.base,
                        titleTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        descriptionTextStyle: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
