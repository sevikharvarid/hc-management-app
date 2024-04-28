import 'package:hc_management_app/domain/provider/history_spg_provider.dart';
import 'package:hc_management_app/domain/service/data_response.dart';
import 'package:hc_management_app/domain/service/throw_exception.dart';
import 'package:hc_management_app/shared/utils/helpers/connectivity_helper.dart';

class HistorySPGRepository {
  ConnectivityHelper connectivityHelper = ConnectivityHelper();
  HistorySPGProvider historySpgProvider = HistorySPGProvider();

  Future<DataResponse<String>> getHistoryAbsence(dynamic params) async {
    try {
      if (!await connectivityHelper.checkConnectivityStatus()) {
        return const DataResponse.noConnection();
      }

      var response = await historySpgProvider.getHistoryAbsence(params);

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
