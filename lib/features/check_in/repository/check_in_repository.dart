import 'package:hc_management_app/domain/provider/check_in_provider.dart';
import 'package:hc_management_app/domain/service/data_response.dart';
import 'package:hc_management_app/domain/service/throw_exception.dart';
import 'package:hc_management_app/shared/utils/helpers/connectivity_helper.dart';

class CheckInRepository {
  ConnectivityHelper connectivityHelper = ConnectivityHelper();
  CheckInProvider checkInProvider = CheckInProvider();

  Future<DataResponse<String>> getStoreData(dynamic params) async {
    try {
      if (!await connectivityHelper.checkConnectivityStatus()) {
        return const DataResponse.noConnection();
      }

      var response = await checkInProvider.getStoreData(params);

      if (response!["responseCode"] == 200) {
        return DataResponse.success(data: response["data"]["data"]);
      } else {
        return DataResponse.error(message: response['message'].toString());
      }
    } on RequestTimeoutException {
      return const DataResponse.requestTimeOut();
    }
  }

  Future<DataResponse<String>> postSubmitData(dynamic body) async {
    try {
      if (!await connectivityHelper.checkConnectivityStatus()) {
        return const DataResponse.noConnection();
      }

      var response = await checkInProvider.postSubmitVisit(body);

      if (response!["responseCode"] == 200) {
        return DataResponse.success(data: response['data']);
      } else {
        return DataResponse.error(message: response['message']);
      }
    } on RequestTimeoutException {
      return const DataResponse.requestTimeOut();
    }
  }
}
