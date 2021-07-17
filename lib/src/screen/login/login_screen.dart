import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../provider/my_provider.dart';
import '../../utils/my_utils.dart';
import '../registration/registration_screen.dart';
import '../welcome/welcome_screen.dart';

class LoginScreen extends ConsumerWidget {
  static const routeNamed = '/login-screen';

  LoginScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<StateController<bool>>(isLoading, (loading) {
      if (loading.state) {
        showLoadingDialog(context);
        return;
      }

      Navigator.of(context, rootNavigator: true).pop();
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: sizes.height(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Image.asset(
                      appConfig.fullPathImageAsset,
                      fit: BoxFit.cover,
                      scale: 1.75,
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Align(
                    child: Card(
                      margin: const EdgeInsets.all(24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 20),
                              Center(
                                child: Text(
                                  'Selamat Datang',
                                  style: fontsMontserratAlternate.copyWith(
                                      fontWeight: FontWeight.bold, fontSize: 16.0),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormFieldCustom(
                                controller: _emailController,
                                disableOutlineBorder: false,
                                prefixIcon:
                                    Icon(FeatherIcons.mail, color: colorPallete.accentColor),
                                hintText: 'zeffry.ganteng@gmail.com',
                                labelText: 'Email',
                                borderColor: colorPallete.accentColor,
                                borderFocusColor: colorPallete.accentColor,
                                activeColor: colorPallete.accentColor,
                                validator: (value) =>
                                    (value?.isEmpty ?? false) ? 'Email tidak boleh kosong' : null,
                              ),
                              const SizedBox(height: 20),
                              TextFormFieldCustom(
                                controller: _passwordController,
                                isPassword: true,
                                disableOutlineBorder: false,
                                prefixIcon:
                                    Icon(FeatherIcons.lock, color: colorPallete.accentColor),
                                hintText: '********',
                                labelText: 'Password',
                                borderColor: colorPallete.accentColor,
                                borderFocusColor: colorPallete.accentColor,
                                activeColor: colorPallete.accentColor,
                                onObsecurePasswordIcon: (isObsecure) =>
                                    isObsecure ? FeatherIcons.eyeOff : FeatherIcons.eye,
                                validator: (value) => (value?.isEmpty ?? false)
                                    ? 'Password tidak boleh kosong'
                                    : null,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () async {
                                  final validate = _formKey.currentState?.validate() ?? false;

                                  if (!validate) {
                                    return;
                                  }
                                  try {
                                    ref.read(isLoading).state = true;
                                    await ref.read(userProvider.notifier).login(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        );
                                    ref.read(isLoading).state = false;
                                    Future.delayed(
                                        const Duration(milliseconds: 500),
                                        () => Navigator.of(context)
                                            .pushReplacementNamed(WelcomeScreen.routeNamed));
                                  } catch (e) {
                                    GlobalFunction.showSnackBar(
                                      context,
                                      content: Text(e.toString()),
                                      snackBarType: SnackBarType.error,
                                    );
                                    Future.delayed(const Duration(milliseconds: 100),
                                        () => ref.read(isLoading).state = false);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(14.0),
                                ),
                                child: Text(
                                  'Login',
                                  style: fontComfortaa.copyWith().copyWith(color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: fontComfortaa.copyWith(color: Colors.black, fontSize: 12),
                            children: [
                              const TextSpan(text: 'Belum punya akun ? '),
                              TextSpan(
                                text: 'Daftar disini',
                                style: fontsMontserratAlternate.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorPallete.primaryColor,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.of(context)
                                      .pushNamed(RegistrationScreen.routeNamed),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Atau',
                          style: fontsMontserratAlternate.copyWith(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        RichText(
                          text: TextSpan(
                            style: fontComfortaa.copyWith(color: Colors.black, fontSize: 12),
                            children: [
                              const TextSpan(text: 'Lupa Password ? '),
                              TextSpan(
                                text: 'Reset disini',
                                style: fontsMontserratAlternate.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorPallete.primaryColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
