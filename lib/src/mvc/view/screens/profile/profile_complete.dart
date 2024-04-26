import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;

import '../../../../tools.dart';
import '../../../model/enums.dart';
import '../../../model/models.dart';
import '../../model_widgets.dart';

class ProfileComplete extends StatefulWidget {
  const ProfileComplete({
    super.key,
    required this.userSession,
  });

  final UserSession userSession;

  @override
  State<ProfileComplete> createState() => _ProfileCompleteState();
}

class _ProfileCompleteState extends State<ProfileComplete>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> formKey = GlobalKey();
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  PageController controller = PageController();

  String? photoPath;
  String? firstName;
  String? lastName;
  String? birthDate;
  String? adeli;

  @override
  void initState() {
    super.initState();
    firstName = widget.userSession.firstName;
    lastName = widget.userSession.lastName;
    birthDate = widget.userSession.birthDate;
    adeli = widget.userSession.adeli;
  }

  int get currentPage => (controller.page ?? 0).round();

  void nextPage() {
    controller.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void previousPage() {
    controller.previousPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void next() {
    if (currentPage == 0) {
      if (!formKey.currentState!.validate()) return;
      formKey.currentState!.save();
      nextPage();
      return;
    }
    if (currentPage == 1) {
      submit();
    }
  }

  void back() {
    if (currentPage == 0) {
      context.pop();
    } else {
      previousPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PopScope(
      canPop: controller.hasClients && currentPage == 0,
      onPopInvoked: (poped) {
        if (!poped) {
          back();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: back,
            icon: Icon(
              context.backButtonIcon,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: 1.sh - 56 - context.viewPadding.top,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: PageView(
                    controller: controller,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // Page1
                      CustomKeepAliveWidget(
                        child: Form(
                          key: formKey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Customheader(
                                  title: 'Compléter mon profil',
                                  subtitle:
                                      'Compléter ou mettez à jour votre profil pour une meilleure expérience sur PansIA !',
                                  constraints:
                                      BoxConstraints.tightFor(height: 150.sp),
                                ),
                                Center(
                                  child: CustomProfilePhotoPicker(
                                    photo: widget.userSession.photo,
                                    initialPhotoPath: photoPath,
                                    onChanged: (path) {
                                      photoPath = path;
                                    },
                                  ),
                                ),
                                42.heightH,
                                CustomTextFormField(
                                  hintText: 'Nom',
                                  initialValue: lastName,
                                  keyboardType: TextInputType.name,
                                  prefixIcon: AwesomeIconsLight.address_card,
                                  textInputAction: TextInputAction.next,
                                  validator: Validators.validateNotNull,
                                  onSaved: (value) => lastName = value,
                                ),
                                CustomTextFormField(
                                  hintText: 'Prénom',
                                  initialValue: firstName,
                                  keyboardType: TextInputType.name,
                                  prefixIcon: AwesomeIconsLight.address_card,
                                  textInputAction: TextInputAction.next,
                                  validator: Validators.validateNotNull,
                                  onSaved: (value) => firstName = value,
                                ),
                                SizedBox(
                                  width: 0.4.sw,
                                  child: CustomTextFormField(
                                    hintText: 'Date de naissance',
                                    initialValue: birthDate,
                                    keyboardType: TextInputType.datetime,
                                    prefixIcon: AwesomeIconsLight.calendar,
                                    textInputAction: TextInputAction.next,
                                    validator: Validators.validateNotNull,
                                    onSaved: (value) => birthDate = value,
                                  ),
                                ),
                                CustomTextFormField(
                                  hintText: 'Numéro ADELI',
                                  initialValue: adeli,
                                  keyboardType: TextInputType.number,
                                  prefixIcon: AwesomeIconsLight.input_numeric,
                                  suffixIcon: AwesomeIconsLight.circle_info,
                                  textInputAction: TextInputAction.done,
                                  validator: Validators.validateNumberInt,
                                  onSaved: (value) => adeli = value,
                                  onEditingComplete: next,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Page2
                      CustomKeepAliveWidget(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            children: [
                              Customheader(
                                title: 'Ma signature',
                                subtitle: 'Veuillez inscrire votre signature.',
                                constraints:
                                    BoxConstraints.tightFor(height: 150.sp),
                              ),
                              Container(
                                height: 0.25.sh,
                                width: 0.8.sw,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: context.b2,
                                    width: 2.sp,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: SfSignaturePad(
                                  key: _signaturePadKey,
                                  minimumStrokeWidth: 1,
                                  maximumStrokeWidth: 3,
                                  strokeColor: context.b1,
                                  backgroundColor:
                                      context.scaffoldBackgroundColor,
                                ),
                              ),
                              38.heightH,
                              AnimatedBuilder(
                                animation: controller,
                                builder: (context, _) {
                                  return TextButton(
                                    onPressed:
                                        _signaturePadKey.currentState?.clear,
                                    child: const Text('Effacer la signature'),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      80.heightH,
                      Row(
                        children: [
                          CustomSmoothPageIndicator(
                            controller: controller,
                            count: 2,
                          ),
                          const Spacer(),
                          FloatingActionButton(
                            onPressed: next,
                            child: const Icon(
                              AwesomeIconsRegular.arrow_right_long,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                (context.viewPadding.bottom + 40.h).height,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submit() async {
    await Dialogs.of(context).runAsyncAction(
      future: () async {
        ui.Image signature = await _signaturePadKey.currentState!.toImage();
        ByteData? bytes = await signature.toByteData();
        await widget.userSession.completeProfile(
          photoPath: photoPath,
          firstName: firstName,
          lastName: lastName,
          birthDate: birthDate,
          adeli: adeli,
          signiture: bytes?.buffer.asUint8List(),
        );
      },
      onComplete: (_) => context.pop(),
      onCompleteMessage: 'Votre profil a été mis à jour!',
      dialogType: DialogType.snackbar,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
