import 'package:flutter/material.dart';
import 'package:message_socket_flutter/src/bloc/bloc_provider.dart';
import 'package:message_socket_flutter/src/bloc/current_room_bloc.dart';
import 'package:message_socket_flutter/src/bloc/group_bloc.dart';
import 'package:message_socket_flutter/src/bloc/auth_bloc.dart';
import 'package:message_socket_flutter/src/bloc/socket_bloc.dart';
import 'package:message_socket_flutter/src/page/home_page.dart';
import 'package:message_socket_flutter/src/page/your_room_page.dart';
import 'package:message_socket_flutter/src/value/app_color.dart';
import 'package:message_socket_flutter/src/value/app_font.dart';
import 'package:message_socket_flutter/src/widgets/dialogs/loading_dialog.dart';

import 'chat_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _keyBottomTab = GlobalKey();
  late AuthBloc _authBloc;
  late GroupBloc _groupBloc;
  late SocketBloc _socketBloc;
  final _newRoomController = TextEditingController();
  final _searchController = TextEditingController();
  bool _onSearch = false;
  int route = 0;

  static final List<Widget> _optionWidget = <Widget>[
    YourRoomPage(),
    HomePage(),
  ];
  @override
  void initState() {
    _socketBloc = BlocProvider.of<SocketBloc>(context)!;
    _authBloc = BlocProvider.of<AuthBloc>(context)!;
    // TODO: implement initState
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      leading: IconButton(
        onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text('Create room chat:'),
                  content: TextField(
                      style: AppStyle.h5.copyWith(color: Colors.black),
                      controller: _newRoomController,
                      decoration: InputDecoration(
                          labelText: 'Name room',
                          labelStyle:
                              AppStyle.h4.copyWith(color: Colors.green))),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () {
                          LoadingDialog.showLoadingDialog(
                              context, 'Create Room Chat');

                          _socketBloc.onCreateRoom(
                              _newRoomController.text, _authBloc.user, () {
                            LoadingDialog.hideLoadingDialog(context);
                            _newRoomController.clear();
                            Navigator.pop(context, 'Create');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatPage()));
                          });
                        },
                        child: const Text('Create'))
                  ],
                )),
        icon: Icon(Icons.add),
      ),
      actions: [
        !_onSearch
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _onSearch = true;
                  });
                },
                icon: const Icon(Icons.search))
            : Container(
                width: 100,
                height: 30,
                child: TextField(
                  controller: _searchController,
                  onChanged: (text) {
                    if (route == 0) {
                      _socketBloc.onSearchRoom(text);
                    } else {
                      _groupBloc.onSearchRoom(text);
                    }
                  },
                  style: AppStyle.h5.copyWith(color: Colors.black),
                ),
              )
      ],
      title: Center(child: Text(route == 0 ? 'Your Rooms' : 'All Rooms')),
      backgroundColor: AppColor.secondColor,
    );
    BottomNavigationBar bottomNavigationBar = BottomNavigationBar(
      key: _keyBottomTab,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Yours'),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: 'All')
      ],
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xff0d1117).withOpacity(0.9),
      currentIndex: route,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey[200]!.withOpacity(0.6),
      onTap: (value) => setState(() {
        route = value;
      }),
    );
    //double bottomBar_height = _keyBottomTab.currentContext!.size!.height;
    double appBar_height = appBar.preferredSize.height;
    //print('height: $bottomBar_height');
    _socketBloc.addHeight(appBar_height, appBar_height + 20);
    return Scaffold(
      appBar: appBar,
      body: _optionWidget[route],
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
