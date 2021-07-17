import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../provider/my_provider.dart';
import '../../utils/my_utils.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  static const routeNamed = '/change-password';
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final passwordOldController = TextEditingController();
  final passwordNewController = TextEditingController();
  final passwordConfirmController = TextEditingController();

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
          'Ubah Password',
          style:
              fontsMontserratAlternate.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    TextFormFieldCustom(
                      controller: passwordOldController,
                      hintText: 'Password Lama',
                      labelText: 'Password Lama',
                      disableOutlineBorder: false,
                      isPassword: true,
                      borderColor: colorPallete.accentColor,
                      onObsecurePasswordIcon: (isObsecure) =>
                          isObsecure ? FeatherIcons.eyeOff : FeatherIcons.eye,
                      prefixIcon: const Icon(FeatherIcons.lock),
                      validator: (value) =>
                          GlobalFunction.validateIsEmpty(value, 'Password Lama tidak boleh kosong'),
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldCustom(
                      controller: passwordNewController,
                      hintText: 'Password Baru',
                      labelText: 'Password Baru',
                      disableOutlineBorder: false,
                      isPassword: true,
                      borderColor: colorPallete.accentColor,
                      onObsecurePasswordIcon: (isObsecure) =>
                          isObsecure ? FeatherIcons.eyeOff : FeatherIcons.eye,
                      prefixIcon: const Icon(FeatherIcons.lock),
                      validator: (value) =>
                          GlobalFunction.validateIsEmpty(value, 'Password Baru tidak boleh kosong'),
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldCustom(
                      controller: passwordConfirmController,
                      hintText: 'Konfirmasi Password',
                      labelText: 'Konfirmasi Password',
                      disableOutlineBorder: false,
                      isPassword: true,
                      borderColor: colorPallete.accentColor,
                      onObsecurePasswordIcon: (isObsecure) =>
                          isObsecure ? FeatherIcons.eyeOff : FeatherIcons.eye,
                      prefixIcon: const Icon(FeatherIcons.lock),
                      validator: (value) => GlobalFunction.validateIsEmpty(
                          value, 'Password Konfirmasi tidak boleh kosong'),
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
                          final idUser = ref.read(sessionLogin).state?.id;
                          log('iduser $idUser');
                          final result = await ref.read(userProvider.notifier).updatePassword(
                                idUser ?? 0,
                                passwordOld: passwordOldController.text,
                                passwordNew: passwordNewController.text,
                                passwordConfirm: passwordConfirmController.text,
                              );
                          GlobalFunction.showSnackBar(
                            context,
                            content: Text(result['message'] as String),
                            snackBarType: SnackBarType.success,
                          );

                          /// Reset TextField
                          passwordOldController.clear();
                          passwordNewController.clear();
                          passwordConfirmController.clear();
                          ref.read(isLoading).state = false;
                        } catch (e) {
                          ref.read(isLoading).state = false;

                          GlobalFunction.showSnackBar(
                            context,
                            content: Text(e.toString()),
                            snackBarType: SnackBarType.error,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(12.0)),
                      child: Text(
                        'Ubah',
                        style: fontsMontserratAlternate.copyWith(fontWeight: FontWeight.bold),
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
