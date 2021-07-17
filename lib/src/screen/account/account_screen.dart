import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../network/my_network.dart';
import '../../provider/my_provider.dart';
import '../../utils/my_utils.dart';
import '../change_password/change_password_screen.dart';
import '../login/login_screen.dart';
import './widgets/account_menu_item.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: colorPallete.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Ink(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 4.0,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: InkWell(
                            onTap: () async {
                              await showModalBottomSheet(
                                context: context,
                                builder: (context) => ActionModalBottomSheet(
                                  typeAction: TypeAction.none,
                                  align: WrapAlignment.center,
                                  children: [
                                    ActionCircleButton(
                                      backgroundColor: colorPallete.info,
                                      foregroundColor: Colors.white,
                                      icon: FeatherIcons.camera,
                                      radius: 40.0,
                                      onTap: () async {
                                        try {
                                          final _pickedFile = await _picker.getImage(
                                            source: ImageSource.camera,
                                            maxHeight: 200,
                                            maxWidth: 200,
                                            imageQuality: 80,
                                          );

                                          if (_pickedFile != null) {
                                            final user = ref.read(sessionLogin).state;
                                            final image = File(_pickedFile.path);
                                            await ref.read(userProvider.notifier).updateImage(
                                                  user?.id ?? 0,
                                                  image: image,
                                                );
                                            setState(() {});
                                          }
                                        } catch (e) {
                                          GlobalFunction.showSnackBar(context,
                                              content: Text(e.toString()),
                                              snackBarType: SnackBarType.error);
                                        }
                                      },
                                    ),
                                    ActionCircleButton(
                                      backgroundColor: colorPallete.success,
                                      foregroundColor: Colors.white,
                                      icon: FeatherIcons.image,
                                      radius: 40.0,
                                      onTap: () async {
                                        try {
                                          final _pickedFile = await _picker.getImage(
                                            source: ImageSource.gallery,
                                            maxHeight: 200,
                                            maxWidth: 200,
                                            imageQuality: 80,
                                          );
                                          if (_pickedFile != null) {
                                            final user = ref.read(sessionLogin).state;
                                            final image = File(_pickedFile.path);
                                            await ref.read(userProvider.notifier).updateImage(
                                                  user?.id ?? 0,
                                                  image: image,
                                                );
                                            setState(() {});
                                          }
                                        } catch (e) {
                                          GlobalFunction.showSnackBar(context,
                                              content: Text(e.toString()),
                                              snackBarType: SnackBarType.error);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Builder(
                              builder: (context) {
                                final user = ref.watch(sessionLogin).state;
                                Widget image;

                                if (user?.image?.isEmpty ?? true) {
                                  image = CircleAvatar(
                                    backgroundColor: colorPallete.accentColor,
                                    radius: 60.0,
                                    child: const Icon(
                                      FeatherIcons.user,
                                      size: 40.0,
                                    ),
                                  );
                                } else {
                                  image = ClipOval(
                                    child: Image.network(
                                      '${constant.pathImageUser}/${user?.image}?v=${DateTime.now().millisecondsSinceEpoch}',
                                      key: ValueKey(
                                          '${constant.pathImageUser}/${user?.image}?v=${DateTime.now().millisecondsSinceEpoch}'),
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }

                                return image;
                              },
                            ),
                          ),
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          final user = ref.watch(sessionLogin).state;
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 20),
                              Center(
                                child: Text(
                                  user?.fullname ?? '',
                                  style: fontsMontserratAlternate.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: Text(
                                  user?.email ?? '',
                                  style: fontComfortaa.copyWith(
                                    fontSize: 12.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: Text.rich(
                                  TextSpan(
                                    style: fontComfortaa.copyWith(
                                        color: Colors.white,
                                        decoration: TextDecoration.underline,
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w300),
                                    children: [
                                      const TextSpan(text: 'Terakhir login pada '),
                                      TextSpan(
                                        text:
                                            '${GlobalFunction.formatYMD(user?.loginAt ?? DateTime(1970, 10, 10), type: 3)} @${GlobalFunction.formatHM(user?.loginAt ?? DateTime(1970, 10, 10))}',
                                        style: fontComfortaa.copyWith(fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                color: colorPallete.primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AccountMenuItem(
                        onTap: () {},
                        icon: FeatherIcons.barChart2,
                        title: 'Export Statistik',
                        subtitle: 'Export hasil statistik kamu selama menggunakan aplikasi ini',
                      ),
                      AccountMenuItem(
                        onTap: () {
                          Navigator.of(context).pushNamed(ChangePasswordScreen.routeNamed);
                        },
                        icon: FeatherIcons.lock,
                        title: 'Ubah Password',
                        subtitle: 'Kami merekomendasikan untuk mengganti password secara berkala',
                      ),
                      AccountMenuItem(
                        onTap: () async {
                          showLicensePage(
                            context: context,
                            applicationIcon: CircleAvatar(
                              backgroundColor: colorPallete.primaryColor,
                              foregroundColor: Colors.white,
                              radius: 60.0,
                              backgroundImage: AssetImage(constant.pathLogoWhite),
                            ),
                          );
                        },
                        icon: FeatherIcons.codesandbox,
                        title: 'Lisensi',
                        subtitle: 'Daftar lisensi yang digunakan pada aplikasi ini',
                      ),
                      AccountMenuItem(
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FractionallySizedBox(
                                    widthFactor: 1.0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Image.asset(
                                          constant.pathFlaticonImage,
                                          width: 60,
                                          height: 60,
                                        ),
                                        Image.asset(
                                          constant.pathFreepikImage,
                                          width: 60,
                                          height: 60,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text.rich(
                                    TextSpan(
                                      style: fontComfortaa.copyWith(
                                          color: Colors.black, fontSize: 10.0),
                                      children: [
                                        const TextSpan(text: 'Icon made by '),
                                        TextSpan(
                                          text: 'Freepik',
                                          style: fontsMontserratAlternate.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: colorPallete.primaryColor,
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              try {
                                                final _url = constant.freepikUrl;
                                                await canLaunch(_url)
                                                    ? await launch(_url)
                                                    : throw 'Could not launch $_url';
                                              } catch (e) {
                                                GlobalFunction.showSnackBar(
                                                  context,
                                                  content: Text(e.toString()),
                                                  snackBarType: SnackBarType.error,
                                                );
                                              }
                                            },
                                        ),
                                        const TextSpan(text: ' from '),
                                        TextSpan(
                                            text: 'www.flaticon.com ',
                                            style: fontsMontserratAlternate.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: colorPallete.primaryColor,
                                              decoration: TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                try {
                                                  final _url = constant.flaticonUrl;
                                                  await canLaunch(_url)
                                                      ? await launch(_url)
                                                      : throw 'Could not launch $_url';
                                                } catch (e) {
                                                  GlobalFunction.showSnackBar(
                                                    context,
                                                    content: Text(e.toString()),
                                                    snackBarType: SnackBarType.error,
                                                  );
                                                }
                                              }),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Tutup'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: FeatherIcons.flag,
                        title: 'Copyright',
                        subtitle: 'Copyright yang ada pada aplikasi ini',
                      ),
                      AccountMenuItem(
                        onTap: () async {
                          final result = await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0),
                              ),
                            ),
                            builder: (context) => FractionallySizedBox(
                              heightFactor: .6,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 32.0,
                                    mainAxisSpacing: 32.0,
                                  ),
                                  itemCount: listSocialMedia.length,
                                  itemBuilder: (context, index) {
                                    final socialMedia = listSocialMedia[index];
                                    return InkWell(
                                      onTap: () async {
                                        try {
                                          final _url = socialMedia.url;
                                          await canLaunch(_url)
                                              ? await launch(_url)
                                              : throw 'Could not launch $_url';
                                        } catch (e) {
                                          GlobalFunction.showSnackBar(
                                            context,
                                            content: Text(e.toString()),
                                            snackBarType: SnackBarType.error,
                                          );
                                        }
                                      },
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: colorPallete.primaryColor,
                                        ),
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(24.0),
                                                child: socialMedia.icon,
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                socialMedia.name,
                                                style: fontsMontserratAlternate.copyWith(
                                                  fontSize: 14.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                        icon: FeatherIcons.meh,
                        title: 'Tentang Developer',
                        subtitle:
                            'Punya pertanyaan yang mengganjal hatimu atau hanya ingin lebih dekat denganku ?',
                      ),
                      AccountMenuItem(
                        onTap: () async {
                          await ref.read(sessionProvider.notifier).removeSessionLogin();
                          Navigator.of(context).pushReplacementNamed(LoginScreen.routeNamed);
                        },
                        icon: FeatherIcons.logOut,
                        title: 'Keluar',
                        subtitle: 'Jangan lupa untuk kembali lagi ya...',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
