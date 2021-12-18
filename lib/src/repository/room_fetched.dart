import 'dart:convert';

import 'package:http/http.dart' as http;
//import 'package:message_socket_flutter/src/bloc/auth_bloc.dart';
import 'package:message_socket_flutter/src/bloc/auth_bloc.dart';
import 'package:message_socket_flutter/src/model/client_model.dart';
import 'package:message_socket_flutter/src/model/room_model.dart';

class RoomFetched {
  final _authBloc = AuthBloc();
  final client = http.Client;
  Future<List<RoomModel>> fetchData(String token) async {
    final url = Uri.parse('https://chat-group-sv.herokuapp.com/chat/getRooms');
    //print(token);
    Map<String, String> headers = {'Authorization': token};
    var res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      final parsed = jsonDecode(res.body);
      //print('vlxx' + parsed);
      final data = parsed.map<RoomModel>((x) => RoomModel.fromJson(x)).toList();

      return data;
    }
    return [];
  }

  Future<RoomModel> checkRoom(
      RoomModel x, ClientModel user, String token) async {
    final url = Uri.parse('https://chat-group-sv.herokuapp.com/chat/checkRoom');
    Map<String, String> headers = {'Authorization': token};
    var res = await http.post(url,
        body: {'user': jsonEncode(user.toJson()), '_id': x.id.toString()},
        headers: headers);
    if (res.statusCode == 200) {
      return x;
    } else {
      return RoomModel();
    }
  }
}
