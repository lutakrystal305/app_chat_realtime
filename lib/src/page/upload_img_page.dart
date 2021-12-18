import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:message_socket_flutter/src/bloc/auth_bloc.dart';
import 'package:message_socket_flutter/src/bloc/bloc_provider.dart';
import 'package:message_socket_flutter/src/bloc/socket_bloc.dart';
import 'package:message_socket_flutter/src/model/room_model.dart';
import 'package:message_socket_flutter/src/value/app_color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:message_socket_flutter/src/value/app_font.dart';
import 'package:message_socket_flutter/src/widgets/dialogs/loading_dialog.dart';

class UploadImgPage extends StatefulWidget {
  const UploadImgPage({Key? key}) : super(key: key);

  @override
  _UploadImgPageState createState() => _UploadImgPageState();
}

class _UploadImgPageState extends State<UploadImgPage> {
  final _picker = ImagePicker();
  final cloudinary = CloudinaryPublic('den6tpnab', 'chat_default',
      cache: false); //CloudinaryPublic(cloud_name, upload_preset)
  XFile? image;
  String? urlCloud;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _socketBloc = BlocProvider.of<SocketBloc>(context)!;
    final _authBloc = BlocProvider.of<AuthBloc>(context);
    AppBar appBar = AppBar(
      title: Text("Upload room's image"),
      backgroundColor: AppColor.secondColor,
    );
    final heightAppBar = appBar.preferredSize.height;

    Future getImageFromGallery() async {
      var img = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        image = img;
      });
    }

    return Scaffold(
      appBar: appBar,
      backgroundColor: AppColor.primaryColor,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            image != null
                ? Image.file(File(image!.path),
                    width: double.infinity,
                    height: size.height - 130 - heightAppBar,
                    fit: BoxFit.cover)
                : _socketBloc.currentRoomValue.avt != null &&
                        _socketBloc.currentRoomValue.avt!.isNotEmpty
                    ? Image.network(
                        '',
                        width: double.infinity,
                        height: size.height - 130 - heightAppBar,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: double.infinity,
                        height: size.height - 130 - heightAppBar,
                        color: AppColor.primaryColor,
                      ),
            Container(
                color: AppColor.secondColor,
                height: 100.0,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                child: image == null
                    ? Container(
                        //padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 1, color: AppColor.whiteGrey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0))),
                        child: TextButton(
                          onPressed: getImageFromGallery,
                          child: Text('Upload image', style: AppStyle.h5),
                        ),
                      )
                    : Row(
                        children: [
                          TextButton(
                              onPressed: () async {
                                LoadingDialog.showLoadingDialog(
                                    context, 'Upload image');
                                var res = await cloudinary.uploadFile(
                                    CloudinaryFile.fromFile(image!.path,
                                        resourceType:
                                            CloudinaryResourceType.Image));
                                if (res.secureUrl.isNotEmpty) {
                                  print(res.secureUrl);
                                  _socketBloc.uploadImg(
                                      res.secureUrl, _authBloc!.user.id!, () {
                                    LoadingDialog.hideLoadingDialog(context);
                                    image = XFile('');
                                    Navigator.pop(context);
                                  });
                                }
                              },
                              child: Text(
                                'Save',
                                style: AppStyle.h5,
                              )),
                          TextButton(
                              onPressed: () {
                                image = XFile('');
                              },
                              child: Text(
                                'Cancel',
                                style: AppStyle.h5,
                              ))
                        ],
                      ))
          ],
        ),
      ),
    );
  }
}
