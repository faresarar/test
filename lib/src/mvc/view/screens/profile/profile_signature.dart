import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;

import '../../../../tools.dart';
import '../../../model/enums.dart';
import '../../../model/models.dart';
import '../../model_widgets.dart';

class ProfileSignature extends StatefulWidget {
  const ProfileSignature({
    super.key,
    required this.userSession,
  });

  final UserSession userSession;

  @override
  State<ProfileSignature> createState() => _ProfileSignatureState();
}

class _ProfileSignatureState extends State<ProfileSignature> {
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: CustomElevatedButton(
        label: 'Enregistrer',
        onPressed: submit,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            Customheader(
              title: 'Ma signature',
              subtitle: 'Veuillez inscrire votre signature.',
              constraints: BoxConstraints.tightFor(height: 150.sp),
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
                backgroundColor: context.scaffoldBackgroundColor,
              ),
            ),
          ],
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
          signiture: bytes?.buffer.asUint8List(),
        );
      },
      onComplete: (_) => context.pop(),
      onCompleteMessage: 'Votre profil a été mis à jour!',
      dialogType: DialogType.snackbar,
    );
  }
}
