// import 'package:message_socket_flutter/src/bloc/bloc_provider.dart';

// import 'package:http/http.dart' as http;
// import 'package:message_socket_flutter/src/model/room_model.dart';
// import 'package:message_socket_flutter/src/repository/your_rooms_fetched.dart';
// import 'package:rxdart/rxdart.dart';

// class CurrentRoomBloc implements BlocBase {
//   final _yourRoomFetched = YourRoomFetched();
//   final _currentRoomController = BehaviorSubject<RoomModel>();
//   Stream<RoomModel> get currentRoomController => _currentRoomController.stream;
//   RoomModel get currentRoom => _currentRoomController.hasValue
//       ? _currentRoomController.value
//       : RoomModel();
//   final _yourRoomsController = BehaviorSubject<List<RoomModel>>();
//   Stream<List<RoomModel>> get yourRoomsController =>
//       _yourRoomsController.stream;
//   List<RoomModel> get yourRoomsValue =>
//       _yourRoomsController.hasValue ? _yourRoomsController.value : [];
//   final _searchRoom = BehaviorSubject<List<RoomModel>>();
//   Stream<List<RoomModel>> get searchRoom => _searchRoom.stream;

//   void fetchYourRooms(String token, String idUser) async {
//     final data = await _yourRoomFetched.fetchedYourRoom(token, idUser);
//     _yourRoomsController.sink.add(data);
//   }

//   void onClickRoom(RoomModel x) {
//     _currentRoomController.sink.add(x);
//   }

//   void onSearchRoom(String a) {
//     if (a.isNotEmpty) {
//       List<RoomModel> y =
//           _yourRoomsController.hasValue && _yourRoomsController.value.isNotEmpty
//               ? _yourRoomsController.value
//                   .where((element) =>
//                       element.name!.toLowerCase().indexOf(a.toLowerCase()) >= 0)
//                   .toList()
//               : [];
//       _searchRoom.sink.add(y);
//     } else {
//       _searchRoom.sink.add([]);
//     }
//   }

//   void dispose() {}
// }
