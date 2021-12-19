import 'package:flutter/material.dart';
//import 'package:message_socket_flutter/src/bloc/auth_bloc.dart';
import 'package:message_socket_flutter/src/bloc/bloc_provider.dart';
import 'package:message_socket_flutter/src/bloc/group_bloc.dart';
import 'package:message_socket_flutter/src/bloc/auth_bloc.dart';
import 'package:message_socket_flutter/src/bloc/socket_bloc.dart';
import 'package:message_socket_flutter/src/model/room_model.dart';
import 'package:message_socket_flutter/src/page/chat_page.dart';
import 'package:message_socket_flutter/src/repository/room_fetched.dart';
import 'package:message_socket_flutter/src/value/app_assets.dart';
import 'package:message_socket_flutter/src/value/app_color.dart';
import 'package:message_socket_flutter/src/value/app_font.dart';
import 'package:message_socket_flutter/src/widgets/dialogs/loading_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _roomFetched = RoomFetched();
  final _searchController = TextEditingController();
  late AuthBloc _authBloc;
  late GroupBloc _groupBloc;
  late SocketBloc _socketBloc;
  @override
  void initState() {
    // TODO: implement initState
    _groupBloc = BlocProvider.of<GroupBloc>(context)!;
    _authBloc = BlocProvider.of<AuthBloc>(context)!;
    _socketBloc = BlocProvider.of<SocketBloc>(context)!;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (!_authBloc.isAuthed) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _authBloc.dispose();
    _groupBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: Stack(
        children: [
          Image.asset(
            AppAssets.bgHome,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(5.0),
            margin: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      'Rooms are available: ',
                      style: AppStyle.h4.copyWith(
                          color: const Color(0xff7a82d6).withOpacity(0.8)),
                    )),
                StreamBuilder(
                    stream: _socketBloc.heightController,
                    builder: (context, AsyncSnapshot<double> snapshotHeight) {
                      return Container(
                        height: snapshotHeight.hasData
                            ? height - snapshotHeight.data! - 80
                            : height - 250,
                        child: SingleChildScrollView(
                          child: StreamBuilder(
                              stream: _groupBloc.groupController,
                              builder: (context,
                                  AsyncSnapshot<List<RoomModel>> snapshot) {
                                return snapshot.hasData &&
                                        snapshot.data!.isNotEmpty
                                    ? StreamBuilder(
                                        stream: _groupBloc.searchRoom,
                                        builder: (context,
                                            AsyncSnapshot<List<RoomModel>>
                                                snapshot1) {
                                          var listItem = snapshot1.hasData &&
                                                  snapshot1.data!.isNotEmpty
                                              ? snapshot1.data
                                              : snapshot.data!;
                                          return Column(
                                            children: listItem!
                                                .map((e) => GestureDetector(
                                                      onTap: () async {
                                                        LoadingDialog
                                                            .showLoadingDialog(
                                                                context,
                                                                'Entering Room!');
                                                        //check room
                                                        final data =
                                                            await _roomFetched
                                                                .checkRoom(
                                                                    e,
                                                                    _authBloc
                                                                        .user,
                                                                    _authBloc
                                                                        .tokenValue);
                                                        if (data.id != null) {
                                                          _socketBloc
                                                              .addRoom(data);
                                                          _socketBloc.emitRoomNow(
                                                              e,
                                                              _authBloc
                                                                  .tokenValue,
                                                              () {
                                                            LoadingDialog
                                                                .hideLoadingDialog(
                                                                    context);
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ChatPage()));
                                                            //hideloading, navigator
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: 80,
                                                        margin: const EdgeInsets
                                                                .symmetric(
                                                            vertical: 5.0,
                                                            horizontal: 10.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color: AppColor
                                                                  .whiteGrey),
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          16.0)),
                                                          color: Colors.white
                                                              .withOpacity(0.6),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Expanded(
                                                                child:
                                                                    Container(
                                                                  width: 50,
                                                                  height: 50,
                                                                  clipBehavior:
                                                                      Clip.antiAlias,
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      border: Border.all(
                                                                          width:
                                                                              2,
                                                                          color:
                                                                              AppColor.whiteGrey)),
                                                                  child: Image
                                                                      .network(
                                                                    e.avt !=
                                                                            null
                                                                        ? e.avt!
                                                                        : "https://toigingiuvedep.vn/wp-content/uploads/2021/05/hinh-anh-minh-hoa-nhom-620x600.jpg",
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    width: double
                                                                        .infinity,
                                                                    height: double
                                                                        .infinity,
                                                                  ),
                                                                ),
                                                                flex: 1),
                                                            Expanded(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    e.name!,
                                                                    style: AppStyle
                                                                        .h4
                                                                        .copyWith(
                                                                            color:
                                                                                const Color(0xff333333)),
                                                                  ),
                                                                  RichText(
                                                                      text: TextSpan(
                                                                          text:
                                                                              'Host: ',
                                                                          style: const TextStyle(
                                                                              fontSize: 13,
                                                                              color: AppColor.blackGrey),
                                                                          children: [
                                                                        TextSpan(
                                                                            text: e.host!.isNotEmpty
                                                                                ? e.host!
                                                                                : 'Anonymous',
                                                                            style: const TextStyle(fontSize: 13, color: AppColor.blackGrey, fontStyle: FontStyle.italic))
                                                                      ]))
                                                                ],
                                                              ),
                                                              flex: 3,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                          );
                                        })
                                    : Container(
                                        width: 100,
                                        height: 100,
                                        alignment: Alignment.center,
                                        child:
                                            const CircularProgressIndicator());
                              }),
                        ),
                      );
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
