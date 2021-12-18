import 'dart:convert';

//import 'package:message_socket_flutter/src/bloc/auth_bloc.dart';
import 'package:message_socket_flutter/src/bloc/bloc_provider.dart';
import 'package:message_socket_flutter/src/model/client_model.dart';
import 'package:rxdart/subjects.dart';
import 'package:http/http.dart' as http;

class AuthBloc implements BlocBase {
  final client = http.Client();
  //final _authBloc = AuthBloc();
  final _emailController = BehaviorSubject<String>();
  Stream<String> get email => _emailController.stream;
  final _passwordController = BehaviorSubject<String>();
  Stream<String> get password => _passwordController.stream;
  final _nameController = BehaviorSubject<String>();
  Stream<String> get name => _nameController.stream;
  final _phoneController = BehaviorSubject<String>();
  Stream<String> get phone => _phoneController.stream;
  final _genderController = BehaviorSubject<String>();
  Stream<String> get gender => _genderController.stream;
  final _tokenController = BehaviorSubject<String>();
  Stream<String> get tokenController => _tokenController.stream;
  String get tokenValue =>
      _tokenController.hasValue ? _tokenController.value : '';
  bool get tokenHasValue => _tokenController.hasValue;
  final _isAuthed = BehaviorSubject<bool>();
  Stream<bool> get isAuthedController => _isAuthed.stream;
  bool get isAuthed => _isAuthed.hasValue ? _isAuthed.value : false;
  final _userController = BehaviorSubject<ClientModel>();
  Stream<ClientModel> get userController => _userController.stream;
  ClientModel get user =>
      _userController.hasValue ? _userController.value : ClientModel(id: '1');

  bool isValid(String email, String pass) {
    // ignore: unnecessary_null_comparison
    if (!RegExp(r"^([a-z0-9]{6,25})?(@gmail.com)$").hasMatch(email)) {
      print('loi email');
      _emailController.sink.addError('Email is invalid!');
      _emailController.sink.add('');
      return false;
    }
    _emailController.sink.add(email);
    // ignore: unnecessary_null_comparison
    if (!RegExp(r"^([a-z0-9]{6,20})$").hasMatch(pass)) {
      print('loi pass');
      _passwordController.sink.addError('Password is invalid!');
      _passwordController.sink.add('');
      return false;
    }
    _passwordController.sink.add(pass);
    return true;
  }

  bool isValidSignUp(String email, String pass, String name) {
    if (!RegExp(r"^([a-zA-Z]{2,20})?$").hasMatch(name)) {
      print('loi name');
      _nameController.sink.addError('Name is invalid!');
      _nameController.sink.add('');
      return false;
    }
    _nameController.sink.add(name);
    _nameController.sink.addError('');
    // ignore: unnecessary_null_comparison
    if (!RegExp(r"^([a-z0-9]{6,25})?(@gmail.com)$").hasMatch(email)) {
      print('loi email');
      _emailController.sink.addError('Email is invalid!');
      _emailController.sink.add('');
      return false;
    }
    _emailController.sink.add(email);
    _emailController.sink.addError('');
    // ignore: unnecessary_null_comparison
    if (!RegExp(r"^([a-z0-9]{6,20})$").hasMatch(pass)) {
      print('loi pass');
      _passwordController.sink.addError('Password is invalid!');
      _passwordController.sink.add('');
      return false;
    }
    _passwordController.sink.add(pass);
    _passwordController.sink.addError('');
    return true;
  }

  void addToken(String data) {
    //print('token: ' + data);
    _tokenController.sink.add(data);
    //print(_tokenController.hasValue);
  }

  void checkAuthen(String token, Function onSuccess, Function onError) async {
    final url = Uri.parse('https://chat-group-sv.herokuapp.com/user/check');
    var res = await http.post(url, body: {'token': token});
    if (res.statusCode == 200) {
      final parsed = jsonDecode(res.body);
      //print(parsed);
      final user = ClientModel.fromJson(parsed);
      print('id user: ${user.id}');
      _isAuthed.sink.add(true);
      _userController.sink.add(user);
      //_tokenController.sink.add(token);
      onSuccess();
    } else {
      onError('Check authentication fail!!');
    }
  }

  void signIn(String email, String password, Function onSuccess,
      Function onError) async {
    if (!isValid(email, password)) {
      onError('Sign In error!!!');
      return;
    }
    final url = Uri.parse('https://chat-group-sv.herokuapp.com/user/login');
    var res = await client.post(url, body: {
      'email': _emailController.hasValue ? _emailController.value : '',
      'password': _passwordController.hasValue ? _passwordController.value : ''
    });
    if (res.statusCode == 200) {
      //print(res.body);
      final parsed = jsonDecode(res.body);
      //print(parsed);
      addToken(parsed['token']);
      checkAuthen(parsed['token'], onSuccess, onError);
    } else {
      onError('Sign in fail!!');
    }
  }

  void signUp(String name, String email, String password, String gender,
      Function onSuccess, Function onErr) async {
    if (!isValidSignUp(email, password, name)) {
      onErr(_nameController.hasError &&
              _nameController.error.toString().isNotEmpty
          ? _nameController.error
          : _emailController.hasError &&
                  _emailController.error.toString().isNotEmpty
              ? _emailController.error
              : _passwordController.hasError &&
                      _passwordController.error.toString().isNotEmpty
                  ? _passwordController.error
                  : 'Sign Up is wrong syntax!');
      return;
    }
    final url =
        Uri.parse('https://chat-group-sv.herokuapp.com:2707/user/create');
    var res = await client.post(url, body: {
      'name': name,
      'email': email,
      'pass': password,
      'gender': gender
    });
    if (res.statusCode == 200) {
      onSuccess();
    } else {
      print(res);
      onErr('Sign up fail');
    }
  }

  void dispose() {
    client.close();
    _emailController.close();
    //_isAuthed.close();
    _passwordController.close();
    //_tokenController.close();
    //_userController.close();
  }
}
