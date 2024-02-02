import 'package:chat_app/domain/value_objects/app_constants.dart';
import 'package:chat_app/presentation/router/routes.dart';
import 'package:chat_app/presentation/theme/app_colors.dart';
import 'package:chat_app/presentation/theme/text_theme.dart';
import 'package:chat_app/presentation/widgets/spaces.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController controller = TextEditingController();
  bool isLoading = false;
  bool isLoadingGuest = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: size.height * 0.2,
            top: size.height * 0.05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('Hello, \nWelcome Back', style: heavySize24Text()),
              Column(
                children: <Widget>[
                  TextField(
                    controller: controller,
                    onChanged: (_) => setState(() {}),
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
                      hintText: 'Enter your user id',
                      hintStyle: normalSize14Text(AppColors.grey),
                      filled: true,
                      fillColor: AppColors.inputFill,
                    ),
                  ),
                  largeVerticalSizedBox,
                  MaterialButton(
                    onPressed: () async {
                      if (controller.text.isNotEmpty) {
                        setState(() {
                          isLoading = true;
                        });

                        try {
                          await SendbirdChat.connect(controller.text);

                          final OpenChannel openChannel =
                              await OpenChannel.getChannel(
                            channelUrl,
                          );
                          await openChannel.enter();
                          setState(() {
                            isLoading = false;
                          });
                          context.pushReplacementNamed(
                            Routes.chatPageRoute,
                            extra: controller.text,
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                            ),
                          );
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    },
                    elevation: 0,
                    padding: const EdgeInsets.all(18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: AppColors.customWhite,
                    child: Center(
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: AppColors.customBlack,
                            )
                          : Text(
                              'Continue',
                              style: veryBoldSize14Text(AppColors.customBlack),
                            ),
                    ),
                  ),
                  largeVerticalSizedBox,
                  InkWell(
                    onTap: () async {
                      setState(() {
                        isLoadingGuest = true;
                      });

                      try {
                        await SendbirdChat.connect(userId);

                        final OpenChannel openChannel =
                            await OpenChannel.getChannel(
                          channelUrl,
                        );
                        await openChannel.enter();
                        setState(() {
                          isLoadingGuest = false;
                        });
                        context.pushReplacementNamed(
                          Routes.chatPageRoute,
                          extra: userId,
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                          ),
                        );
                        setState(() {
                          isLoadingGuest = false;
                        });
                      }
                    },
                    child: isLoadingGuest
                        ? const CircularProgressIndicator(
                            color: AppColors.customWhite,
                          )
                        : Text(
                            'Continue as Guest',
                            style: veryBoldSize14Text(),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
