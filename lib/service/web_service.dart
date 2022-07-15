import 'package:http/http.dart' as http;
import 'package:yazilimreyonucom/model/job.dart';

import '../constants/application_constants.dart';

class WebService {
  Future<Object> fetchJobs() async {
    final response = await http.get(Uri.parse(ApplicationConstants.API_URL));
    if (response.statusCode == 200) {
      return jobFromJson(response.body);
    }
    return [];
  }
}
