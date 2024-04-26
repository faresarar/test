import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../tools.dart';

class CustomProfilePhotoPicker extends StatefulWidget {
  const CustomProfilePhotoPicker({
    super.key,
    this.photo,
    this.initialPhotoPath,
    this.radius,
    this.width,
    this.onChanged,
  });

  final ImageProvider<Object>? photo;
  final String? initialPhotoPath;
  final double? radius;
  final double? width;
  final void Function(String)? onChanged;

  @override
  State<CustomProfilePhotoPicker> createState() =>
      _CustomProfilePhotoPickerState();
}

class _CustomProfilePhotoPickerState extends State<CustomProfilePhotoPicker> {
  String? photoPath;

  @override
  void initState() {
    super.initState();
    photoPath = widget.initialPhotoPath;
  }

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: widget.onChanged != null
          ? () {
              ModernPicker.of(context).showClassicSingleImagePicker(
                source: ImageSource.gallery,
                crop: true,
                onComplete: (xfile) {
                  setState(() {
                    photoPath = xfile.path;
                    widget.onChanged!(xfile.path);
                  });
                },
              );
            }
          : null,
      child: CircleAvatar(
        radius: widget.radius ?? 50.sp,
        backgroundColor: context.primary,
        child: CircleAvatar(
          radius: (widget.radius ?? 50.sp) - (widget.width ?? 4),
          backgroundColor: context.primaryColor[50],
          foregroundImage: photoPath != null
              ? Image.asset(photoPath!).image
              : widget.photo ?? Image.asset('assets/images/avatar.png').image,
        ),
      ),
    );
  }
}
