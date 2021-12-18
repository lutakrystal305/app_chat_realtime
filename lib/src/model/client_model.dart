//import 'package:message_socket_flutter/src/model/room_model.dart';

class ClientModel {
  String? id;
  String? name;
  String? gender;
  String? email;
  List? groups;
  ClientModel({this.id, this.name, this.gender, this.email, this.groups});

  ClientModel.fromJson(Map<String, dynamic> json) {
    //print(json['_id']);
    id = json['_id'];
    name = json['name'];
    gender = json['sex'];
    email = json['email'];
    groups = json['groups'];
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'gender': gender,
        'email': email,
        'groups': groups,
      };
}
