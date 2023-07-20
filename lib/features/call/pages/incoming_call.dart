// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:whatsup/common/util/constants.dart';
// import 'package:whatsup/common/widgets/error.dart';
// import 'package:whatsup/common/widgets/progress.dart';
// import 'package:whatsup/features/call/controller/call_controller.dart';

// class IncomingCallPage extends ConsumerWidget {
//   final Widget scaffold;
//   const IncomingCallPage({
//     super.key,
//     required this.scaffold,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final userCalls = ref.watch(userCallStreamProvider);
//     return userCalls.when(
//       data: (call) {
//         // We are receiving an incoming call
//         if (call.hasDialled) {
//           return Scaffold(
//             // appBar: AppBar(
//             //   leading: const SizedBox.shrink(),
//             //   title: Text(call.callerName),
//             //   centerTitle: true,
//             // ),
//             body: Container(
//               alignment: Alignment.center,
//               padding: const EdgeInsets.symmetric(vertical: 20),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     'Incoming Call',
//                     style: TextStyle(fontSize: 24),
//                   ),
//                   const SizedBox(height: 50),
//                   CircleAvatar(
//                     backgroundImage: NetworkImage(call.callerImage),
//                     radius: 60,
//                   ),
//                   const SizedBox(height: 50),
//                   Text(
//                     call.callerName,
//                     style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
//                   ),
//                   const SizedBox(height: 50),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         onPressed: () {},
//                         icon: const Icon(Icons.call_end),
//                         color: Colors.red,
//                         splashRadius: kDefaultSplashRadius + 6,
//                       ),
//                       IconButton(
//                         onPressed: () {},
//                         icon: const Icon(Icons.call),
//                         color: Colors.green,
//                         splashRadius: kDefaultSplashRadius + 6,
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//             // bottomSheet: Container(
//             //   color: kDarkAppBarColor.withOpacity(0.6),
//             //   child: Row(
//             //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             //     children: [
//             //       // decline button

//             //       // create a decline icon button with a danger or red background color
//             //       FloatingActionButton(
//             //         onPressed: () {
//             //           Navigator.pop(context);
//             //         },
//             //         backgroundColor: Colors.red,
//             //         child: const Icon(Icons.call_end),
//             //       )
//             //     ],
//             //   ),
//             // ),
//           );
//         }
//         return scaffold;
//       },
//       error: (error, trace) => UnhandledError(error: error.toString()),
//       loading: () => const WorkProgressIndicator(),
//     );
//   }
// }
