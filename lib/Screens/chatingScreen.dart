import 'package:chat_flutter_app/Widgets/chatMessage.dart';
import 'package:chat_flutter_app/models/messageModel.dart';
import 'package:chat_flutter_app/shared/components/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChattingScreen extends StatefulWidget {
  const ChattingScreen({super.key});

  static const String id = "ChatingPage";

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessageCollection);

  TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // MessageModel messageModel;
  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kAt, descending: true).snapshots(),
      builder: (context, snapshott) {
        if (snapshott.hasData) {
          List<MessageModel> messagesList = [];
          for (int i = 0; i < snapshott.data!.docs.length; i++) {
            messagesList.add(MessageModel.fromJson(snapshott.data!.docs[i]));
          }
          return Scaffold(
            backgroundColor: scaffoldChatScreenColor,
            appBar: AppBar(
              leading: Container(),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Row(
                    children: [
                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {},
                        child: const Icon(
                          Icons.add_ic_call_outlined,
                          size: 30,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.logout_rounded)),
                    ],
                  ),
                )
              ],
              toolbarHeight: 70,
              backgroundColor: kPrimaryColor,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    klogoImage,
                    height: 50,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Chating',
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      reverse: true,
                      controller: scrollController,
                      itemCount: messagesList.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return messagesList[index].id == email
                            ? ChatMessageFromSender(
                                messageModel: messagesList[index],
                              )
                            : ChatMessageFromReceiver(
                                messageModel: messagesList[index]);
                      }),
                ),
                Container(
                  width: double.infinity,
                  color: kThirdColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add,
                          size: 30,
                          color: kPrimaryColor,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: controller,
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                messages.add({
                                  "message": value,
                                  kAt: DateTime.now(),
                                  kId: email,
                                });
                              }
                              controller.clear();
                              // scrollController.jumpTo(
                              //     scrollController.position.maxScrollExtent);
                              scrollController.animateTo(
                                scrollController.position.minScrollExtent,
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.easeIn,
                              );
                            },
                            style: const TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                                hintText: "Send Message",
                                hintStyle: const TextStyle(fontSize: 18),
                                fillColor: kSecondryColor.withOpacity(0.6),
                                filled: true,
                                contentPadding: const EdgeInsets.only(left: 20),
                                constraints:
                                    const BoxConstraints(maxHeight: 40),
                                suffixIconColor: kPrimaryColor,
                                suffixIcon: IconButton(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 10),
                                  iconSize: 20,
                                  onPressed: () {},
                                  icon: const Icon(Icons.note_rounded),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100))),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Icon(
                          Icons.camera_alt_outlined,
                          size: 30,
                          color: kPrimaryColor,
                        ),
                        const Icon(
                          Icons.mic,
                          size: 30,
                          color: kPrimaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Scaffold();
        }
      },
    );
  }
}
