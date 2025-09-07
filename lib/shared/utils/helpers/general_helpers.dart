import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hc_management_app/shared/utils/constant/app_constant.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class GeneralHelper {
  Future<double> getPositionRadius(
    double? latitude,
    double? longitude,
  ) async {
    Position? currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    String formattedValue = currentPosition.latitude.toStringAsFixed(15);
    double radius = Geolocator.distanceBetween(
      latitude!,
      longitude!,
      currentPosition.latitude,
      currentPosition.longitude,
    );

    return radius;
  }

  Future<Position> getCurrentPosition() async {
    Position? currentPosition = await Geolocator.getCurrentPosition();
    return currentPosition;
  }

  String? convertDateToString({
    DateTime? dateTime,
    String? dateFormat = "dd MMMM yyyy",
  }) {
    if (dateTime != null) {
      String date = DateFormat(
        dateFormat,
        AppConstant.locale,
      ).format(dateTime.toLocal());
      return date;
    }
    return null;
  }

  List<String> getMonthStartAndEndDate(String monthYear) {
    DateFormat dateFormat = DateFormat("MMMM y", "id");
    DateTime date = dateFormat.parse(monthYear);
    DateTime startDate = DateTime(date.year, date.month, 1);
    DateTime endDate = DateTime(date.year, date.month + 1, 0);
    DateFormat outputFormat = DateFormat("yyyy-MM-dd");
    return [outputFormat.format(startDate), outputFormat.format(endDate)];
  }

  DateTime? convertStringToDate({
    required String stringDate,
    String? dateFormat = "dd MMMM yyyy",
    bool utc = false,
  }) {
    if (stringDate.isNotEmpty) {
      DateTime date = DateFormat(
        dateFormat,
        AppConstant.locale,
      ).parse(stringDate, utc);
      return date;
    }
    return null;
  }

  List<DateTime> convertStringToMultipleDate({
    required String stringDate,
    String dateFormat = "dd MMMM yyyy",
    String splitPattern = " - ",
  }) {
    List<DateTime> result = [];
    List<String> splitData = stringDate.split(splitPattern);

    for (String data in splitData) {
      result.add(
        convertStringToDate(
          stringDate: data,
          dateFormat: dateFormat,
        )!,
      );
    }

    return result;
  }

  String? convertSingleOrRangeDate({
    List<DateTime?>? value,
  }) {
    String date = '';

    if (value!.length > 1) {
      date =
          "${DateFormat("dd MMMM yyyy", AppConstant.locale).format(value[0]!)} - ${DateFormat("dd MMMM yyyy", AppConstant.locale).format(value[1]!)}";
    } else {
      date = DateFormat("dd MMMM yyyy", AppConstant.locale)
          .format(value[0]!)
          .toString();
    }
    return date;
  }

  Future<File?> pickImage({bool? camera = true}) async {
    final ImagePicker picker = ImagePicker();
    XFile? pickerImage;

    pickerImage = await picker.pickImage(
      source: camera! ? ImageSource.camera : ImageSource.gallery,
      preferredCameraDevice: CameraDevice.rear,
      imageQuality: 50,
    );

    File? pickedImage;
    if (pickerImage != null) {
      pickedImage = File(pickerImage.path);
    }
    return pickedImage;
  }

  Future<File> convertImageToJpg({
    required File? file,
    int? quality,
  }) async {
    Directory tempDir = await getTemporaryDirectory();
    String temporaryPath = tempDir.path;

    String originalFileName = file!.path.split('/').last;
    originalFileName = originalFileName.split('.').first;

    final imageBytes = await file.readAsBytes();
    Image? image = decodeImage(Uint8List.fromList(imageBytes));

    final jpgBytes = encodeJpg(image!, quality: quality ?? 60);

    File jpgFile = File('$temporaryPath/$originalFileName.jpg');
    await jpgFile.writeAsBytes(jpgBytes);
    // Print the file size
    final fileSize = await jpgFile.length();
    log('File size: $fileSize bytes');

    return jpgFile;
  }

  bool validateImageSize({
    required File file,
    int maximumSize = 5,
  }) {
    int sizeInBytes = file.lengthSync();
    double imageSize = sizeInBytes / (1024 * 1024);
    return (imageSize <= maximumSize);
  }

  bool validateImageExtension({required File file}) {
    List<String> acceptedImaged = ["png", "jpg", "jpeg", "heic"];
    return acceptedImaged.contains(file.path.split(".").last);
  }

  Future<DateTime> getNtpTime() async {
    DateTime ntpTime = await NTP.now();
    return ntpTime;
  }

  Future<File?> compressAndConvertToJPG({
    required File file,
    required int? quality,
  }) async {
    // Get the temporary directory
    Directory tempDir = await getTemporaryDirectory();
    String temporaryPath = tempDir.path;

    // Get the original file name without extension
    String originalFileName = basenameWithoutExtension(file.path);

    // Compress and convert image to JPG
    final jpgBytes = await FlutterImageCompress.compressWithFile(
      file.path,
      format: CompressFormat.jpeg,
      quality: quality!,
    );

    if (jpgBytes == null) {
      return null;
    }

    // Save the JPG file
    File jpgFile = File('$temporaryPath/$originalFileName.jpg');
    await jpgFile.writeAsBytes(jpgBytes);

    return jpgFile;
  }

}
