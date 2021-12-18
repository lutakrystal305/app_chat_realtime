import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:message_socket_flutter/src/model/client_model.dart';
import 'package:message_socket_flutter/src/model/room_model.dart';

class YourRoomFetched {
  Future<List<RoomModel>> fetchedYourRoom(String token, String idUser) async {
    //print(token + '   9999   ' + idUser);
    Map<String, String> headers = {'Authorization': token};
    Map<String, String> user = {'_id': idUser};
    final url = Uri.parse('https://chat-group-sv.herokuapp.com/chat/getRoom');
    var res = await http.post(url,
        body: {'user': jsonEncode(user)}, headers: headers);
    print(res.statusCode);
    if (res.statusCode == 200) {
      final parsed = jsonDecode(res.body);
      //print(parsed);
      final data = parsed['yourRoom']
          .map<RoomModel>((x) => RoomModel.fromJson(x))
          .toList();
      return data;
    } else {
      return [];
    }
  }

  Future<RoomModel> createRoom(String nameRoom, ClientModel user, String token,
      Function onSuccess) async {
    final url =
        Uri.parse('https://chat-group-sv.herokuapp.com/chat/createRoom');
    Map<String, String> headers = {'Authorization': token};
    var res = await http.post(url,
        body: {'nameRoom': nameRoom, 'user': jsonEncode(user.toJson())},
        headers: headers);
    if (res.statusCode == 200) {
      final parsed = jsonDecode(res.body);
      final data = RoomModel.fromJson(parsed);
      return data;
    } else {
      return RoomModel();
    }
  }

  Future<void> leaveRoom(RoomModel room, ClientModel user, String token,
      Function onSuccess, Function onErr) async {
    final url = Uri.parse('https://chat-group-sv.herokuapp.com/chat/leaveRoom');
    Map<String, String> headers = {'Authorization': token};
    var res = await http.post(url,
        body: {
          'room': jsonEncode(room.toJson()),
          'user': jsonEncode(user.toJson())
        },
        headers: headers);
    if (res.statusCode == 200) {
      onSuccess();
    } else {
      onErr();
    }
  }
}
