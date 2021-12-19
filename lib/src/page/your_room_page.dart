//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:message_socket_flutter/src/bloc/bloc_provider.dart';
import 'package:message_socket_flutter/src/bloc/current_room_bloc.dart';
import 'package:message_socket_flutter/src/bloc/group_bloc.dart';
import 'package:message_socket_flutter/src/bloc/auth_bloc.dart';
import 'package:message_socket_flutter/src/bloc/socket_bloc.dart';
import 'package:message_socket_flutter/src/model/room_model.dart';
import 'package:message_socket_flutter/src/page/chat_page.dart';
import 'package:message_socket_flutter/src/repository/your_rooms_fetched.dart';
import 'package:message_socket_flutter/src/value/app_assets.dart';
import 'package:message_socket_flutter/src/value/app_color.dart';
import 'package:message_socket_flutter/src/value/app_font.dart';
import 'package:message_socket_flutter/src/widgets/dialogs/loading_dialog.dart';
import 'package:message_socket_flutter/src/widgets/dialogs/msg_dialog.dart';

class YourRoomPage extends StatefulWidget {
  const YourRoomPage({Key? key}) : super(key: key);

  @override
  _YourRoomPageState createState() => _YourRoomPageState();
}

class _YourRoomPageState extends State<YourRoomPage> {
  final _yourRoomFetched = YourRoomFetched();
  late AuthBloc _authBloc;
  late GroupBloc _groupBloc;
  //late CurrentRoomBloc _currentRoomBloc;
  late SocketBloc _socketBloc;

  @override
  void initState() {
    // TODO: implement initState
    _authBloc = BlocProvider.of<AuthBloc>(context)!;
    //_currentRoomBloc = BlocProvider.of<CurrentRoomBloc>(context)!;
    _groupBloc = BlocProvider.of<GroupBloc>(context)!;
    _socketBloc = BlocProvider.of<SocketBloc>(context)!;
    super.initState();
    _socketBloc.createSocket(_authBloc.tokenValue);
    print(_authBloc.user.name);
    print(_authBloc.user.id);
    print(_authBloc.tokenValue);
    if (_socketBloc.yourRoomsValue.isEmpty) {
      _socketBloc.fetchYourRooms(_authBloc.tokenValue, _authBloc.user.id!);
    }
    _groupBloc.fetchGroup(_authBloc.tokenValue);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final _currentRoomBloc = BlocProvider.of<CurrentRoomBloc>(context);
    double bottomBar_height = MediaQuery.of(context).padding.bottom;
    print('height: $bottomBar_height');
    final _authoc = BlocProvider.of<AuthBloc>(context);
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: Stack(
        children: [
          Image.asset(
            AppAssets.bg1,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(5.0),
            margin: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                Text('Your Rooms: '),
                StreamBuilder(
                    stream: _socketBloc.yourRoomsController,
                    builder:
                        (context, AsyncSnapshot<List<RoomModel>> snapshot) {
                      return snapshot.hasData && snapshot.data!.isNotEmpty
                          ? StreamBuilder(
                              stream: _socketBloc.searchRoom,
                              builder: (context,
                                  AsyncSnapshot<List<RoomModel>> snapshot1) {
                                var listItem = snapshot1.hasData &&
                                        snapshot1.data!.isNotEmpty
                                    ? snapshot1.data
                                    : snapshot.data!;
                                return StreamBuilder(
                                    stream: _socketBloc.heightController,
                                    builder: (context,
                                        AsyncSnapshot<double> snapshotHeight) {
                                      return Container(
                                        margin: const EdgeInsets.only(top: 20),
                                        height: snapshotHeight.hasData
                                            ? height - snapshotHeight.data! - 75
                                            : height - 250,
                                        child: SingleChildScrollView(
                                          child: Column(
                                              children: listItem != null
                                                  ? listItem.reversed
                                                      .toList()
                                                      .map(
                                                          (e) =>
                                                              GestureDetector(
                                                                onLongPress:
                                                                    () {
                                                                  showModalBottomSheet(
                                                                      context:
                                                                          context,
                                                                      builder: (BuildContext
                                                                              context) =>
                                                                          Container(
                                                                            height:
                                                                                200,
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                                                            color:
                                                                                AppColor.primaryColor,
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Container(
                                                                                  padding: const EdgeInsets.only(bottom: 5.0),
                                                                                  child: Text(
                                                                                    'Leaving room!',
                                                                                    style: AppStyle.h4,
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  width: 30,
                                                                                  height: 50,
                                                                                  decoration: const BoxDecoration(
                                                                                    shape: BoxShape.circle,
                                                                                    //color: Colors.blueAccent,
                                                                                  ),
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  child: e.avt != null && e.avt!.isNotEmpty
                                                                                      ? Image.network(e.avt!, width: double.infinity, height: double.infinity, fit: BoxFit.cover)
                                                                                      : Container(
                                                                                          color: Colors.green,
                                                                                        ),
                                                                                ),
                                                                                Container(
                                                                                  padding: const EdgeInsets.all(5.0),
                                                                                  child: Text(
                                                                                    e.name!,
                                                                                    style: AppStyle.h5,
                                                                                  ),
                                                                                ),
                                                                                Center(
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      TextButton(
                                                                                          onPressed: () {
                                                                                            print('leaving success');
                                                                                            LoadingDialog.showLoadingDialog(context, 'Leaving room!');
                                                                                            _yourRoomFetched.leaveRoom(e, _authBloc.user, _authBloc.tokenValue, () {
                                                                                              _socketBloc.fetchYourRooms(_authBloc.tokenValue, _authBloc.user.id!);
                                                                                              Navigator.pop(context);
                                                                                              LoadingDialog.hideLoadingDialog(context);
                                                                                            }, () {
                                                                                              print('leaving fail!');
                                                                                              Navigator.pop(context);
                                                                                              LoadingDialog.hideLoadingDialog(context);
                                                                                              MsgDialog.showMsgDialog(context, 'Leaving room!', 'Leave fail');
                                                                                            });
                                                                                          },
                                                                                          child: Text('OK')),
                                                                                      TextButton(
                                                                                          onPressed: () {
                                                                                            Navigator.pop(context);
                                                                                          },
                                                                                          child: Text('No'))
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ));
                                                                },
                                                                onTap: () {
                                                                  _socketBloc
                                                                      .emitRoomNow(
                                                                          e,
                                                                          _authoc!
                                                                              .tokenValue,
                                                                          () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                ChatPage()));
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: double
                                                                      .infinity,
                                                                  height: 80,
                                                                  margin: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          5.0),
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          20.0,
                                                                      vertical:
                                                                          10.0),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          color: Colors.white.withOpacity(
                                                                              0.3),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                                offset: Offset(1, 2),
                                                                                color: AppColor.whiteGrey.withOpacity(0.2),
                                                                                blurRadius: 5.0)
                                                                          ],
                                                                          border: const Border(
                                                                              top: BorderSide(width: 1, color: AppColor.whiteGrey),
                                                                              bottom: BorderSide(width: 1, color: AppColor.whiteGrey))),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Expanded(
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                50,
                                                                            height:
                                                                                50,
                                                                            clipBehavior:
                                                                                Clip.antiAlias,
                                                                            decoration:
                                                                                BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 2, color: AppColor.whiteGrey)),
                                                                            child:
                                                                                Image.network(
                                                                              "https://toigingiuvedep.vn/wp-content/uploads/2021/05/hinh-anh-minh-hoa-nhom-620x600.jpg",
                                                                              fit: BoxFit.cover,
                                                                              width: double.infinity,
                                                                              height: double.infinity,
                                                                            ),
                                                                          ),
                                                                          flex:
                                                                              1),
                                                                      Expanded(
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              e.name!,
                                                                              style: AppStyle.h4.copyWith(color: const Color(0xff333333)),
                                                                            ),
                                                                            RichText(
                                                                                overflow: TextOverflow.ellipsis,
                                                                                maxLines: 1,
                                                                                text: TextSpan(text: e.topMess != null ? '${e.topMess!.from!.name}: ' : '', style: const TextStyle(fontSize: 13, color: AppColor.blackGrey), children: [
                                                                                  TextSpan(text: e.topMess != null ? e.topMess!.message : 'xxxx', style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 13, color: e.isNoti != null && e.isNoti == true ? Colors.red[700] : AppColor.blackGrey, fontStyle: FontStyle.italic))
                                                                                ]))
                                                                          ],
                                                                        ),
                                                                        flex: 3,
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ))
                                                      .toList()
                                                  : []),
                                        ),
                                        //),
                                      );
                                    });
                              })
                          : Container(
                              width: 100,
                              height: 100,
                              alignment: Alignment.center,
                              child: CircularProgressIndicator());
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
