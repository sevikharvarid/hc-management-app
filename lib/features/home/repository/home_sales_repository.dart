import 'package:hc_management_app/domain/provider/home_sales_provider.dart';
import 'package:hc_management_app/domain/service/data_response.dart';
import 'package:hc_management_app/domain/service/throw_exception.dart';
import 'package:hc_management_app/shared/utils/helpers/connectivity_helper.dart';

class HomeSalesRepository {
  ConnectivityHelper connectivityHelper = ConnectivityHelper();
  HomeSalesProvider homeSpgProvider = HomeSalesProvider();

  Future<DataResponse<String>> getHistoryVisits(dynamic params) async {
    try {
      if (!await connectivityHelper.checkConnectivityStatus()) {
        return const DataResponse.noConnection();
      }

      var response = await homeSpgProvider.getHistoryVisits(params);

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
