import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

import '../../../features/car_regist/presentation/photo_manager.dart';
import '../../../features/menu_widget_test/pages/button_widget.dart';
import '../dialog/common_dialog.dart';

class ButtonPickupAPhoto extends StatefulWidget {
  const ButtonPickupAPhoto(
      {Key? key,
      required this.context,
      required this.mListPhoto,
      required this.picker})
      : super(key: key);

  final BuildContext context;
  final List<PhotoManager> mListPhoto;
  final ImagePicker picker;

  @override
  State<ButtonPickupAPhoto> createState() => _ButtonPickupAPhotoState();
}

class _ButtonPickupAPhotoState extends State<ButtonPickupAPhoto> {
  @override
  Widget build(context) {
    return Column(
      children: [
        _showImageWithGridView(),
        _buildButtonPickupAPhoto(context),
      ],
    );
  }

  Widget _buildButtonPickupAPhoto(BuildContext context) {
    return ButtonWidget(
      content: '写真を撮影・選択',
      bgdColor: ResourceColors.color_0FA4EA,
      borderRadius: Dimens.getWidth(20.0),
      width: MediaQuery.of(context).size.width / 1.5,
      textStyle: MKStyle.t14R.copyWith(
        color: ResourceColors.color_white,
        fontWeight: FontWeight.w400,
      ),
      heightText: 1.2,
      clickButtonCallBack: () => pickupAPhoto(context),
    );
  }

  Widget _showImageWithGridView() {
    return widget.mListPhoto.length > 0
        ? Padding(
            padding: EdgeInsets.only(
                top: Dimens.getWidth(15.0),
                bottom: Dimens.getWidth(15.0),
                left: Dimens.getWidth(15.0),
                right: Dimens.getWidth(15.0)),
            child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisSpacing: Dimens.getWidth(5.0),
                mainAxisSpacing: Dimens.getWidth(5.0),
                crossAxisCount: 3,
                children: List.generate(widget.mListPhoto.length, (index) {
                  return _showImage(widget.mListPhoto[index].bmp);
                })),
          )
        : SizedBox.shrink();
  }

  Widget _showImage(Uint8List? image) {
    return InkWell(
      onTap: () {
        showConfirmDeleteOfPhoto(image);
      },
      child: Image.memory(
        image!,
        width: MediaQuery.of(widget.context).size.width / 3.8,
        fit: BoxFit.fill,
      ),
    );
  }

  /// Dialog to alert delete of photo list
  showConfirmDeleteOfPhoto(Uint8List? image) async {
    await CommonDialog.displayConfirmDialog(
      widget.context,
      TextWidget(
        label: "CONFIRM_DELETE_PHOTO".tr(),
        textStyle: MKStyle.t14R.copyWith(color: ResourceColors.color_000000),
        alignment: TextAlign.start,
      ),
      'DELETE'.tr(),
      "CANCEL".tr(),
      okEvent: () async {
        if (widget.mListPhoto.map((e) => e.bmp).toList().contains(image)) {
          setState(() {
            widget.mListPhoto.removeWhere((e) => e.bmp == image);
          });
        }
      },
      cancelEvent: () {},
    );
  }

  ///Build button to get a photo
  pickupAPhoto(BuildContext context) async {
    if (widget.mListPhoto.length == 6) {
      showConfirmOk(context);
      return;
    }
    showPhotoDialog(context);
  }

  /// Dialog to alert the number of photo list
  showConfirmOk(BuildContext context) async {
    await CommonDialog.displayConfirmOneButtonDialog(
      context,
      TextWidget(
        label: "UP_TO_6_PHOTOS_CAN_BE_UPLOAD".tr(),
        alignment: TextAlign.start,
        textStyle: MKStyle.t14R.copyWith(color: ResourceColors.color_000000),
      ),
      'OK',
      "OK".tr(),
      okEvent: () async {},
      cancelEvent: () {},
    );
  }

  /// Dialog to get list photo or take a photo
  showPhotoDialog(BuildContext context) async {
    await CommonDialog.displayPhotoDialog(
        context,
        TextWidget(
          label: "DELETE_QUESTION_SELECTED".tr(),
          textStyle: MKStyle.t14R.copyWith(color: ResourceColors.color_000000),
          alignment: TextAlign.start,
        ),
        'DELETE'.tr(),
        "CANCEL".tr(),
        takePhotoEvent: () async {
          final XFile? image = await widget.picker.pickImage(
            source: ImageSource.camera,
            maxWidth: 700,
            maxHeight: 700,
          );
          final Uint8List bytes = await image!.readAsBytes();
          widget.mListPhoto.add(PhotoManager(bmp: bytes, xfile: image));
          setState(() {});
        },
        cancelEvent: () {},
        selectEvent: () async {
          final XFile? image = await widget.picker.pickImage(
            source: ImageSource.gallery,
            maxWidth: 700,
            maxHeight: 700,
          );
          final Uint8List bytes = await image!.readAsBytes();
          widget.mListPhoto.add(PhotoManager(bmp: bytes, xfile: image));
          setState(() {});
        });
  }
}
