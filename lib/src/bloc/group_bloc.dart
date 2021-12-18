import 'dart:convert';

//import 'package:message_socket_flutter/src/bloc/auth_bloc.dart';
import 'package:message_socket_flutter/src/bloc/bloc_provider.dart';
import 'package:message_socket_flutter/src/model/room_model.dart';
import 'package:message_socket_flutter/src/repository/room_fetched.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class GroupBloc implements BlocBase {
  final _roomFetched = RoomFetched();
  final client = http.Client;
  final _groupController = BehaviorSubject<List<RoomModel>>();
  Stream<List<RoomModel>> get groupController => _groupController.stream;
  final _searchRoom = BehaviorSubject<List<RoomModel>>();
  Stream<List<RoomModel>> get searchRoom => _searchRoom.stream;

  void fetchGroup(String token) async {
    final data = await _roomFetched.fetchData(token);
    //print(data);
    _groupController.sink.add(data);
  }

  // void onClickGroup(RoomModel x) {
  //   _currentRoom.sink.add(x);
  // }

  void onSearchRoom(String a) {
    if (a.isNotEmpty) {
      List<RoomModel> y =
          _groupController.hasValue && _groupController.value.isNotEmpty
              ? _groupController.value
                  .where((element) =>
                      element.name!.toLowerCase().indexOf(a.toLowerCase()) >= 0)
                  .toList()
              : [];
      _searchRoom.sink.add(y);
    } else {
      _searchRoom.sink.add([]);
    }
  }

  void dispose() {
    //_groupController.close();
    _searchRoom.close();
  }
}
