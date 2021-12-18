import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:message_socket_flutter/src/model/message_model.dart';
import 'package:message_socket_flutter/src/model/room_model.dart';

class UpMessage {
  final client = http.Client;
  void upMessage(MessageModel x, String token) async {
    //final url = Uri.parse('https://chat-group-sv.herokuapp.com/chat/getRooms');
    //print(token);
    final url = Uri.parse('https://chat-group-sv.herokuapp.com/chat/upMess');
    Map<String, String> headers = {'Authorization': token};
    var a = jsonEncode(x.toJson());
    print('encoder message: $a');
    print('encoder from: ${jsonEncode(x.from!.toJson())}');
    var res = await http.post(url,
        body: {
          'message': x.message.toString(),
          'to': x.to.toString(),
          'from': jsonEncode(x.from!.toJson())
        },
        headers: headers);
    if (res.statusCode == 200) {
      print('Up message success');
    }
  }
}
