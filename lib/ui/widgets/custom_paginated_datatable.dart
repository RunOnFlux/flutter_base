import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

typedef OnRowChange = void Function(int? index)?;

class CustomPaginatedTable extends StatelessWidget {
  const CustomPaginatedTable({
    Key? key,
    this.rowsPerPage = PaginatedDataTable.defaultRowsPerPage,
    required AsyncDataTableSource source,
    required List<DataColumn> dataColumns,
    Widget? header,
    bool showActions = false,
    List<Widget>? actions,
    required this.sortColumnIndex,
    this.sortColumnAsc = true,
    this.onRowChanged,
    this.smRatio = 0.4,
    this.lmRatio = 1.5,
    this.dataRowHeight,
    this.headingRowHeight,
  })  : _source = source,
        _dataColumns = dataColumns,
        _header = header,
        _showActions = showActions,
        _actions = actions,
        assert((sortColumnIndex >= 0 && sortColumnIndex < dataColumns.length), 'Check the sortColumnIndex value'),
        super(key: key);

  /// This is the source / model which will be binded
  ///
  /// to each item in the Row...
  final AsyncDataTableSource _source;

  /// This is the list of columns which will be shown
  ///
  /// at the top of the DataTable.
  final List<DataColumn> _dataColumns;

  final Widget? _header;
  final bool _showActions;
  final List<Widget>? _actions;
  final int rowsPerPage;
  final int sortColumnIndex;
  final bool sortColumnAsc;
  final double? dataRowHeight;
  final double? headingRowHeight;

  final double smRatio;
  final double lmRatio;

  final OnRowChange onRowChanged;

  AsyncDataTableSource get _fetchDataTableSource {
    return _source;
  }

  List<DataColumn> get _fetchDataColumns {
    return _dataColumns;
  }

  Widget? get _fetchHeader {
    return _header;
  }

  List<Widget>? get _fetchActions {
    if (_showActions) {
      return _actions;
    } else if (!_showActions) {
      return null;
    }

    return _defAction;
  }

  @override
  Widget build(BuildContext context) {
    //
    return AsyncPaginatedDataTable2(
      actions: _fetchActions,
      columns: _fetchDataColumns,
      header: _fetchHeader,
      onRowsPerPageChanged: onRowChanged,
      rowsPerPage: rowsPerPage,
      source: _fetchDataTableSource,
      sortColumnIndex: sortColumnIndex,
      sortAscending: sortColumnAsc,
      smRatio: smRatio,
      lmRatio: lmRatio,
      columnSpacing: 10,
      horizontalMargin: 2,
      dataRowHeight: dataRowHeight ?? kMinInteractiveDimension,
      headingRowHeight: headingRowHeight ?? 56,
      wrapInCard: false,
    );
  }
}

class SampleSource extends DataTableSource {
  @override
  DataRow getRow(int index) {
    //

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text('row #$index')),
        DataCell(Text('name #$index')),
      ],
    );
  }

  @override
  int get rowCount => 10;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}

/*class _DefaultSource extends DataTableSource {
  @override
  DataRow getRow(int index) => DataRow.byIndex(
        index: index,
        cells: [
          DataCell(Text('row #$index')),
          DataCell(Text('name #$index')),
        ],
      );
  @override
  int get rowCount => 10;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

final _defColumns = <DataColumn>[
  const DataColumn(label: Text('row')),
  const DataColumn(label: Text('name')),
];*/

final _defAction = <Widget>[
  IconButton(
    icon: const Icon(Icons.info_outline),
    onPressed: () {},
  ),
];
