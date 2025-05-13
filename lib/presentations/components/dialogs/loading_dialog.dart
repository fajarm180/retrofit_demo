// import 'package:flutter/material.dart';
// import 'package:klontong_mobile/services/navigation.dart';

// class LoadingScreen {
//   LoadingScreen._();

//   static Future show(BuildContext context) {
//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return const Dialog(
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           child: Center(child: CircularProgressIndicator()),
//         );
//       },
//     );
//   }

//   static void hide() {
//     final context = NavigationService.navigatorKey.currentState?.context;

//     if (!Navigator.of(context!).canPop()) return;

//     Navigator.of(context).pop();
//   }
// }
