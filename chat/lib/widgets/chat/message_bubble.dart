import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String username;
  final String message;
  final String imageUrl;
  final bool isMe;

  const MessageBubble(this.username, this.message, this.imageUrl, this.isMe,
      {super.key});

  static const border = Radius.circular(12);
  static const noBorder = Radius.circular(0);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 300),
              decoration: BoxDecoration(
                color: isMe
                    ? Colors.grey[300]
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: border,
                  topRight: border,
                  bottomLeft: isMe ? border : noBorder,
                  bottomRight: isMe ? noBorder : border,
                ),
              ),
              // width: 140,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: const EdgeInsets.fromLTRB(8, 30, 8, 4),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isMe ? Colors.black : Colors.white,
                    ),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      color: isMe ? Colors.black : Colors.white,
                    ),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          right: isMe ? 8 : null,
          left: !isMe ? 8 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              imageUrl,
            ),
          ),
        )
      ],
    );
  }
}
