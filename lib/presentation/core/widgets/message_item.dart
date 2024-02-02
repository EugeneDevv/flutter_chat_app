import 'dart:math';

import 'package:chat_app/presentation/chat_page.dart';
import 'package:chat_app/presentation/core/widgets/spaces.dart';
import 'package:chat_app/presentation/theme/app_colors.dart';
import 'package:chat_app/presentation/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    required this.message,
    super.key,
  });

  final BaseMessage message;

  @override
  Widget build(BuildContext context) {
    final Random random = Random();
    return ListTile(
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (message.sender?.userId != 'Eujoh123')
            SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  CircleAvatar(
                    radius: 16,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        message.sender?.profileUrl ?? '',
                        errorBuilder: (_, __, ___) {
                          return Container(
                            width: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: random.nextInt(19).isEven
                                    ? AppColors.blue
                                    : AppColors.pink,
                              ),
                            ),
                            child: const Center(child: Text('👻')),
                          );
                        },
                      ),
                    ),
                  ),
                  verySmallHorizontalSizedBox,
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(18),
                          bottomRight: Radius.circular(18),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            message.sender?.userId ?? '',
                            style: normalSize14Text(AppColors.usernameGreyText),
                            overflow: TextOverflow.ellipsis,
                          ),
                          verySmallVerticalSizedBox,
                          Text(
                            message.message,
                            style: normalSize16Text(Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  verySmallHorizontalSizedBox,
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      DateFormat.jm().format(
                        DateTime.fromMillisecondsSinceEpoch(message.createdAt),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            const SizedBox(),
          if (message.sender?.userId == 'Eujoh123')
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(16),
                  bottomLeft: Radius.circular(18),
                ),
                gradient: LinearGradient(
                  colors: <Color>[
                    AppColors.darkPinkGradient,
                    AppColors.lightPinkGradient,
                  ],
                ),
              ),
              child: Text(
                message.message,
                style: normalSize16Text(Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

class MyOpenChannelHandler extends OpenChannelHandler {
  MyOpenChannelHandler(this.state);
  final ChatPageState state;

  @override
  void onMessageReceived(BaseChannel channel, BaseMessage message) {
    state.addMessage(message);
  }

  @override
  void onMessageUpdated(BaseChannel channel, BaseMessage message) {
    state.updateMessage(message);
  }

  @override
  void onMessageDeleted(BaseChannel channel, int messageId) {
    state.deleteMessage(messageId);
  }
}

class MyConnectionHandler extends ConnectionHandler {
  MyConnectionHandler(this.state);
  final ChatPageState state;

  @override
  void onConnected(String userId) {}

  @override
  void onDisconnected(String userId) {}

  @override
  void onReconnectStarted() {}

  @override
  void onReconnectSucceeded() {
    state.initialize();
  }

  @override
  void onReconnectFailed() {}
}
