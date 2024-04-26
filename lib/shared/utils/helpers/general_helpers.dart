import 'package:geolocator/geolocator.dart';
import 'package:hc_management_app/shared/utils/constant/app_constant.dart';
import 'package:intl/intl.dart';

class GeneralHelper {
  Future<double> getPositionRadius(
    double? latitude,
    double? longitude,
  ) async {
    Position? currentPosition = await Geolocator.getCurrentPosition();
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
}
