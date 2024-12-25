import 'dart:io';

import 'package:demo_chatting_app/const.dart';
import 'package:demo_chatting_app/models/user_profile.dart';
import 'package:demo_chatting_app/services/alert_service.dart';
import 'package:demo_chatting_app/services/auth_services.dart';
import 'package:demo_chatting_app/services/database_service.dart';
import 'package:demo_chatting_app/services/media_service.dart';
import 'package:demo_chatting_app/services/navigation_service.dart';
import 'package:demo_chatting_app/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/storage_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GetIt getIt = GetIt.instance;
  final GlobalKey<FormState> registerFormKey = GlobalKey();

  late MediaService _mediaService;
  late NavigationService _navigationService;
  late AuthServices _authServices;
  late StorageService _storageService;
  late DatabaseService _databaseService;
  late AlertService _alertService;

  bool isLoading = false;

  File? selecImage;
  String? name, email, password;

  @override
  void initState() {
    super.initState();
    _mediaService = getIt.get<MediaService>();
    _navigationService = getIt.get<NavigationService>();
    _authServices = getIt.get<AuthServices>();
    _storageService = getIt.get<StorageService>();
    _databaseService = getIt.get<DatabaseService>();
    _alertService = getIt.get<AlertService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _builUI(),
    );
  }

  Widget _builUI() {
    final kWidth = MediaQuery.sizeOf(context).width;
    final kHeight = MediaQuery.sizeOf(context).height;
    return SafeArea(
        child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            child: Column(children: [
              headerText(kWidth),
              if (!isLoading) registerForm(kHeight, kWidth),
              if (!isLoading) loginAccountLink(),
              if (isLoading)
                const Expanded(
                    child: Center(child: CircularProgressIndicator())),
            ])));
  }

  Widget headerText(double kWidth) {
    return SizedBox(
      width: kWidth,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi, Welcome back!',
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            'Hi, Welcome back!',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget registerForm(double kHeight, double kWidth) {
    return Container(
      height: kHeight * 0.66,
      margin: EdgeInsets.symmetric(vertical: kHeight * 0.05),
      child: Form(
        key: registerFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pfpSelectionFiled(kWidth),
            CustomFormField(
                hintText: 'Name',
                height: kHeight * 0.1,
                validationRegEx: NAME_VALIDATION_REGEX,
                onSaved: (value) {
                  setState(() {
                    name = value;
                  });
                }),
            CustomFormField(
              onSaved: (value) {
                setState(() {
                  email = value;
                });
              },
              validationRegEx: EMAIL_VALIDATION_REGEX,
              height: kHeight * 0.1,
              hintText: 'Email',
            ),
            CustomFormField(
              onSaved: (value) {
                setState(() {
                  password = value;
                });
              },
              obscureText: true,
              validationRegEx: PASSWORD_VALIDATION_REGEX,
              height: kHeight * 0.1,
              hintText: 'Password',
            ),
            _registerButton(kWidth),
          ],
        ),
      ),
    );
  }

  Widget _pfpSelectionFiled(double kWidth) {
    return GestureDetector(
      onTap: () async {
        File? file = await _mediaService.getImageFromGallery();
        if (file != null) {
          setState(() {
            selecImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: kWidth * 0.15,
        backgroundImage: selecImage != null
            ? FileImage(selecImage!)
            : const NetworkImage(PLACEHOLDER_FFP) as ImageProvider,
      ),
    );
  }

  Widget _registerButton(double kWidth) {
    return SizedBox(
      width: kWidth,
      child: MaterialButton(
        color: Theme.of(context).colorScheme.primary,
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          try {
            if ((registerFormKey.currentState?.validate() ?? false) &&
                selecImage != null) {
              registerFormKey.currentState?.save();
              bool result = await _authServices.signup(email!, password!);
              if (result) {
                String? pfpURL = await _storageService.uploadUserPfp(
                    file: selecImage!, uid: _authServices.user!.uid);
                if (pfpURL != null) {
                  await _databaseService.createUserProfile(
                      userProfile: UserProfile(
                          name: name,
                          pfpURL: pfpURL,
                          uid: _authServices.user!.uid));
                  _alertService.showToast(
                      text: 'User register successfully', icon: Icons.check);
                  _navigationService.goBack();
                  _navigationService.pushReplacementNamed('/home');
                } else {
                  throw Exception('Unable to upload usser profile picture');
                }
              } else {
                throw Exception('Unable to register');
              }
            }
          } catch (e) {
            print(e);
            _alertService.showToast(
                text: 'Failed to register, Please try again!!!',
                icon: Icons.error);
          }
          setState(() {
            isLoading = false;
          });
        },
        child: const Text('Register', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget loginAccountLink() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('Already have an account?'),
          GestureDetector(
              onTap: () {
                _navigationService.goBack();
              },
              child: const Text('Login',
                  style: TextStyle(
                      fontWeight: FontWeight.w800, color: Colors.lightBlue)))
        ],
      ),
    );
  }
}
