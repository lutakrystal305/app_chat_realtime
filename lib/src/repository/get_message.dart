import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:message_socket_flutter/src/model/message_model.dart';
import 'package:message_socket_flutter/src/model/room_model.dart';

class GetMessage {
  final client = http.Client;
  Future<List<MessageModel>> fetchData(RoomModel x, String token) async {
    //final url = Uri.parse('https://chat-group-sv.herokuapp.com/chat/getRooms');
    //print(token);
    Map<String, String> headers = {'Authorization': token};
    final url = Uri.parse('https://chat-group-sv.herokuapp.com/chat/message');
    var res = await http.post(url,
        body: {
          'group': jsonEncode({'_id': x.id})
        },
        headers: headers);
    if (res.statusCode == 200) {
      final parsed = jsonDecode(res.body);
      final data =
          parsed.map<MessageModel>((x) => MessageModel.fromJson(x)).toList();
      return data;
    }
    return [];
  }
}
