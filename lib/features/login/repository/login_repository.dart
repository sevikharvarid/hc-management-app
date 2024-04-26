import 'package:hc_management_app/domain/provider/login_provider.dart';
import 'package:hc_management_app/domain/service/data_response.dart';
import 'package:hc_management_app/domain/service/throw_exception.dart';
import 'package:hc_management_app/shared/utils/helpers/connectivity_helper.dart';

class LoginRepository {
  ConnectivityHelper connectivityHelper = ConnectivityHelper();
  LoginProvider loginProvider = LoginProvider();

  Future<DataResponse<String>> postLogin(dynamic body) async {
    try {
      if (!await connectivityHelper.checkConnectivityStatus()) {
        return const DataResponse.noConnection();
      }

      var response = await loginProvider.postLogin(body);

      if (response!["responseCode"] == 200) {
        return DataResponse.success(data: response["data"]);
      } else {
        return DataResponse.error(message: response['message'].toString());
      }
    } on RequestTimeoutException {
      return const DataResponse.requestTimeOut();
    }
  }
}
