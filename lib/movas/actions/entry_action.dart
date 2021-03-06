import 'package:calorie/main.dart';
import 'package:calorie/movas/models/entry.dart';
import 'package:calorie/movas/services/entry/base_entry_service.dart';
import 'package:calorie/movas/services/http/model/entry/entry_request.dart';
import 'package:calorie/screen/mobile/components/notification_dialog.dart';
import 'package:calorie/screen/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:movas/provider/provider.dart';

class EntryAction {
  final BaseEntryService service;

  EntryAction(this.service);

  factory EntryAction.of(BuildContext context) => EntryAction(
      StaticProvider.of(context));

  Future<void> resetEntries() async {
    return service.resetEntries();
  }

  Future<AllEntries?> getEntries({DateTime? fromDate, DateTime? toDate, int? page}) async {
    resetEntries();
    var result = await service.getEntries(GetEntriesRequest(fromDate: fromDate, toDate: toDate, page: page));
    return result;
  }

  Future<EntryMetaData?> getMetadata() async {
    var result = await service.getMetaData(GetMetaDataRequest());
    return result;
  }

  Future<AllEntries?> getEntriesForUser({DateTime? fromDate, DateTime? toDate}) async {
    resetEntries();
    var result = await service.getEntriesForUser(GetEntriesForUserRequest(fromDate: fromDate, toDate: toDate));
    return result;
  }

  Future<void> createEntry(FoodEntry newEntry) async {
    return service.createEntry(CreateEntryRequest(
      name: newEntry.name,
      createdAt: newEntry.createdAt,
      price: newEntry.price,
      calories: newEntry.calories,
      userId: newEntry.user!.id
    ));
  }

  Future<void> updateEntry(
      String id,
      String name,
      double calories,
      double? price,
      String userId,
      DateTime createdAt) async {
    return service.updateEntry(UpdateEntryRequest(
        name: name,
        createdAt: createdAt,
        price: price,
        calories: calories,
        userId: userId,
        entryId: id
    ));
  }

  Future<void> deleteEntry(String entryId) async {
    return service.deleteEntry(DeleteEntryRequest(entryId: entryId));
  }

}