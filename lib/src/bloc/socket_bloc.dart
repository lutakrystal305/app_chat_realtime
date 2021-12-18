import 'dart:convert';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:message_socket_flutter/src/bloc/bloc_provider.dart';
import 'package:message_socket_flutter/src/model/client_model.dart';
import 'package:message_socket_flutter/src/model/message_model.dart';
import 'package:message_socket_flutter/src/model/room_model.dart';
import 'package:message_socket_flutter/src/repository/get_message.dart';
import 'package:message_socket_flutter/src/repository/room_fetched.dart';
import 'package:message_socket_flutter/src/repository/up_message.dart';
import 'package:message_socket_flutter/src/repository/your_rooms_fetched.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:http/http.dart' as http;

class SocketBloc implements BlocBase {
  final _upMessage = UpMessage();
  final _getMessage = GetMessage();
  final _yourRoomFetched = YourRoomFetched();
  final _yourRoomsController = BehaviorSubject<List<RoomModel>>();
  Stream<List<RoomModel>> get yourRoomsController =>
      _yourRoomsController.stream;
  List<RoomModel> get yourRoomsValue =>
      _yourRoomsController.hasValue ? _yourRoomsController.value : [];
  final _searchRoom = BehaviorSubject<List<RoomModel>>();
  Stream<List<RoomModel>> get searchRoom => _searchRoom.stream;
  final _newRoom = BehaviorSubject<RoomModel>();
  RoomModel get newRoom => _newRoom.hasValue ? _newRoom.value : RoomModel();
  final _socketController = BehaviorSubject<io.Socket>();
  io.Socket get socket => _socketController.hasValue
      ? _socketController.value
      : io.io('https://chat-group-sv.herokuapp.com',
          io.OptionBuilder().setTransports(['polling']));

  final _messagesController = BehaviorSubject<List<MessageModel>>();
  Stream<List<MessageModel>> get messagesController =>
      _messagesController.stream;
  final _currentMessageController = BehaviorSubject<List<MessageModel>>();
  List<MessageModel> get messagesValue =>
      _messagesController.hasValue ? _messagesController.value : [];
  Stream<List<MessageModel>> get currentMessageController =>
      _currentMessageController.stream;
  List<MessageModel> get currentMessageValue =>
      _currentMessageController.hasValue ? _currentMessageController.value : [];
  final _currentRoom = BehaviorSubject<RoomModel>();
  Stream<RoomModel> get currentRoom => _currentRoom.stream;
  RoomModel get currentRoomValue =>
      _currentRoom.hasValue ? _currentRoom.value : RoomModel();
  final _pagingController =
      BehaviorSubject<PagingController<int, MessageModel>>();
  final _tokenController = BehaviorSubject<String>();
  final _heightController = BehaviorSubject<double>();
  Stream<double> get heightController => _heightController.stream;

  void createSocket(String token) {
    _tokenController.sink.add(token);
    io.Socket? socketService;
    socketService = io.io(
        'https://chat-group-sv.herokuapp.com',
        io.OptionBuilder().setTransports(['websocket'])
            //    .disableAutoConnect()
            .build());
    _socketController.sink.add(socketService);
    print('connected:' + socket.connected.toString());
    //socket.connect();
    socket.onConnect((_) {
      print('connect');
    });
    socket.on('connected', (data) => print('connected'));
    socket.on('server-send-message', (data) {
      data['from']['_id'] = data['from']['id'];
      print('sever-message: $data');
      print('server send message');
      List<MessageModel> a = currentMessageValue;
      List<MessageModel> b = messagesValue;
      MessageModel c = MessageModel.fromJson(data);
      List<RoomModel> items = _yourRoomsController.value;
      int i = items.indexWhere((element) => element.id == c.to);
      if (i >= 0) {
        items[i].topMess = c;
      }
      if (c.to != currentRoomValue.id) {
        items[i].isNoti = true;
      } else {
        a.insert(0, c);
        b.insert(0, c);
        _currentMessageController.sink.add(a);
        items[i].isNoti = false;
        //_messagesController.sink.add(b);
      }
      final RoomModel j = items.removeAt(i);
      items.add(j);
      _yourRoomsController.sink.add(items);
      _upMessage.upMessage(
          c, _tokenController.hasValue ? _tokenController.value : '1');
    });
    socket.onDisconnect((_) => print('disconnect'));
  }

  void emitMessage(MessageModel x) {
    final encoder = jsonEncode(x.toJson());
    //print('encoder: $encoder');
    _socketController.value.emit('client-send-message', encoder);
  }

  void addSocket(io.Socket x) {
    _socketController.sink.add(x);
  }

  void emitRoomNow(RoomModel x, String token, Function enterRoom) async {
    print('connected1: ' + _socketController.value.connected.toString());
    _currentRoom.sink.add(x);
    _socketController.value.emit('client-send-room-now', {'_id': x.id});
    enterRoom();
    final data = await _getMessage.fetchData(x, token);
    if (data.isNotEmpty) {
      _messagesController.sink.add(data);
      print('xxx');
      int length = data.length;
      if (length >= 10) {
        //print(data.sublist(0, 9).length);
        _currentMessageController.sink.add(data.sublist(0, 9));
      } else {
        _currentMessageController.sink.add(data.sublist(0, length));
        //print(data.sublist(0, length).length);
      }
    }
  }

  void addRoom(RoomModel x) {
    List<RoomModel> y = _yourRoomsController.value;
    y.insert(0, x);
    _yourRoomsController.sink.add(y);
  }

  void addMore() {
    try {
      List<MessageModel> items =
          _messagesController.hasValue ? _messagesController.value : [];
      int length = items.length;
      int currentLength = currentMessageValue.length;
      List<MessageModel> a;
      if (currentLength + 10 < length) {
        a = currentLength > 0
            ? items.sublist(0, currentLength + 10)
            : _currentMessageController.value;
      } else {
        a = currentLength > 0
            ? items.sublist(0, length)
            : _currentMessageController.value;
      }
      //print(a[0].message);
      _currentMessageController.sink.add(a);
    } catch (error) {
      print(error);
    }
  }

  void addHeight(double height1, double height2) {
    _heightController.sink.add(height1 + height2);
  }

  void onCreateRoom(
      String nameRoom, ClientModel user, Function onSuccess) async {
    final data = await _yourRoomFetched.createRoom(
        nameRoom, user, _tokenController.value, onSuccess);
    if (data.id != null) {
      final items = yourRoomsValue;
      items.insert(0, data);
      _yourRoomsController.sink.add(items);
      emitRoomNow(data, _tokenController.value, onSuccess);
    }
  }

  void fetchYourRooms(String token, String idUser) async {
    final data = await _yourRoomFetched.fetchedYourRoom(token, idUser);
    if (data.isNotEmpty) {
      _yourRoomsController.sink.add(data);
    }
  }

  void onSearchRoom(String a) {
    if (a.isNotEmpty) {
      List<RoomModel> y =
          _yourRoomsController.hasValue && _yourRoomsController.value.isNotEmpty
              ? _yourRoomsController.value
                  .where((element) =>
                      element.name!.toLowerCase().indexOf(a.toLowerCase()) >= 0)
                  .toList()
              : [];
      _searchRoom.sink.add(y);
    } else {
      _searchRoom.sink.add([]);
    }
  }

  void uploadImg(String path, String idUser, Function onSuccess) async {
    final url = Uri.parse('https://chat-group-sv.herokuapp.com/chat/upAvt');
    Map<String, String> headers = {'Authorization': _tokenController.value};
    var res = await http.post(url,
        body: {'data': path, '_id': currentRoomValue.id.toString()},
        headers: headers);
    if (res.statusCode == 200) {
      fetchYourRooms(_tokenController.value, idUser);
      onSuccess();
    } else {}
  }

  @override
  void dispose() {
    _currentMessageController.sink.add([]);
    _messagesController.sink.add([]);
    _pagingController.close();
    //_groupController.close();
    _searchRoom.close();
    // TODO: implement dispose
  }
}
