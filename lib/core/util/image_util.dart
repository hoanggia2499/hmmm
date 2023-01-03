import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img_lib;
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/core/widgets/common/show_and_pickup_photo_view.dart';
import 'package:path/path.dart';

class ImageUtil {
  ImageUtil._internal();

  static final ImageUtil instance = ImageUtil._internal();

  /// UPLOAD_PAYLOAD_SIZE_MAX = 2.048MB
  static const _UPLOAD_PAYLOAD_SIZE_MAX = 2000 * 1024;

  /// UPLOAD_PAYLOAD_SIZE_MAX = 1.024MB
  static const _UPLOAD_FILE_SIZE_MAX = 1000 * 1024;

  /// _DEFAULT_IMAGE_RATIO = 700 / 700 ~ 1
  static const _DEFAULT_IMAGE_RATIO = 700 / 700;

  /// DEFAULT_PHOTO_MAX_SIZE = 700
  static const DEFAULT_PHOTO_MAX_SIZE = 700;

  /// DEFAULT_PHOTO_MIN_SIZE = 200
  static const DEFAULT_PHOTO_MIN_SIZE = 200;

  /// DEFAULT_VIEW_WIDTH = 700
  static const DEFAULT_VIEW_WIDTH = 700;

  /// DEFAULT_VIEW_HEIGHT = 700
  static const DEFAULT_VIEW_HEIGHT = 700;

  final List<String> acceptedImageExtension = [
    'jpg',
    'png',
    'jpeg',
    'heic',
    'heif'
  ];

  factory ImageUtil() {
    return instance;
  }

  bool isAcceptExtension(String ext) {
    return acceptedImageExtension.contains(ext);
  }

  Future<Uint8List> combineImagesNative(
      String partFile, String partFileBackground) async {
    var orientationFixedFile;
    // Compress an image file
    var resultFileFixOrientation = await fixOrientationOfPhoto(File(partFile));
    if (resultFileFixOrientation == null) {
      orientationFixedFile = File(partFile);
    } else {
      orientationFixedFile = resultFileFixOrientation;
    }
    var imageProps =
        await FlutterNativeImage.getImageProperties(orientationFixedFile!.path);
    var imageWidth = imageProps.width!;
    var imageHeight = imageProps.height!;
    Logging.log.info('imageProps: width=$imageWidth, height=$imageHeight');
    var background =
        (await rootBundle.load(partFileBackground)).buffer.asUint8List();
    final backgroundProps = img_lib.decodeImage(background)!;

    var backgroundWidth = backgroundProps.width;
    var backgroundHeight = backgroundProps.height;
    Logging.log.info(
        'backgroundProps: width=$backgroundWidth, height=$backgroundHeight');
    Logging.log.info('begin combine');
    late Uint8List byteImageResize;
    if (imageWidth == backgroundWidth && imageHeight == backgroundHeight) {
      // Image size is the same with screen size
      byteImageResize =
          Uint8List.fromList(orientationFixedFile.readAsBytesSync());
    } else {
      var sizeRatio = imageWidth / imageHeight;

      var backgroundSizeRatio = backgroundWidth / backgroundHeight;
      if ((sizeRatio < 1 && backgroundSizeRatio < 1) ||
          (sizeRatio > 1 && backgroundSizeRatio > 1)) {
        byteImageResize = await resize(
            orientationFixedFile.path, backgroundWidth, backgroundHeight);
      } else {
        var scale =
            min(backgroundWidth / imageWidth, backgroundHeight / imageHeight);
        byteImageResize = await resize(orientationFixedFile.path,
            (imageWidth * scale).round(), (imageHeight * scale).round());

        final resized = img_lib.decodeImage(byteImageResize)!;
        Logging.log.info('resize image completed');
        Logging.log
            .info('resized: width=${resized.width}, height=${resized.height}');
        Logging.log.info('begin merge');

        Logging.log
            .info('img2: width=$backgroundWidth, height=$backgroundHeight');
        img_lib.copyInto(backgroundProps, resized, center: true, blend: false);
        Logging.log.info('combine completed');
        byteImageResize =
            Uint8List.fromList(img_lib.encodeJpg(backgroundProps));
      }
    }

    // Remove fixed file before returns
    if (resultFileFixOrientation != null) {
      orientationFixedFile.deleteSync();
    }
    return byteImageResize;
  }

  Future<List<XFile?>?> compressMultiImage(
      List<PhotoData> photoDataList) async {
    var totalOriginalImageLength = await photoDataList
        .map((e) => (e.photo as XFile).length())
        .reduce((value, element) async {
      return (await value + await element);
    });

    var scalePercent =
        (totalOriginalImageLength / _UPLOAD_PAYLOAD_SIZE_MAX).ceil();

    List<XFile?> scaledImages = [];

    for (PhotoData photoData in photoDataList) {
      var scaledImage = await compressSingleImage(photoData,
          scalePercent: scalePercent <= 1 ? 0 : scalePercent ~/ 2);
      scaledImages.add(scaledImage);
    }

    return scaledImages;
  }

  Future<List<XFile?>?> resizeMultiImage(List<PhotoData> photoDataList) async {
    List<XFile?> scaledImages = [];

    for (PhotoData photoData in photoDataList) {
      var scaledImage = await resizeSingleImage(photoData);
      scaledImages.add(scaledImage);
    }
    return scaledImages;
  }

  Future<XFile?> resizeSingleImage(PhotoData photoData) async {
    XFile oriImage = photoData.photo;

    var newImagePath = generateFilePath(File(oriImage.path),
        customFileName: photoData.key.toString());
    final imageProp =
        await FlutterNativeImage.getImageProperties(oriImage.path);

    final double scale;
    if (imageProp.orientation == ImageOrientation.rotate90 ||
        imageProp.orientation == ImageOrientation.rotate270) {
      scale = min(DEFAULT_VIEW_WIDTH / (imageProp.width! * 2),
          DEFAULT_VIEW_HEIGHT / (imageProp.height! * 2));
    } else {
      scale = min(DEFAULT_VIEW_WIDTH / imageProp.width!,
          DEFAULT_VIEW_HEIGHT / imageProp.height!);
    }
    final targetHeight = (imageProp.height! * scale).round();
    final targetWidth = (imageProp.width! * scale).round();

    var scaledImageFile = await FlutterImageCompress.compressAndGetFile(
        oriImage.path, newImagePath,
        minHeight: targetHeight,
        minWidth: targetWidth,
        quality: 99,
        format: getCompressFormat(newImagePath));

    return scaledImageFile != null
        ? XFile(scaledImageFile.path,
            length: scaledImageFile.lengthSync(),
            bytes: scaledImageFile.readAsBytesSync(),
            lastModified: scaledImageFile.lastModifiedSync())
        : null;
  }

  Future<XFile?> compressSingleImage(PhotoData photoData,
      {int scalePercent = 0}) async {
    XFile oriImage = photoData.photo;

    var newImagePath = generateFilePath(File(oriImage.path),
        customFileName: photoData.key.toString());

    File? scaledImageFile;
    var scalePercentBySingleFile = scalePercent;
    var imageLength = await oriImage.length();
    var imageProp = await FlutterNativeImage.getImageProperties(oriImage.path);

    await Future.doWhile(() async {
      var targetWidth = (imageProp.width! /
              (scalePercentBySingleFile != 0 ? scalePercentBySingleFile : 1))
          .floor()
          .clamp(DEFAULT_PHOTO_MIN_SIZE, DEFAULT_PHOTO_MAX_SIZE);

      var minTargetHeight =
          DEFAULT_PHOTO_MIN_SIZE * (imageProp.height! / imageProp.width!);
      var maxTargetHeight =
          DEFAULT_PHOTO_MAX_SIZE * (imageProp.height! / imageProp.width!);

      var targetHeight = (imageProp.height! /
              (scalePercentBySingleFile != 0 ? scalePercentBySingleFile : 1))
          .floor()
          .clamp(minTargetHeight.ceil(), maxTargetHeight.ceil());

      scaledImageFile = await FlutterImageCompress.compressAndGetFile(
          oriImage.path, newImagePath,
          minHeight: targetHeight,
          minWidth: targetWidth,
          format: getCompressFormat(newImagePath));

      imageLength = scaledImageFile!.lengthSync();

      if (imageLength <= _UPLOAD_FILE_SIZE_MAX) {
        return false;
      }
      scalePercentBySingleFile += (imageLength / _UPLOAD_FILE_SIZE_MAX).ceil();
      return true;
    });

    if (scaledImageFile == null) {
      return null;
    }

    return scaledImageFile != null
        ? XFile(scaledImageFile!.path,
            length: scaledImageFile!.lengthSync(),
            bytes: scaledImageFile!.readAsBytesSync(),
            lastModified: scaledImageFile!.lastModifiedSync())
        : null;
  }

  Future<File?> fixOrientationOfPhoto(File file) async {
    var decodedImage = img_lib.decodeImage(await file.readAsBytes());
    img_lib.Image fixedImage;
    var tempFile = await file.copy(generateFilePath(file,
        customFileName:
            "${basenameWithoutExtension(file.path)}_fix_orientation"));

    if (decodedImage != null) {
      // fix wrong orientation
      fixedImage = img_lib.bakeOrientation(decodedImage);

      final fixedFile = await tempFile.writeAsBytes(
          img_lib.encodeJpg(fixedImage),
          mode: FileMode.append,
          flush: true);

      return fixedFile;
    }

    return file;
  }

  Future<ImageOrientation?> getOrientationOfPhoto(File file) async {
    final decodedImage = img_lib.decodeImage(await file.readAsBytes());

    if (decodedImage != null) {
      int orientation = decodedImage.exif.orientation;
      return ImageOrientationExtension.decodeOrientation(orientation);
    }
    return null;
  }

  // Crop image to new image with image ratio (height/width)
  // Return cropped file path
  Future<String> cropImage(String imagePath,
      {double imageRatio = _DEFAULT_IMAGE_RATIO,
      bool needToFixOrientation = true}) async {
    File? fixedFile = File(imagePath);

    var decodedImage = img_lib.decodeImage(await fixedFile.readAsBytes());

    // fix orientation before cropping image
    if (needToFixOrientation) {
      fixedFile = await fixOrientationOfPhoto(fixedFile);
    }

    var originalWidth = decodedImage!.width;
    var originalHeight = decodedImage.height;

    int cropWidth;
    int cropHeight;
    var offsetWidth = 0;
    var offsetHeight = 0;
    if (originalHeight / originalWidth == _DEFAULT_IMAGE_RATIO) {
      return imagePath;
    } else if (originalHeight / originalWidth > imageRatio) {
      cropHeight = (originalWidth * imageRatio).floor();
      cropWidth = originalWidth;
      offsetHeight = ((originalHeight - cropHeight) / 2).floor();
    } else {
      cropHeight = originalHeight;
      cropWidth = (originalHeight * (1 / imageRatio)).floor();
      offsetWidth = ((originalWidth - cropWidth) / 2).floor();
    }
    Logging.log.info(
        'cropWidth=${cropWidth.round()}, cropHeight=${cropHeight.round()}, offsetWidth=${offsetWidth.round()}, offsetHeight=${offsetHeight.round()}');

    var fixedImage = img_lib.copyCrop(
        decodedImage, offsetWidth, offsetHeight, cropWidth, cropHeight);

    Logging.log.info(
        'fixedImage: width=${fixedImage.width}, height="${fixedImage.height}');
    var cropFile = await fixedFile!.writeAsBytes(img_lib.encodeJpg(fixedImage));

    return cropFile.path;
  }

  // Resize image file to other size
  Future<Uint8List> resize(String filePath, int width, int height) async {
    var file = await FlutterNativeImage.compressImage(
      filePath,
      percentage: 100,
      quality: 100,
      targetWidth: width,
      targetHeight: height,
    );
    return file.readAsBytesSync();
  }

  List<MultipartFile>? convertFromXFiles(List<XFile?>? files) {
    if (files != null && files.isNotEmpty) {
      return files.map((e) {
        var fileNameAndExtension = e?.name.split(".");
        var fileName = fileNameAndExtension?[0];
        var fileExtension = fileNameAndExtension?[1];

        if (!(fileExtension != null &&
            fileExtension.isNotEmpty &&
            isAcceptExtension(fileExtension))) {
          fileExtension =
              getImageFileExtensionFromImageMimeType(e?.mimeType ?? "");
        }
        var newFileName = "$fileName.$fileExtension";

        return MultipartFile.fromFileSync(e?.path ?? "", filename: newFileName);
      }).toList();
    }
    return null;
  }

  File createNewImageFileWithCustomName(String imageName, XFile oldXFile,
      {Uint8List? newBytes}) {
    var tempFile = new File(oldXFile.path);
    if (newBytes != null) {
      tempFile.writeAsBytesSync(newBytes);
    }

    var imagePathDir = dirname(oldXFile.path);
    var newImagePath = join(imagePathDir,
        generateFileName(File(oldXFile.path), customFileName: imageName));

    return tempFile.renameSync(newImagePath);
  }

  String generateFileName(File file, {String? customFileName}) {
    var fileNameAndExtension = basename(file.path).split(".");

    var fileName = customFileName ?? fileNameAndExtension[0];
    var imgExtension = fileNameAndExtension[1];

    return "$fileName.$imgExtension";
  }

  String generateFilePath(File file, {String? customFileName}) {
    var imagePathDir = dirname(file.path);
    var newImageName = generateFileName(file, customFileName: customFileName);
    var newImagePath = join(imagePathDir, newImageName);
    return newImagePath;
  }

  static CompressFormat getCompressFormat(String fileName) {
    final imgExtension = extension(fileName).toLowerCase();

    switch (imgExtension) {
      case ".png":
        return CompressFormat.png;
      case ".jpeg":
      case ".jpg":
        return CompressFormat.jpeg;
      case ".webp":
        return CompressFormat.webp;
      case ".heic":
        return CompressFormat.heic;
      default:
        return CompressFormat.jpeg;
    }
  }

  String getImageFileExtensionFromImageMimeType(String mimeType) {
    switch (mimeType) {
      case "image/png":
        return ".png";
      case "image/gif":
        return ".gif";
      case "image/jpeg":
        return ".jpg";
      case "image/bmp":
        return ".bmp";
      case "image/tiff":
        return ".tiff";
      case "image/wmf":
        return ".wmf";
      case "image/jp2":
        return ".jp2";
      case "image/svg+xml":
        return ".svg";
      case "application/octet-stream":
        return ".jpg";
      default:
        return "";
    }
  }
}

enum ImageOrientation {
  normal, // landscape
  rotate90, // portrait
  rotate180,
  rotate270,
  flipHorizontal,
  flipVertical,
  transpose,
  transverse,
  undefined,
}

extension ImageOrientationExtension on ImageOrientation {
  static ImageOrientation decodeOrientation(int? orientation) {
    switch (orientation) {
      case 1:
        return ImageOrientation.normal;
      case 2:
        return ImageOrientation.flipHorizontal;
      case 3:
        return ImageOrientation.rotate180;
      case 4:
        return ImageOrientation.flipVertical;
      case 5:
        return ImageOrientation.transpose;
      case 6:
        return ImageOrientation.rotate90;
      case 7:
        return ImageOrientation.transverse;
      case 8:
        return ImageOrientation.rotate270;
      default:
        return ImageOrientation.undefined;
    }
  }
}
