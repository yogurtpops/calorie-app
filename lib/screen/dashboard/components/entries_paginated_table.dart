import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:calorie/main.dart';
import 'package:calorie/movas/actions/entry_action.dart';
import 'package:calorie/movas/models/entry.dart';
import 'package:calorie/movas/observables/entry_o.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EntryPaginatedTable extends StatefulWidget {
  final SelectedCallBack selectedCallBack;

  const EntryPaginatedTable({Key? key, required this.selectedCallBack}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EntryPaginatedTableState(DataSource(selectedCallBack));
  }
}

class EntryPaginatedTableState extends State<EntryPaginatedTable> {
  var rowsPerPage = AdvancedPaginatedDataTable.defaultRowsPerPage;
  final DataSource source;

  EntryPaginatedTableState(this.source);

  Future<void> refreshSource() async {

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16))),
      child: AdvancedPaginatedDataTable(
        source: source,
        addEmptyRows: false,
        showCheckboxColumn: true,
        showFirstLastButtons: true,
        rowsPerPage: rowsPerPage,
        availableRowsPerPage: [1, 5, 10, 50],
        onRowsPerPageChanged: (newRowsPerPage) {
          if (newRowsPerPage != null) {
            setState(() {
              rowsPerPage = newRowsPerPage;
            });
          }
        },
        columns: [
          DataColumn(label: Text('Food Name')),
          DataColumn(label: Text('Calories (cal)')),
          DataColumn(label: Text('Price (USD)')),
          DataColumn(label: Text('User ID')),
          DataColumn(
            label: Text("Created At"),
          ),
        ],
      ),
    );
  }
}

class RowData {
  final int index;
  final String value;

  RowData(this.index, this.value);
}

typedef SelectedCallBack = Function(EntryO object, bool newSelectState);

class DataSource extends AdvancedDataTableSource<EntryO> {
  final data = <EntryO>[];
  List<String> selectedIds = [];
  final SelectedCallBack selectedCallBack;

  DataSource(this.selectedCallBack);

  @override
  int get selectedRowCount => selectedIds.length;

  @override
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
    return DataRow(
        onSelectChanged: (selected) {
          if (selectedIds.contains(currentRowData.id)) {
            selectedIds.remove(currentRowData.id);
          } else {
            selectedIds.add(currentRowData.id);
          }
          selectedCallBack?.call(currentRowData, selectedIds.contains(currentRowData.id));
          notifyListeners();
        },
        selected: selectedIds.contains(data[index].id),
        cells: [
      DataCell(
        Text(currentRowData.name.toString()),
      ),
      DataCell(
        Text(currentRowData.calories.toString()),
      ),
      DataCell(
        Text(currentRowData.price.toString()),
      ),
      DataCell(
        Text(currentRowData.userId),
      ),
      DataCell(
        Text("25-05-2022")
        // Text(currentRowData.createdAt),
      )
    ]);
  }

  void selectedRow(String id, bool newSelectState) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    notifyListeners();
  }

  @override
  Future<RemoteDataSourceDetails<EntryO>> getNextPage(
      NextPageRequest pageRequest) async {

    var response = await EntryAction.of(navigatorKey.currentContext!).getEntries();
    if (response is AllEntries) {
      for (var i in response.allEntries) {
        data.add(EntryO.fromEntity(i));
      }
    }

    return RemoteDataSourceDetails(
      data.length,
      data
    );
  }
}