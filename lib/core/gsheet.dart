import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

import 'package:googleapis/drive/v3.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:line_converter/core/typing.dart';

const List weekString = ['', '一', '二', '三', '四', '五', '六', '日'];

class GSheetExpection{
  String message;
  GSheetExpection({required this.message});
}

class GSheet {
  late final SheetsApi api;
  late final String credential;
  late final List<String> verifySheetTitle;
  late final AutoRefreshingAuthClient client;

  Future<void> initialize({String? credential}) async {
    if (credential == null) {
      final perfs = EncryptedSharedPreferences();
      credential = await perfs.getString('certificate');
    }

    client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(credential),
      ['https://www.googleapis.com/auth/spreadsheets',
      'https://www.googleapis.com/auth/drive.readonly',
      'https://www.googleapis.com/auth/spreadsheets.readonly'] 
    );
    api = SheetsApi(client);
    this.credential = credential;

    return;
  }

  Future<Sheet?> sheetByName({String? title}) async {
    if (title == null) {
      final perfs = EncryptedSharedPreferences();
      title = await perfs.getString('spreadsheetTitle');
    }
    final sheetsRes = api.spreadsheets;
    final sheetID = await EncryptedSharedPreferences().getString('sheetID');
    // print(sheetID);
    final spreadSheet = await sheetsRes.get(sheetID, includeGridData: true);
    final sheets = spreadSheet.sheets?.where((Sheet sheet) => sheet.properties?.title == title).toList();

    if (sheets == null) throw GSheetExpection(message: 'Sheet named $title not found');
    if (sheets.isEmpty) throw GSheetExpection(message: 'Sheet named $title not found');
    
    return sheets.first;
  }

  List<Request> unMergeReq(Sheet sheet, GridRange range) { 
    final merges = sheet.merges;
    if (merges == null) return [];

    final involved = merges.where((GridRange element) =>
      (element.startColumnIndex! < range.endColumnIndex! && 
       element.startRowIndex! < range.endRowIndex!)).toList();
    if (involved.isEmpty) return [];

    return involved.map((GridRange range) =>
      Request(
        unmergeCells: UnmergeCellsRequest(range: range)
      )).toList();
  }

  List<Request> clearAllData(Sheet sheet, GridRange range) {
    return  [ Request( // Clear cell value
      updateCells: UpdateCellsRequest(
        fields: '*',
        range: range,
        rows: [RowData(values: [
          CellData(
            formattedValue: '',
            userEnteredFormat: CellFormat(
              borders: Borders(
                bottom: Border(width: 0, style: 'NONE'),
                left: Border(width: 0, style: 'NONE'),
                top: Border(width: 0, style: 'NONE'),
                right: Border(width: 0, style: 'NONE')
              )
            )
          )
        ])]
      )
    )];
  }

  List<Request> sizeReq(GridRange range) {
    final sheetID = range.sheetId;
    final values = [('ROWS', 1, range.endRowIndex, 41), ('ROWS', 0, 1, 38), ('COLUMNS', 1, 6, 100)];

    return values.map((value) => Request(
      updateDimensionProperties: UpdateDimensionPropertiesRequest(
        fields: '*',
        range: DimensionRange(
          sheetId: sheetID,
          dimension: value.$1,
          startIndex: value.$2,
          endIndex: value.$3
        ),
        properties: DimensionProperties(
          pixelSize: value.$4
        )
      )
    )).toList();
  }

  List<Request> mergeReq(List<GridRange> ranges) {
    return ranges.map((value) =>
      Request(
        mergeCells: MergeCellsRequest(
          mergeType: 'MERGE_ALL',
          range: value
        )
      )
    ).toList();
  }

  List<Request> textStyleReq(GridRange range) {
    return [ Request(
      repeatCell: RepeatCellRequest(
        fields: '*',
        range: range,
        cell: CellData(
          userEnteredFormat: CellFormat(
            verticalAlignment: 'MIDDLE',
            horizontalAlignment: 'CENTER',
            textFormat: TextFormat(fontSize: 24),
            borders: Borders(
              top: Border(width: 1, style: 'SOLID'),
              left: Border(width: 1, style: 'SOLID'),
              right: Border(width: 1, style: 'SOLID'),
              bottom: Border(width: 1, style: 'SOLID')
            )
          )
        )
      )
    )];
  }

  Future<BatchUpdateValuesResponse> uploadSheet(Sheet sheet, List<CarData> result) async {
    List<List<String?>> column=[[null], [null], [null], [null], [null], [null] ];
    final Map<int, (int, int)> columnMap = {
      1: (0,1), 2: (2,3), 0:(4,5)
    };

    for (CarData data in result) {
      final index = columnMap[data.order%3];
      final passengers = data.passenger.come;
      if (index == null) continue;
      if (passengers == null) continue;
      column[index.$1] += ['第${data.order}車\n${data.serial.morning}', null, null, null];
      column[index.$2] += (passengers.length < 4) ? passengers+[''*(4-passengers.length)] : passengers;
    }
    // print(result.length);
    final dt = result.first.addTime.add(const Duration(days: 1));
    final sheetTitle = sheet.properties!.title!;
    final req = BatchUpdateValuesRequest(
      valueInputOption: 'USER_ENTERED',
      data: [
        ValueRange(
          majorDimension: 'ROWS',
          range: '$sheetTitle!A1:F1',
          values: [['${dt.year}年${dt.month}月${dt.day}日 (${weekString[dt.weekday]})']]
        ),
        ValueRange(
          majorDimension: 'COLUMNS',
          range: '$sheetTitle!A1:F${(result.length/3).ceil()*4+1}',
          values: column
        )
      ]
    );
    final encryptedSharedPreferences = EncryptedSharedPreferences();
    final sheetID = await encryptedSharedPreferences.getString('sheetID');
    return await api.spreadsheets.values.batchUpdate(req, sheetID); 
  }

  Future<BatchUpdateSpreadsheetResponse> resetSheet(Sheet sheet, GridRange clearRange) async {
    final rowCount = ((clearRange.endRowIndex!-1)/4).ceil();
    final colCount = ((clearRange.endColumnIndex!-1)/2).ceil();
    final mergeList = [(0,0,colCount*2,1)];
    for(int x=0; x<colCount; x++) {
      for(int y=1; y<rowCount*4; y+=4) {
        mergeList.add((x*2, y, x*2+1, y+4));
      }
    }

    final mergeRange = mergeList.map((value) =>
      GridRange(
        endRowIndex: value.$4,
        startRowIndex: value.$2,
        endColumnIndex: value.$3,
        startColumnIndex: value.$1,
        sheetId: sheet.properties!.sheetId!
      )).toList();

    final req = BatchUpdateSpreadsheetRequest(
      requests: 
        clearAllData(sheet, clearRange) +
        unMergeReq(sheet, clearRange) +
        textStyleReq(clearRange)+
        mergeReq(mergeRange) + 
        sizeReq(clearRange)
    );
    final encryptedSharedPreferences = EncryptedSharedPreferences();
    final sheetID = await encryptedSharedPreferences.getString('sheetID');
    return await api.spreadsheets.batchUpdate(req, sheetID); 
  }

  // If there are no error, null will return
  Future<String?> verifySheetAccess({
    required String sheetId
  }) async { 

    /* Check whether the file is a sheet */
    late final Spreadsheet response;
    try{
      response = await api.spreadsheets.get(sheetId);
    } on DetailedApiRequestError catch(e) {
      return '無法找到該表單(${e.status})';
    }

    /* Check access to the file */
    try{
      final driveAPI = DriveApi(client);
      await driveAPI.permissions.list(sheetId);
    } on DetailedApiRequestError catch (_) {
      return '請授予服務帳號編輯表單的權限';
    }
    
    verifySheetTitle = response.sheets!.map((e) => e.properties?.title??'').toList();
    return null;
  }

}
