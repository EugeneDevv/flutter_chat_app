import 'package:chat_app/domain/value_objects/app_assets.dart';
import 'package:chat_app/domain/value_objects/app_constants.dart';
import 'package:chat_app/presentation/router/routes.dart';
import 'package:chat_app/presentation/widgets/message_item.dart';
import 'package:chat_app/presentation/widgets/spaces.dart';
import 'package:chat_app/presentation/theme/app_colors.dart';
import 'package:chat_app/presentation/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({required this.userIdentifier, super.key});

  final String userIdentifier;

  @override
  State<ChatPage> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final ItemScrollController itemScrollController = ItemScrollController();
  final FocusNode textFieldFocusNode = FocusNode();
  String title = '';
  List<BaseMessage> messageList = <BaseMessage>[];
  bool hasPrevious = false;
  bool hasNext = false;
  late PreviousMessageListQuery query;
  OpenChannel? openChannel;

  @override
  void initState() {
    super.initState();
    SendbirdChat.addChannelHandler('OpenChannel', MyOpenChannelHandler(this));
    SendbirdChat.addConnectionHandler('OpenChannel', MyConnectionHandler(this));

    OpenChannel.getChannel(channelUrl).then((OpenChannel openChannel) {
      this.openChannel = openChannel;
      openChannel.enter().then((_) => initialize());
    });
  }

  void initialize() {
    OpenChannel.getChannel(channelUrl).then((OpenChannel openChannel) {
      query = PreviousMessageListQuery(
        channelType: ChannelType.open,
        channelUrl: channelUrl,
      )..next().then((List<BaseMessage> messages) {
          setState(() {
            messageList
              ..clear()
              ..addAll(messages);
            title = '${openChannel.name} (${messageList.length})';
            hasPrevious = query.hasNext;
          });
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: ()=> context.pushReplacementNamed(Routes.loginPageRoute),
          child: SvgPicture.asset(
            AppSvgs.backArrowIcon,
            height: 40,
          ),
        ),
        leadingWidth: 40,
        title: Text(title),
        centerTitle: true,
        actions: <Widget>[
          SvgPicture.asset(
            AppSvgs.hamburgerIcon,
            height: 40,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                if (hasPrevious) previousButton() else Container(),
                Expanded(child: messageList.isNotEmpty ? list() : Container()),
              ],
            ),
          ),
          verySmallVerticalSizedBox,
          Container(
            color: AppColors.chineseBlack,
            padding: const EdgeInsets.fromLTRB(8, 4, 16, 4),
            child: Row(
              children: <Widget>[
                SvgPicture.asset(
                  AppSvgs.addIcon,
                ),
                Flexible(
                  child: TextField(
                    controller: messageController,
                    focusNode: textFieldFocusNode,
                    onChanged: (_) => setState(() {}),
                    maxLines: 2,
                    minLines: 1,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppColors.inputBorder,
                        ),
                        borderRadius: BorderRadius.circular(48),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppColors.inputBorder,
                        ),
                        borderRadius: BorderRadius.circular(48),
                      ),
                      hintText: '메세지 보내기',
                      hintStyle: normalSize14Text(AppColors.grey),
                      filled: true,
                      fillColor: AppColors.inputFill,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(6, 10, 8, 10),
                        child: InkWell(
                          onTap: () {
                            textFieldFocusNode.unfocus();

                            if (messageController.value.text.isEmpty) {
                              return;
                            }

                            openChannel?.sendUserMessage(
                              UserMessageCreateParams(
                                message: messageController.value.text,
                              ),
                              handler: (
                                UserMessage message,
                                SendbirdException? e,
                              ) async {
                                if (e != null) {
                                  await showDialogToResendUserMessage(message);
                                } else {
                                  addMessage(message);
                                }
                              },
                            );
                            messageController.clear();
                          },
                          child: SvgPicture.asset(
                            messageController.text.trim().isEmpty
                                ? AppSvgs.sendIcon
                                : AppSvgs.pinkSendIcon,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget previousButton() {
    return Container(
      width: double.maxFinite,
      height: 32,
      color: AppColors.blue,
      child: IconButton(
        icon: const Icon(Icons.expand_less, size: 16),
        color: Colors.white,
        onPressed: () async {
          if (query.hasNext && !query.isLoading) {
            final List<BaseMessage> messages = await query.next();
            final OpenChannel openChannel =
                await OpenChannel.getChannel(channelUrl);
            setState(() {
              messageList.insertAll(0, messages);
              title = '${openChannel.name} (${messageList.length})';
              hasPrevious = query.hasNext;
            });
            await scroll(0);
          }
        },
      ),
    );
  }

  Widget list() {
    return ScrollablePositionedList.builder(
      physics: const ClampingScrollPhysics(),
      initialScrollIndex: messageList.length - 1,
      itemScrollController: itemScrollController,
      itemCount: messageList.length,
      itemBuilder: (BuildContext context, int index) {
        if (index >= messageList.length) return Container();

        final BaseMessage message = messageList[index];

        return GestureDetector(
          onLongPress: () async {
            final OpenChannel openChannel =
                await OpenChannel.getChannel(channelUrl);
            await openChannel.deleteMessage(message.messageId);
            setState(() {
              messageList.remove(message);
              title = '${openChannel.name} (${messageList.length})';
            });
          },
          child: MessageItem(
            message: message,
            userIdentifier: widget.userIdentifier,
          ),
        );
      },
    );
  }

  Future<void> showDialogToResendUserMessage(UserMessage message) async {
    await showDialog<dynamic>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Resend: ${message.message}'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                openChannel?.resendUserMessage(
                  message,
                  handler: (UserMessage message, SendbirdException? e) async {
                    if (e != null) {
                      await showDialogToResendUserMessage(message);
                    } else {
                      addMessage(message);
                    }
                  },
                );

                // Get.back();TODo(eugene)
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void addMessage(BaseMessage message) {
    OpenChannel.getChannel(channelUrl).then((OpenChannel openChannel) {
      setState(() {
        messageList.add(message);
        title = '${openChannel.name} (${messageList.length})';
      });

      Future<dynamic>.delayed(
        const Duration(milliseconds: 100),
        () => scroll(messageList.length - 1),
      );
    });
  }

  void updateMessage(BaseMessage message) {
    OpenChannel.getChannel(channelUrl).then((OpenChannel openChannel) {
      setState(() {
        for (int index = 0; index < messageList.length; index++) {
          if (messageList[index].messageId == message.messageId) {
            messageList[index] = message;
            break;
          }
        }

        title = '${openChannel.name} (${messageList.length})';
      });
    });
  }

  void deleteMessage(int messageId) {
    OpenChannel.getChannel(channelUrl).then((OpenChannel openChannel) {
      setState(() {
        for (int index = 0; index < messageList.length; index++) {
          if (messageList[index].messageId == messageId) {
            messageList.removeAt(index);
            break;
          }
        }

        title = '${openChannel.name} (${messageList.length})';
      });
    });
  }

  Future<void> scroll(int index) async {
    if (messageList.length <= 1) return;

    while (!itemScrollController.isAttached) {
      await Future<dynamic>.delayed(const Duration(milliseconds: 1));
    }

    await itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
    );
  }
}
