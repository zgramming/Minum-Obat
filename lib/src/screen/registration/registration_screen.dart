import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../provider/my_provider.dart';
import '../../utils/my_utils.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  static const routeNamed = '/registration-screen';
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _passwordConfirmController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<StateController<bool>>(isLoading, (loading) {
      if (loading.state) {
        showLoadingDialog(context);
        return;
      }

      Navigator.of(context, rootNavigator: true).pop();
    });
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            FeatherIcons.arrowLeft,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Registrasi',
          style:
              fontsMontserratAlternate.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormFieldCustom(
                      controller: _fullNameController,
                      disableOutlineBorder: false,
                      borderColor: colorPallete.accentColor,
                      prefixIcon: Icon(FeatherIcons.user, color: colorPallete.accentColor),
                      labelText: 'Nama Lengkap',
                      hintText: 'Zeffry Reynando',
                      validator: (value) =>
                          (value?.isEmpty ?? false) ? 'Nama lengkap tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldCustom(
                      controller: _emailController,
                      disableOutlineBorder: false,
                      borderColor: colorPallete.accentColor,
                      prefixIcon: Icon(FeatherIcons.mail, color: colorPallete.accentColor),
                      keyboardType: TextInputType.emailAddress,
                      labelText: 'Email',
                      hintText: 'zeffry.reynando@gmail.com',
                      validator: (value) =>
                          (value?.isEmpty ?? false) ? 'Email tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldCustom(
                      controller: _passwordController,
                      isPassword: true,
                      disableOutlineBorder: false,
                      borderColor: colorPallete.accentColor,
                      prefixIcon: Icon(FeatherIcons.lock, color: colorPallete.accentColor),
                      onObsecurePasswordIcon: (isObsecure) =>
                          isObsecure ? FeatherIcons.eyeOff : FeatherIcons.eye,
                      labelText: 'Password',
                      hintText: '********',
                      validator: (value) =>
                          (value?.isEmpty ?? false) ? 'Password tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldCustom(
                      controller: _passwordConfirmController,
                      isPassword: true,
                      disableOutlineBorder: false,
                      borderColor: colorPallete.accentColor,
                      prefixIcon: Icon(FeatherIcons.lock, color: colorPallete.accentColor),
                      onObsecurePasswordIcon: (isObsecure) =>
                          isObsecure ? FeatherIcons.eyeOff : FeatherIcons.eye,
                      labelText: 'Ulangi Password',
                      hintText: '********',
                      validator: (value) => (value?.isEmpty ?? false)
                          ? 'Password Konfirmasi tidak boleh kosong'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        final validation = _formKey.currentState?.validate() ?? false;

                        if (!validation) {
                          return;
                        }
                        try {
                          ref.read(isLoading).state = true;
                          final registration = await ref.read(userProvider.notifier).registration(
                                fullName: _fullNameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                                passwordConfirm: _passwordConfirmController.text,
                              );
                          final message = registration['message'] as String;

                          GlobalFunction.showSnackBar(
                            context,
                            content: Text(message),
                            snackBarType: SnackBarType.success,
                          );
                          ref.read(isLoading).state = false;
                          Future.delayed(
                              const Duration(milliseconds: 500), () => Navigator.of(context).pop());
                        } catch (e) {
                          ref.read(isLoading).state = false;
                          GlobalFunction.showSnackBar(
                            context,
                            content: Text(e.toString()),
                            snackBarType: SnackBarType.error,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16.0)),
                      child: Text(
                        'Daftar',
                        style: fontsMontserratAlternate.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.white),
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
    );
  }
}
