import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:message_socket_flutter/src/bloc/bloc_provider.dart';
import 'package:message_socket_flutter/src/bloc/auth_bloc.dart';
import 'package:message_socket_flutter/src/bloc/socket_bloc.dart';
import 'package:message_socket_flutter/src/model/message_model.dart';
import 'package:message_socket_flutter/src/page/upload_img_page.dart';
import 'package:message_socket_flutter/src/value/app_color.dart';
import 'package:message_socket_flutter/src/value/app_font.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late SocketBloc _socketBloc;
  late AuthBloc _authBloc;
  GlobalKey _contentKey = GlobalKey();
  GlobalKey _refresherKey = GlobalKey();
  final _textController = TextEditingController();
  static const _pageSize = 10;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _socketBloc.addMore();
    print(true);
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 500));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _socketBloc.addMore();
    print(false);
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    // TODO: implement initState
    _socketBloc = BlocProvider.of<SocketBloc>(context)!;
    _authBloc = BlocProvider.of<AuthBloc>(context)!;
    print('name user2: ${_authBloc.user.name}');
    print('id user2: ${_authBloc.user.id}');

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _refreshController.dispose();
    _socketBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.secondColor,
          title: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UploadImgPage()));
            },
            child: Text(_socketBloc.currentRoomValue.name!.isNotEmpty
                ? _socketBloc.currentRoomValue.name!
                : ''),
          ),
        ),
        body: Container(
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              StreamBuilder(
                  stream: _socketBloc.currentMessageController,
                  builder:
                      (context, AsyncSnapshot<List<MessageModel>> snapshot) {
                    return snapshot.hasData && snapshot.data!.isNotEmpty
                        ? Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Color(0xff0d1117),
                            padding: const EdgeInsets.only(bottom: 50),
                            child: Scrollbar(
                              child: SmartRefresher(
                                key: _refresherKey,
                                //reverse: true,
                                enablePullDown: false,
                                enablePullUp: true,
                                controller: _refreshController,
                                onRefresh: _onRefresh,
                                onLoading: _onLoading,
                                child: ListView.separated(
                                  key: _contentKey,
                                  reverse: true,
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  itemBuilder: (c, i) => Container(
                                    width: double.infinity,
                                    //height: 50,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    alignment: snapshot.data![i].from != null &&
                                            _authBloc.user.id ==
                                                snapshot.data![i].from!.id
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,

                                    child: Column(
                                      crossAxisAlignment:
                                          snapshot.data![i].from != null &&
                                                  _authBloc.user.id ==
                                                      snapshot.data![i].from!.id
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            margin: const EdgeInsets.all(5.0),
                                            //alignment: Alignment.centerRight,
                                            child: Text(
                                                snapshot.data![i].from != null
                                                    ? snapshot
                                                        .data![i].from!.name!
                                                    : '',
                                                style: AppStyle.h5.copyWith(
                                                    color:
                                                        AppColor.whiteGrey))),
                                        Container(
                                          constraints: BoxConstraints(
                                              maxWidth: size.width / 2),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 10.0),
                                          decoration: BoxDecoration(
                                              color: snapshot.data![i].from !=
                                                          null &&
                                                      _authBloc.user.id ==
                                                          snapshot
                                                              .data![i].from!.id
                                                  ? Colors.green
                                                  : AppColor.whiteGrey,
                                              border: Border.all(
                                                  width: 1,
                                                  color: AppColor.whiteGrey),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(16))),
                                          child: snapshot.data![i].message !=
                                                  null
                                              ? Text(
                                                  snapshot.data![i].message!,
                                                  style: AppStyle.h5,
                                                )
                                              : Container(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  separatorBuilder: (context, index) =>
                                      Container(),
                                  itemCount: snapshot.data!.length,
                                ),
                              ),
                            ))
                        : Container(
                            color: Color(0xff0d1117),
                            child: Center(child: CircularProgressIndicator()));
                  }),
              Container(
                //padding: EdgeInsets.only(
                //    bottom: MediaQuery.of(context).viewInsets.bottom),
                width: double.infinity,
                height: 50.0,
                color: Color(0xffdddddd),
                child: SingleChildScrollView(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: TextField(
                          controller: _textController,
                          style: AppStyle.h5.copyWith(color: Colors.black),
                          decoration: const InputDecoration(
                              contentPadding: const EdgeInsets.all(5.0)),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.green[200]),
                          child: IconButton(
                            onPressed: () {
                              //print(_authBloc.user);
                              final a = _textController.text;
                              _textController.clear();
                              _socketBloc.emitMessage(MessageModel(
                                message: a,
                                from: _authBloc.user,
                                to: _socketBloc.currentRoomValue.id,
                              ));
                            },
                            icon: Icon(Icons.navigate_next),
                            color: Colors.green,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
