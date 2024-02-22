import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/manager/user_manager.dart';
import 'package:plannerfy_desktop/pages/login/components/fhi_logo_login.dart';
import 'package:plannerfy_desktop/pages/login/components/login_btn.dart';
import 'package:plannerfy_desktop/pages/login/components/logo_title.dart';
import 'package:plannerfy_desktop/pages/login/components/password_field.dart';
import 'package:plannerfy_desktop/pages/login/components/user_field.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late FocusNode _usernameFocusNode;
  late FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _usernameController.text = "fredericohi18@gmail.com";
    _passwordController.text = "123456";
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: markPrimaryColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LogoTitle(),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 70),
                          child: UserField(
                            controller: _usernameController,
                            focusNode: _usernameFocusNode,
                            nextFocusNode: _passwordFocusNode,
                            labelText: "Usuário",
                            prefixIcon: Icons.person,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 70),
                          child: PasswordField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            labelText: "Senha",
                            prefixIcon: Icons.lock_rounded,
                            suffixIcon: Icons.remove_red_eye_outlined,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 70),
                          child: LoginButton(
                              texto: "Entrar",
                              login: () {
                                UserManager().userSignIn(
                                    context,
                                    _usernameController.text,
                                    _passwordController.text);
                              }
                              // () {
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => const HomePage()),
                              //   );
                              // },
                              ),
                        ),
                        const SizedBox(height: 100),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FhiLogoHome(),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}







































// import 'package:flutter/material.dart';
// import 'package:plannerfy_desktop/models/user_model.dart';
// import 'package:plannerfy_desktop/pages/login/components/fhi_logo_login.dart';
// import 'package:plannerfy_desktop/pages/login/components/login_btn.dart';
// import 'package:plannerfy_desktop/pages/login/components/logo_title.dart';
// import 'package:plannerfy_desktop/pages/login/components/password_field.dart';
// import 'package:plannerfy_desktop/pages/login/components/user_field.dart';
// import 'package:plannerfy_desktop/services/queries/ws_users.dart';
// import 'package:plannerfy_desktop/utility/app_config.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   late TextEditingController _usernameController;
//   late TextEditingController _passwordController;
//   late FocusNode _usernameFocusNode;
//   late FocusNode _passwordFocusNode;

//   @override
//   void initState() {
//     super.initState();
//     _usernameController = TextEditingController();
//     _passwordController = TextEditingController();
//     _usernameFocusNode = FocusNode();
//     _passwordFocusNode = FocusNode();
//   }

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _passwordController.dispose();
//     _usernameFocusNode.dispose();
//     _passwordFocusNode.dispose();
//     super.dispose();
//   }

//   Future<void> _login() async {
//     String username = _usernameController.text.trim();
//     String password = _passwordController.text.trim();

//     // Perform validation
//     if (username.isEmpty || password.isEmpty) {
//       // Show error message or handle accordingly
//       return;
//     }

//     // Call login service
//     WsUsers wsUsers = WsUsers();
//     UserModel? user = await wsUsers.login(username, password);

//     if (user != null) {
//       Navigator.pushReplacementNamed(context, '/home');
//     } else {
//       // Show login failed message or handle accordingly
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Expanded(
//             child: Container(
//               color: markPrimaryColor,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   LogoTitle(),
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Center(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       const Align(
//                         alignment: Alignment.center,
//                         child: Text(
//                           'LOGIN',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 40,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 70),
//                         child: UserField(
//                           controller: _usernameController,
//                           focusNode: _usernameFocusNode,
//                           nextFocusNode: _passwordFocusNode,
//                           labelText: "Usuário",
//                           prefixIcon: Icons.person,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 70),
//                         child: PasswordField(
//                           controller: _passwordController,
//                           focusNode: _passwordFocusNode,
//                           labelText: "Senha",
//                           prefixIcon: Icons.lock_rounded,
//                           suffixIcon: Icons.remove_red_eye_outlined,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 70),
//                         child: LoginButton(
//                           texto: "Entrar",
//                           login: _login,
//                         ),
//                       ),
//                       const SizedBox(height: 100),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           FhiLogoHome(),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
