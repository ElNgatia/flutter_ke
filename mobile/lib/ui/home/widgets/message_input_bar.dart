import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MessageInputBar extends HookConsumerWidget {
  const MessageInputBar({super.key});

  static const _inputBackground = Color(0xff1e1836);
  static const _hintColor = Color(0xff6b6580);
  static const Color _textColor = Colors.white;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = useFocusNode();

    return Container(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: 16,
      ),
      child: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: _inputBackground,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xff2d2640),
            ),
          ),
          child: ListenableBuilder(
            listenable: focusNode,
            builder: (_, _) => TextField(
              focusNode: focusNode,
              style: const TextStyle(
                color: _textColor,
                height: 1.35,
              ),
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: const TextStyle(
                  color: _hintColor,
                ),
                suffixIconColor: focusNode.hasFocus
                    ? Colors.deepPurpleAccent
                    : _hintColor,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
            
                suffixIcon: SizedBox.square(
                  dimension: 24,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(20),
                    child: const Icon(
                      Icons.send_rounded,
                      size: 18,
                    ),
                  ),
                ),
              ),
              minLines: 1,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
            ),
          ),
        ),
      ),
    );
  }
}
