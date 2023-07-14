import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsup/common/theme.dart';
import 'package:whatsup/common/util/constants.dart';
import 'package:whatsup/common/util/misc.dart';
import 'package:whatsup/common/widgets/primary_button.dart';
import 'package:whatsup/router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Country country = Country.worldWide;
  final _extController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter your phone number"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: "$kAppName will need to verify your phone number. "),
                  TextSpan(
                    text: "What's my number?",
                    style: TextStyle(color: kTextHighlightColor),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: pickCountry,
              style: TextButton.styleFrom(foregroundColor: kTextHighlightColor),
              child: const Text(
                "Pick Country",
                style: TextStyle(
                  color: kTextHighlightColor,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      readOnly: true,
                      controller: _extController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        hintText: "Ext.",
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    flex: 4,
                    child: TextField(
                      controller: _phoneController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(hintText: "Phone Number"),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: PrimaryButton(
                title: "NEXT",
                onPressed: goToOTPVerification,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _extController.dispose();
    _phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
      showPhoneCode: true,
      useSafeArea: true,
      context: context,
      onSelect: (country) {
        setState(() {
          this.country = country;
          if (this.country != Country.worldWide) {
            _extController.text = "+ ${country.phoneCode}";
          }
        });
      },
    );
  }

  void goToOTPVerification() {
    if (_extController.text.isEmpty || _phoneController.text.isEmpty) {
      showSnackbar(context, "Please enter your phone number.");
      return;
    }
    Navigator.pushNamed(context, PageRouter.otpVerification);
  }
}
