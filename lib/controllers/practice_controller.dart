import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:presence_app/pages/loading_states.dart';

class PracticeController extends GetxController {

  final _logger = Logger(printer: PrettyPrinter());

  final practiceData = Rx<ApiResponse<Object>>(ApiResponse.initial());

  // Success
  Future<void> fetchDataSuccessfully() async {
    debugPrint('Fetching data... will succeed.');
    practiceData.value = ApiResponse.loading();
    _logger.d(practiceData.value.states);
    await Future.delayed(const Duration(seconds: 2));
    practiceData.value = ApiResponse.success(
      'This is the data from the server!',
    );
    debugPrint('Data fetched successfully');
  }

// Practice successfull method
  Future<void> fetchDataWithSuccessfully() async{
    await Future.delayed(const Duration(seconds: 2));
    practiceData.value = ApiResponse.success({'id':1,'name':'Mon Nat'});
  }

// Failure
  Future<void> fetchDataFailure() async{
    debugPrint("Fetching data... will fail");
    practiceData.value = ApiResponse.loading();
    await Future.delayed(const Duration(seconds:2));
    practiceData.value = ApiResponse.error("Error in fetching data.");
    debugPrint('Data fetch failure.');
  }

}
