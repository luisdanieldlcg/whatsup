import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/common/widgets/primary_button.dart';
import 'package:whatsup/features/auth/controllers/auth.dart';
import 'package:whatsup/router.dart';

class OTPVerificationPage extends ConsumerStatefulWidget {
  final String idSent;
  const OTPVerificationPage({
    super.key,
    required this.idSent,
  });

  @override
  ConsumerState<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends ConsumerState<OTPVerificationPage> {
  static const int smsCodeLen = 6;
  final otpController = List.generate(smsCodeLen, (index) => TextEditingController());
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter the OTP Code"),
        centerTitle: true,
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  for (int i = 0; i < smsCodeLen; i++) ...{
                    Flexible(
                      child: TextFormField(
                        controller: otpController[i],
                        keyboardType: TextInputType.number,
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                        onChanged: (text) {
                          if (text.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                  }
                ],
              ),
              const Spacer(),
              PrimaryButton(
                title: "Verify",
                onPressed: verifyOTP,
                loading: loading,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  String get otpCode {
    return otpController.map((e) => e.text).join();
  }

  void verifyOTP() async {
    setState(() {
      loading = true;
    });
    ref.read(authControllerProvider).verifyOTP(
          idSent: widget.idSent,
          inputCode: otpCode,
          context: context,
          createProfileRoute: PageRouter.createProfile,
        );
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }
}
