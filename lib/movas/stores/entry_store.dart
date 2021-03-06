import 'package:calorie/movas/models/entry.dart';
import 'package:calorie/movas/observables/entry_o.dart';
import 'package:movas/movas.dart';
import 'package:movas/provider/provider.dart';

class AllEntriesStore extends Store<AllEntriesO> {
  AllEntriesStore(PublishSubject<AllEntries> entries) {
    add(AllEntriesO([], 0, 0, false, false, 0, 0));

    listen(entries, (p0) async {
      add(AllEntriesO.fromEntity(p0 as AllEntries));
    });
  }
}


class EntriesMetadataStore extends Store<EntryMetaDataO> {
  EntriesMetadataStore(PublishSubject<EntryMetaData> meta) {
    add(EntryMetaDataO(0, 0, 0, 0, 0));

    listen(meta, (p0) async {
      add(EntryMetaDataO.fromEntity(p0 as EntryMetaData));
    });
  }
}
