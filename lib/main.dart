import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:message_socket_flutter/src/bloc/bloc_provider.dart';
import 'package:message_socket_flutter/src/bloc/current_room_bloc.dart';
import 'package:message_socket_flutter/src/bloc/group_bloc.dart';
import 'package:message_socket_flutter/src/bloc/auth_bloc.dart';
import 'package:message_socket_flutter/src/bloc/socket_bloc.dart';
import 'package:message_socket_flutter/src/page/login_page.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

void main() {
  final _socketBloc = SocketBloc();
  // io.Socket? socket;
  // socket = io.io(
  //     'http://localhost:2707',
  //     io.OptionBuilder().setTransports(['websocket'])
  //         //    .disableAutoConnect()
  //         .build());
  // print('connected:' + socket.connected.toString());
  // //socket.connect();
  // socket.onConnect((_) {
  //   print('connect');
  // });
  // socket.on('connected', (data) => print('connected'));
  // socket.on('server-send-message', (data) => {});
  // socket.onDisconnect((_) => print('disconnect'));

  final _authBloc = AuthBloc();
  final _groupBloc = GroupBloc();
  //final _currentRoomBloc = CurrentRoomBloc();
  runApp(BlocProvider(
    child: BlocProvider(
        child: BlocProvider(
          child: MaterialApp(
            home: SignInPage(),
            debugShowCheckedModeBanner: false,
          ),
          bloc: _groupBloc,
        ),
        bloc: _authBloc),
    bloc: _socketBloc,
  ));
}
