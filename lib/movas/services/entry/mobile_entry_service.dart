import 'package:calorie/main.dart';
import 'package:calorie/movas/models/entry.dart';
import 'package:calorie/movas/observables/entry_o.dart';
import 'package:calorie/movas/services/entry/base_entry_service.dart';
import 'package:calorie/movas/services/http/base_http_service.dart';
import 'package:calorie/movas/services/http/model/entry/entry_request.dart';
import 'package:calorie/movas/services/http/model/entry/entry_response.dart';
import 'package:calorie/screen/mobile/components/notification_dialog.dart';
import 'package:movas/movas.dart';

class EntryService extends BaseEntryService {
  final PublishSubject<AllEntries> allEntriesE;
  final BaseHttpService httpService;

  EntryService(this.allEntriesE, this.httpService);

  @override
  Future<void> createEntry(CreateEntryRequest request) async {
    try {
      print('createEntry ${request.toMap().toString()}');
      var response = await httpService.post(
          request: request,
          converter: (_) {
            print("createEntry $_");
            return _;
          });

      if (response['statusCode'] == 200) {
        // show dialog success

      } else {
        // show dialog failed

      }
    } catch (_) {
      // show dialog failed
      print("createEntry $_");

    }

    return;
  }

  @override
  Future<AllEntries?> getEntriesForUser(GetEntriesForUserRequest request) async {
    var response = await httpService.get(
        request: request,
        converter: (_) {
          print("getEntries $_");
          return GetEntriesResponse.fromMap(_);
        });
    if (response is GetEntriesResponse) {
      var allEntries = AllEntries.fromResponse(response);
      allEntriesE.add(allEntries);

      if (allEntries.passDailyCaloriesLimit ?? false) {
        showDailyLimitReachedReminder(navigatorKey.currentContext!);
      }
      if (allEntries.passMonthlyBudget ?? false){
        showMonthlyLimitReachedReminder(navigatorKey.currentContext!);
      }

      return allEntries;
    }
  }

  @override
  Future<AllEntries?> getEntries(GetEntriesRequest request) async {
    var response = await httpService.get(
        request: request,
        converter: (_) {
          // print("getEntries $_");
          return GetEntriesResponse.fromMap(_);
        });
    if (response is GetEntriesResponse) {
      var allEntries = AllEntries.fromResponse(response);
      allEntriesE.add(allEntries);

      if (allEntries.passDailyCaloriesLimit ?? false) {
        showDailyLimitReachedReminder(navigatorKey.currentContext!);
      }
      if (allEntries.passMonthlyBudget ?? false){
        showMonthlyLimitReachedReminder(navigatorKey.currentContext!);
      }

      return null;
    }
  }

  @override
  Future<void> resetEntries() async {
    return allEntriesE.add(AllEntries([], 0, 0, false, false));
  }

  @override
  Future<void> deleteEntry(DeleteEntryRequest request) {
    // TODO: implement deleteEntry
    throw UnimplementedError();
  }

  @override
  Future<void> updateEntry(UpdateEntryRequest request) {
    // TODO: implement updateEntry
    throw UnimplementedError();
  }

}