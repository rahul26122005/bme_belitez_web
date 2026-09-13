import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import '../models/registration.dart';

class ExportService {
  static void download(List<Registration> rows) {
    if (!kIsWeb) {
      debugPrint('Excel export in this build is enabled for Flutter Web.');
      return;
    }

    final excel = Excel.createExcel();
    final sheet = excel['Registrations'];
    final headers = [
      'Registration ID','Name','College','Department','Contact','Email','Year',
      'Technical Event','Non-Technical Event','Workshop','Food','Transaction ID',
      'Payment Status','Registration Status','Registered At'
    ];

    for (var i = 0; i < headers.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
        .value = TextCellValue(headers[i]);
    }

    for (var r = 0; r < rows.length; r++) {
      final x = rows[r];
      final values = [
        x.registrationId, x.name, x.college, x.department, x.contact, x.email,
        x.year, x.technicalEvent, x.nonTechnicalEvent, x.workshop, x.food,
        x.transactionId, x.paymentStatus, x.status,
        x.registeredAt?.toIso8601String() ?? ''
      ];
      for (var c = 0; c < values.length; c++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: r + 1))
          .value = TextCellValue(values[c].toString());
      }
    }

    final bytes = excel.encode();
    if (bytes == null) return;
    final blob = html.Blob(
      [Uint8List.fromList(bytes)],
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    );
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', 'belitez_2k26_registrations.xlsx')
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
