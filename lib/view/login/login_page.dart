import 'package:demo_chatting_app/const.dart';
import 'package:demo_chatting_app/services/alert_service.dart';
import 'package:demo_chatting_app/services/auth_services.dart';
import 'package:demo_chatting_app/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get_it/get_it.dart';

import '../../services/navigation_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GetIt getIt = GetIt.instance;

  late AuthServices authService;
  late NavigationService _navigationService;
  late AlertService _alertService;

  final GlobalKey<FormState> loginformKey = GlobalKey();
  String? email, password;

  @override
  void initState() {
    super.initState();
    authService = getIt.get<AuthServices>();
    _navigationService = getIt.get<NavigationService>();
    _alertService = getIt.get<AlertService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: buildUI(),
    );
  }

  Widget buildUI() {
    final kHeight = MediaQuery.sizeOf(context).height;
    final kWidth = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Column(
          children: [
            headerText(kWidth),
            loginForm(kHeight),
            loginButton(kWidth),
            creatAnAccountLink(),
          ],
        ),
      ),
    );
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

  Widget loginForm(double kHeight) {
    return Container(
      height: kHeight * 0.4,
      margin: EdgeInsets.symmetric(vertical: kHeight * 0.05),
      child: Form(
        key: loginformKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            )
          ],
        ),
      ),
    );
  }

  Widget loginButton(double kWidth) {
    return SizedBox(
      width: kWidth,
      child: MaterialButton(
          onPressed: () async {
            if (loginformKey.currentState?.validate() ?? false) {
              loginformKey.currentState?.save();
              bool result = await authService.login(email!, password!);
              if (result) {
                _navigationService.pushReplacementNamed('/home');
                _alertService.showToast(
                    text: 'Login successfully', icon: Icons.check);
              } else {
                _alertService.showToast(
                    text: 'Failed to login, Please try again',
                    icon: Icons.error);
              }
            }
          },
          color: Theme.of(context).colorScheme.primary,
          child: const Text(
            'Login',
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  Widget creatAnAccountLink() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('Don\'t have an account?'),
          GestureDetector(
              onTap: () {
                _navigationService.pushNamed('/register');
              },
              child: const Text('Sign up',
                  style: TextStyle(
                      fontWeight: FontWeight.w800, color: Colors.lightBlue)))
        ],
      ),
    );
  }
}
