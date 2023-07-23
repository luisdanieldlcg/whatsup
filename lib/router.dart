import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsup/common/models/call.dart';
import 'package:whatsup/common/models/status.dart';
import 'package:whatsup/common/util/logger.dart';
import 'package:whatsup/features/auth/pages/create_profile.dart';
import 'package:whatsup/features/auth/pages/login.dart';
import 'package:whatsup/features/auth/pages/otp_verification.dart';
import 'package:whatsup/features/call/pages/call.dart';
import 'package:whatsup/features/chat/pages/chat_room.dart';
import 'package:whatsup/features/contact/pages/select_contact.dart';
import 'package:whatsup/features/group/pages/create_group.dart';
import 'package:whatsup/features/home/pages/home.dart';
import 'package:whatsup/features/status/pages/status_image_preview.dart';
import 'package:whatsup/features/status/pages/status_view.dart';
import 'package:whatsup/features/status/pages/status_writer.dart';
import 'package:whatsup/features/welcome/pages/welcome.dart';

class PageRouter {
  static const String welcome = '/welcome';
  static const String login = 'auth/login';
  static const String otpVerification = 'auth/otp-verification';
  static const String createProfile = 'auth/create-profile';
  static const String home = "/home";
  static const String selectContact = "/select-contact";
  static const String chat = "/chat";
  static const String statusWriter = "/status-writer";
  static const String statusViewer = "/status-viewer";
  static const String statusImageConfirm = "/status-image-confirm";
  static const String createGroup = "/create-group";
  static const String call = "/call";

  static Route<Widget> generateRoutes(RouteSettings settings) {
    AppLogger.getLogger((PageRouter).toString()).d('Navigating to ${settings.name}');
    switch (settings.name) {
      case welcome:
        return _createRoute(const WelcomePage());
      case login:
        return _createRoute(const LoginPage());
      case otpVerification:
        final String idSent = settings.arguments as String;
        return _createRoute(OTPVerificationPage(idSent: idSent));
      case createProfile:
        return _createRoute(const CreateProfilePage());
      case home:
        return _createRoute(const HomePage());
      case selectContact:
        return _createRoute(const SelectContactPage());
      case chat:
        final args = settings.arguments as Map<String, dynamic>;
        return _createRoute(ChatRoomPage(
          streamId: args['streamId'] as String,
          avatarImage: args['avatarImage'] as String,
          isGroup: args['isGroup'] as bool,
          name: args['name'] as String,
        ));
      case statusWriter:
        return _createRoute(const StatusWriterPage());
      case statusViewer:
        final status = settings.arguments as StatusModel;
        return _createRoute(StatusViewerPage(status: status));
      case statusImageConfirm:
        final file = settings.arguments as File;
        return _createRoute(StatusImageConfirmPage(file: file));
      case createGroup:
        return _createRoute(const CreateGroupPage());
      case call:
        final args = settings.arguments as Map<String, dynamic>;
        return _createRoute(
          CallPage(
            channelId: args['channelId'] as String,
            model: args['model'] as CallModel,
            isGroup: args['isGroup'] as bool,
          ),
        );
      default:
        return _createRoute(UnknownRoutePage(targetRoute: settings.name!));
    }
  }

  static Route<Widget> _createRoute(Widget child) {
    return MaterialPageRoute<Widget>(
      builder: (_) => child,
    );
  }
}

class UnknownRoutePage extends StatelessWidget {
  final String targetRoute;
  const UnknownRoutePage({
    super.key,
    required this.targetRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "The route '$targetRoute' was not found.",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
