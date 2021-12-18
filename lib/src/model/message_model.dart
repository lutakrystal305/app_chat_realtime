import 'dart:convert';

import 'package:http/http.dart';
import 'package:message_socket_flutter/src/model/client_model.dart';

class MessageModel {
  String? id;
  String? message;
  ClientModel? from;
  String? to;
  bool isNotify = false;
  String? date;

  MessageModel({this.id, this.message, this.from, this.to, this.date});

  MessageModel.fromJson(Map<String, dynamic> json) {
    //print('nhu ccc');
    //print('json111: ' + json.toString());
    id = json['_id'];
    message = json['message'];
    from = ClientModel.fromJson(json['from']);
    to = json['to'];
    isNotify = json['isNotify'] ?? false;
    date = json['date'];
  }
  Map<String, dynamic> toJson() => {
        '_id': id,
        'message': message,
        'from': from!.toJson(),
        'to': to,
        'date': date
      };
}
