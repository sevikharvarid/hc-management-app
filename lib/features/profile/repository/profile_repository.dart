import 'package:hc_management_app/domain/provider/profile_provider.dart';
import 'package:hc_management_app/domain/service/data_response.dart';
import 'package:hc_management_app/domain/service/throw_exception.dart';
import 'package:hc_management_app/shared/utils/helpers/connectivity_helper.dart';

class ProfileRepository {
  ConnectivityHelper connectivityHelper = ConnectivityHelper();
  ProfileProvider profileProvider = ProfileProvider();

  Future<DataResponse<String>> getProfile(dynamic params) async {
    try {
      if (!await connectivityHelper.checkConnectivityStatus()) {
        return const DataResponse.noConnection();
      }

      var response = await profileProvider.getProfile(params);

      if (response!["responseCode"] == 200) {
        return DataResponse.success(data: response["data"]["data"]);
      } else {
        return DataResponse.error(message: response['message'].toString());
      }
    } on RequestTimeoutException {
      return const DataResponse.requestTimeOut();
    }
  }

  Future<DataResponse<String>> updateProfile(dynamic params) async {
    try {
      if (!await connectivityHelper.checkConnectivityStatus()) {
        return const DataResponse.noConnection();
      }

      var response = await profileProvider.updateProfile(params);

      if (response!["responseCode"] == 200) {
        return DataResponse.success(data: response["data"]["data"]);
      } else {
        return DataResponse.error(message: response['message'].toString());
      }
    } on RequestTimeoutException {
      return const DataResponse.requestTimeOut();
    }
  }
}
