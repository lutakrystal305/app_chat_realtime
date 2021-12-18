import 'dart:convert';

import 'package:message_socket_flutter/src/model/message_model.dart';

class RoomModel {
  String? id;
  List? members;
  String? name;
  MessageModel? topMess;
  String? host;
  String? update;
  String? avt;
  bool? isNoti;

  RoomModel(
      {this.id,
      this.members,
      this.name,
      this.topMess,
      this.host,
      this.update,
      this.avt,
      this.isNoti});

  RoomModel.fromJson(Map<String, dynamic> json) {
    //print('json: ' + json.toString());
    id = json['_id'];
    members = json['members'];
    name = json['name'];
    //print(MessageModel.fromJson(jsonDecode(json['topMess'])));
    topMess = MessageModel.fromJson(json['topMess']);
    host = json['host'];
    update = json['update'];
    avt = json['avt'];
  }
  Map<String, dynamic> toJson() => {
        '_id': id,
        'members': members,
        'name': name,
        'topMess': topMess!.toJson(),
        'host': host,
        'update': update,
        'avt': avt
      };
}
