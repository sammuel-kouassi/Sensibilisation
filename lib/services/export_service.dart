import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../core/database/local_db.dart';
import '../models/seance_statut.dart';

class ExportService {
  static Future<void> toCsv(String tableType) async {
    List<List<dynamic>> rows = [];
    String fileName = "";

    try {
      if (tableType == 'participants') {
        final data = await localDb.getAllParticipants();
        rows.add([
          "ID",
          "Nom",
          "Prénom",
          "Téléphone",
          "Localité",
          "Quartier",
          "Date",
        ]);
        for (var p in data) {
          rows.add([
            p.id,
            p.nom,
            p.prenom,
            p.telephone,
            p.localite,
            p.quartier ?? '',
            DateFormat('dd/MM/yyyy HH:mm').format(p.dateInscription),
          ]);
        }
        fileName = "export_participants_${_getDateStamp()}.csv";
      } else {
        final data = await localDb.getAllSeances();
        rows.add([
          "ID",
          "Nom",
          "Zone",
          "Objectif",
          "Réalisé",
          "Statut",
          "Date",
        ]);
        for (var s in data) {
          final statut = calculerStatut(
            datePrevue: s.datePrevue,
            estTerminee: s.estTerminee,
          );
          rows.add([
            s.serverId ?? 'Local',
            s.nom,
            s.zone,
            s.objectifParticipants,
            s.gadgetsDistribues,
            statut.label,
            DateFormat('dd/MM/yyyy').format(s.datePrevue),
          ]);
        }
        fileName = "export_seances_${_getDateStamp()}.csv";
      }

      String csvData = const ListToCsvConverter().convert(rows);
      await _saveAndShare(csvData, fileName, isBytes: false);
    } catch (e) {
      debugPrint("Erreur CSV: $e");
    }
  }

  static Future<void> toPdf(String tableType) async {
    final pdf = pw.Document();
    final String title = tableType == 'participants'
        ? "Liste des Participants"
        : "Historique des Séances";

    List<List<String>> tableData = [];

    try {
      if (tableType == 'participants') {
        final data = await localDb.getAllParticipants();
        tableData.add(["Nom", "Prénom", "Contact", "Localité", "Date"]);
        for (var p in data) {
          tableData.add([
            p.nom,
            p.prenom,
            p.telephone,
            p.localite,
            DateFormat('dd/MM/yyyy').format(p.dateInscription),
          ]);
        }
      } else {
        final data = await localDb.getAllSeances();
        tableData.add(["Séance", "Zone", "Obj.", "Réal.", "Statut"]);
        for (var s in data) {
          final statut = calculerStatut(
            datePrevue: s.datePrevue,
            estTerminee: s.estTerminee,
          );
          tableData.add([
            s.nom,
            s.zone ?? '',
            s.objectifParticipants.toString(),
            s.gadgetsDistribues.toString(),
            statut.label,
          ]);
        }
      }

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Text(
                title,
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              data: tableData,
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey300),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey100,
              ),
            ),
          ],
        ),
      );

      final bytes = await pdf.save();
      await _saveAndShare(
        bytes,
        "rapport_${tableType}_${_getDateStamp()}.pdf",
        isBytes: true,
      );
    } catch (e) {
      debugPrint("Erreur PDF: $e");
    }
  }

  static String _getDateStamp() =>
      DateFormat('dd_MM_yyyy').format(DateTime.now());

  static Future<void> _saveAndShare(
    dynamic data,
    String fileName, {
    required bool isBytes,
  }) async {
    final directory = await getTemporaryDirectory();
    final file = File("${directory.path}/$fileName");

    if (isBytes) {
      await file.writeAsBytes(data);
    } else {
      await file.writeAsString(data);
    }

    await Share.shareXFiles([XFile(file.path)], text: 'Rapport CIE');
  }
}
