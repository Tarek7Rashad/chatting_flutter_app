import 'package:chat_flutter_app/shared/components/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String message;
  final String id;
  final Timestamp time;
  MessageModel(this.message, this.id, this.time);

  factory MessageModel.fromJson(jsonData) {
    return MessageModel(jsonData[kMessage], jsonData[kId], jsonData[kAt]);
  }
}
