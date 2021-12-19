import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:message_socket_flutter/src/bloc/bloc_provider.dart';
import 'package:message_socket_flutter/src/bloc/auth_bloc.dart';
import 'package:message_socket_flutter/src/bloc/socket_bloc.dart';
import 'package:message_socket_flutter/src/page/home_page.dart';
import 'package:message_socket_flutter/src/page/main_page.dart';
import 'package:message_socket_flutter/src/page/signup_page.dart';
import 'package:message_socket_flutter/src/value/app_assets.dart';
import 'package:message_socket_flutter/src/value/app_color.dart';
import 'package:message_socket_flutter/src/value/app_font.dart';
import 'package:message_socket_flutter/src/widgets/dialogs/loading_dialog.dart';
import 'package:message_socket_flutter/src/widgets/dialogs/msg_dialog.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SignInPage extends StatefulWidget {
  //io.Socket socket;
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _show = false;
  late AuthBloc _authBloc;
  late SocketBloc _socketBloc;
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _authBloc = BlocProvider.of<AuthBloc>(context)!;
    _socketBloc = BlocProvider.of<SocketBloc>(context)!;
    super.initState();
    // print('socket: ' + widget.socket.toString());
    // print(widget.socket.connected);
    // _socketBloc.addSocket(widget.socket);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _authBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: const Text('Sign In'),
        backgroundColor: AppColor.secondColor,
        elevation: 0.0,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(top: 15.0),
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Image.asset(AppAssets.logo,
                            width: 70, height: 50, fit: BoxFit.contain),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'KMess',
                            style: AppStyle.h4.copyWith(color: Colors.green),
                          ),
                        )
                      ],
                    )),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  child: RichText(
                      text: TextSpan(
                          text: 'Welcome to my app, you ',
                          style: AppStyle.h5,
                          children: [
                        TextSpan(
                            text: 'must signed in',
                            style: AppStyle.h5.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 20))
                      ])),
                ),
                Container(
                    margin: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          //margin: const EdgeInsets.all(5.0),
                          child: TextField(
                            controller: _mailController,
                            style: AppStyle.h5.copyWith(color: Colors.white),
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.0, color: Colors.green)),
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.green,
                                ),
                                labelText: 'EMAIL',
                                labelStyle: AppStyle.h4
                                    .copyWith(color: AppColor.whiteGrey)),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          //height: 100,
                          //margin: const EdgeInsets.all(5.0),
                          child: Stack(
                            alignment: AlignmentDirectional.centerEnd,
                            children: [
                              TextField(
                                controller: _passController,
                                style:
                                    AppStyle.h5.copyWith(color: Colors.white),
                                obscureText: !_show,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1.0, color: Colors.green)),
                                    prefixIcon: const Icon(
                                      Icons.password,
                                      color: Colors.green,
                                    ),
                                    labelText: 'PASSWORD',
                                    labelStyle: AppStyle.h4
                                        .copyWith(color: AppColor.whiteGrey)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _show = !_show;
                                  });
                                },
                                child: _show
                                    ? Text(
                                        'HIDE  ',
                                        style: TextStyle(
                                            color: Colors.green[700],
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Text('SHOW  ',
                                        style: TextStyle(
                                            color: Colors.green[700],
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                              onPressed: () {
                                onSignIn();
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: AppColor.secondColor!),
                              child: Text(
                                'SIGN IN!',
                                style: AppStyle.h3,
                              )),
                        ),
                        RichText(
                          text: TextSpan(
                              text: "If you don't a account, you can ",
                              style: AppStyle.h5
                                  .copyWith(color: AppColor.blackGrey),
                              children: [
                                TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SignUpPage()));
                                      },
                                    text: 'Sign Up!',
                                    style: const TextStyle(
                                        color: Colors.green, fontSize: 16.0))
                              ]),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSignIn() {
    String _email = _mailController.text;
    String _password = _passController.text;

    LoadingDialog.showLoadingDialog(context, 'Loading.....');
    _authBloc.signIn(_email, _password, () {
      LoadingDialog.hideLoadingDialog(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MainPage()),
          (route) => false);
    }, (msg) {
      LoadingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialog(context, 'Sign In', msg);
    });
  }
}
