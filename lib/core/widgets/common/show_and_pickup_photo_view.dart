import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/util/image_type_enum.dart';
import 'package:mirukuru/core/util/image_util.dart';
import 'package:mirukuru/core/widgets/common/show_detail_photo.dart';

import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/core_widget.dart';
import 'package:mirukuru/features/menu_widget_test/pages/button_widget.dart';

class ShowAndPickupPhotoView extends StatefulWidget {
  final List<PhotoData> photos;
  final BuildContext context;
  final Function(List<PhotoData>) onPhotoSelected;
  final Function(List<PhotoData>) onPhotoDeleted;
  final bool isGridViewTypeDisplay;

  const ShowAndPickupPhotoView({
    super.key,
    required this.photos,
    required this.context,
    required this.onPhotoSelected,
    required this.onPhotoDeleted,
    this.isGridViewTypeDisplay = false,
  });

  @override
  _ShowAndPickupPhotoViewState createState() => _ShowAndPickupPhotoViewState();
}

class _ShowAndPickupPhotoViewState extends State<ShowAndPickupPhotoView> {
  List<PhotoData> mPhotoList = [];
  List<PhotoData> mDeletedNetworkPhotos = [];
  List<PhotoData> mPhotosNeedToUpload = [];
  late ImagePicker mImagePicker;

  late double height = MediaQuery.of(widget.context).size.height / 8.5;
  late double width = MediaQuery.of(widget.context).size.width / 4.0;

  late ScrollController horizontalScrollController = ScrollController();

  Widget _errorBuilder(
          BuildContext context, Object object, StackTrace? stackTrace) =>
      Image.asset(
        fit: BoxFit.fill,
        width: MediaQuery.of(widget.context).size.width,
        'assets/images/png/no_image_s.png',
      );

  @override
  void initState() {
    _sortPhotosByKey();
    mImagePicker = new ImagePicker();
    super.initState();
  }

  _sortPhotosByKey() {
    widget.photos
        .sort((previous, current) => previous.key > current.key ? 1 : -1);
    mPhotoList = widget.photos;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _showImageWithGridView(mPhotoList, context),
        _buildButtonPickupAPhoto(context),
      ],
    );
  }

  Widget _showImageWithGridView(List<PhotoData> photos, BuildContext context) {
    return photos.length > 0
        ? widget.isGridViewTypeDisplay
            ? Padding(
                padding: EdgeInsets.only(
                  top: Dimens.getHeight(10.0),
                  bottom: Dimens.getHeight(10.0),
                ),
                child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisSpacing: Dimens.getWidth(13.0),
                    mainAxisSpacing: Dimens.getHeight(15.0),
                    crossAxisCount: 3,
                    children: List.generate(photos.length, (index) {
                      return FittedBox(
                          fit: BoxFit.fill,
                          child:
                              _buildSingleImageWidget(photos[index], context));
                    })),
              )
            : Padding(
                padding: EdgeInsets.only(
                    top: Dimens.getHeight(15.0),
                    bottom: Dimens.getHeight(15.0),
                    left: Dimens.getWidth(30.0),
                    right: Dimens.getWidth(30.0)),
                child: Container(
                  height: MediaQuery.of(widget.context).size.height / 8.5,
                  alignment: Alignment.centerLeft,
                  child: GridView.builder(
                    controller: horizontalScrollController,
                    physics: BouncingScrollPhysics(),
                    itemCount: photos.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: Dimens.getWidth(5.0),
                      mainAxisSpacing: Dimens.getWidth(10.0),
                      mainAxisExtent: width,
                      childAspectRatio: 1.375,
                    ),
                    itemBuilder: (context, index) {
                      return _buildSingleImageWidget(photos[index], context);
                    },
                  ),
                ),
              )
        : SizedBox.shrink();
  }

  Widget _buildSingleImageWidget(PhotoData data, BuildContext context) {
    return InkWell(
      onTap: () async {
        var isDelete = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ShowPhoto(
                child: _getImageWidget(data.photo),
              );
            },
          ),
        );

        if (isDelete != null) {
          isDelete as bool;
          if (isDelete) {
            mPhotoList.remove(data);
            if (ImageTypeExtension.getTypeFromExtension(data.photo) ==
                ImageTypeEnum.NETWORK_IMAGE) {
              mDeletedNetworkPhotos.add(data);
            } else {
              mPhotosNeedToUpload.remove(data);
            }
            widget.onPhotoDeleted(mDeletedNetworkPhotos);
            setState(() {});
          }
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            color: ResourceColors.color_0e67ed,
          ),
          _getImageWidget(data.photo, width: width, height: height)
        ],
      ),
    );
  }

  Widget _buildButtonPickupAPhoto(BuildContext context) {
    return ButtonWidget(
      content: "TAKE_AND_SELECT_A_PHOTO".tr(),
      bgdColor: ResourceColors.color_0FA4EA,
      borderRadius: Dimens.getWidth(20.0),
      width: MediaQuery.of(context).size.width / 1.5,
      textStyle: MKStyle.t14R.copyWith(color: ResourceColors.color_white),
      heightText: 1.2,
      clickButtonCallBack: () => pickupAPhoto(context),
    );
  }

  pickupAPhoto(BuildContext context) async {
    if (mPhotoList.length >= 6) {
      showPhotoLengthWarningDialog(context);
      return;
    }
    showPhotoDialog(context);
  }

  showPhotoLengthWarningDialog(BuildContext context) async {
    await CommonDialog.displayConfirmOneButtonDialog(
      context,
      TextWidget(
        label: "UP_TO_6_PHOTOS_CAN_BE_UPLOAD".tr(),
        textStyle: MKStyle.t14R,
        alignment: TextAlign.start,
      ),
      'OK',
      "OK".tr(),
      okEvent: () async {},
      cancelEvent: () {},
    );
  }

  showPhotoDialog(BuildContext context) async {
    await CommonDialog.displayPhotoDialog(
        context,
        TextWidget(
          label: "DELETE_QUESTION_SELECTED".tr(),
          textStyle: MKStyle.t14R,
          alignment: TextAlign.start,
        ),
        'DELETE'.tr(),
        "CANCEL".tr(),
        takePhotoEvent: () =>
            _updatePhotoAfterPicked(source: ImageSource.camera),
        cancelEvent: () {},
        selectEvent: _updatePhotoAfterPicked);
  }

  void _updatePhotoAfterPicked(
      {ImageSource source = ImageSource.gallery}) async {
    final XFile? image = await mImagePicker.pickImage(
      source: source,
      imageQuality: 100,
      maxHeight: ImageUtil.DEFAULT_VIEW_HEIGHT * 2,
      maxWidth: ImageUtil.DEFAULT_VIEW_WIDTH * 2,
    );
    if (image == null) return;

    // fix orientation and crop image before showing to user
    var fixedFile =
        await ImageUtil.instance.fixOrientationOfPhoto(File(image.path));
    var fixedXfile = XFile(fixedFile!.path);

    setState(() {
      var photoData = PhotoData.selectNewPhoto(
          photoDataList: mPhotoList, photo: fixedXfile);
      mPhotoList.add(photoData);
      mPhotosNeedToUpload.add(photoData);
      widget.onPhotoSelected(mPhotosNeedToUpload);

      if (!widget.isGridViewTypeDisplay) {
        scrollToBottom(horizontalScrollController);
      }
    });
  }

  Widget _getImageWidget(dynamic data, {double? width, double? height}) {
    var imageType = ImageTypeExtension.getTypeFromExtension(data);

    switch (imageType) {
      case ImageTypeEnum.UINT8LIST:
        return Image.memory(
          data,
          height: height,
          width: width,
          errorBuilder: _errorBuilder,
          fit: BoxFit.fill,
          filterQuality: FilterQuality.high,
        );
      case ImageTypeEnum.FILE:
        return Image.file(
          data as File,
          height: height,
          width: width,
          errorBuilder: _errorBuilder,
          fit: BoxFit.fill,
          filterQuality: FilterQuality.high,
        );
      case ImageTypeEnum.XFILE:
        XFile xFile = data;

        return Image.file(
          File(xFile.path),
          height: height,
          width: width,
          errorBuilder: _errorBuilder,
          fit: BoxFit.fill,
          filterQuality: FilterQuality.high,
        );
      case ImageTypeEnum.NETWORK_IMAGE:
        return FadeInImage.assetNetwork(
          image: data as String,
          height: height,
          width: width,
          fit: BoxFit.fill,
          imageErrorBuilder: _errorBuilder,
          placeholder: 'assets/images/png/no_image_s.png',
          placeholderFit: BoxFit.fill,
        );
      case ImageTypeEnum.ASSET_SVG:
        return SvgPicture.asset(
          data,
          height: height,
          width: width,
          placeholderBuilder: (context) => _errorBuilder(context, data, null),
          fit: BoxFit.fill,
        );
      case ImageTypeEnum.ASSET_IMAGE:
        return Image.asset(
          data,
          height: height,
          width: width,
          errorBuilder: _errorBuilder,
          fit: BoxFit.fill,
          filterQuality: FilterQuality.high,
        );
      default:
        return Image.asset(
          data,
          height: height,
          width: width,
          errorBuilder: _errorBuilder,
          fit: BoxFit.fill,
          filterQuality: FilterQuality.high,
        );
    }
  }

  void scrollToBottom(ScrollController scrollController) {
    var elementsInAMaxScrollExtent = MediaQuery.of(context).size.width ~/
        (width + Dimens.getWidth(5.0) * (mPhotoList.length - 2));

    if (mPhotoList.length > elementsInAMaxScrollExtent) {
      var offset = width * (mPhotoList.length - elementsInAMaxScrollExtent) +
          Dimens.getWidth(5.0) * (mPhotoList.length - 1);
      scrollController.animateTo(
        offset,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 500),
      );
    }
  }
}

class PhotoData {
  int key;
  dynamic photo;

  PhotoData({
    required this.key,
    required this.photo,
  });

  PhotoData.selectNewPhoto({
    List<PhotoData>? photoDataList,
    required this.photo,
  }) : this.key = getRemainingKey(photoDataList ?? []);

  static int getRemainingKey(List<PhotoData> photoDataList) {
    var validKeys = [0, 1, 2, 3, 4, 5];
    if (photoDataList.isNotEmpty) {
      validKeys.retainWhere(
          (element) => !photoDataList.map((e) => e.key).contains(element));
    }

    if (validKeys.isEmpty) {
      return -1;
    }
    return validKeys.first;
  }

  static List<PhotoData> convertFrom(List<String> networkPhotos) {
    return networkPhotos.map((networkPhoto) {
      var orderFromFileName = networkPhoto.split("/").last.split(".").first;
      var order = int.tryParse(orderFromFileName) ?? 0;

      return PhotoData(
          key: order, photo: Common.userCarImagesUrl + networkPhoto);
    }).toList();
  }
}
