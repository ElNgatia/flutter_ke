import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:mobile/services/helper_service/helper_service.dart';
import 'package:mobile/services/validator_service/validator_service.dart';
import 'package:mobile/ui/theme/app_spacing.dart';

class MessageBubble extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final url = ValidatorService.extractUrl(text);

    final bubbleColor = isMe
        ? theme.colorScheme.primary
        : theme.colorScheme.tertiary;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.tertiary,
            ),
          ),
          const SizedBox(height: 5),
          Material(
            borderRadius: isMe
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
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  if (ValidatorService.containsLink(text) && url != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: AnyLinkPreview(
                        onTap: () => HelperService.launchURL(url),
                        link: url,
                        previewHeight: size.height * .1,
                        displayDirection: .uiDirectionHorizontal,
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        bodyStyle: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        backgroundColor: bubbleColor.withValues(alpha: 0.9),
                        borderRadius: AppSpacing.base,
                        removeElevation: true,
                        cache: const Duration(days: 7),
                        errorWidget: const SizedBox.shrink(),
                        placeholderWidget: const SizedBox.shrink(),
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
