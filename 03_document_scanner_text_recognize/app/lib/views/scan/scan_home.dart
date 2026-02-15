import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:file_saver/file_saver.dart';


class UniversalDocScanner extends StatefulWidget {
  const UniversalDocScanner({super.key});

  @override
  State<UniversalDocScanner> createState() => _UniversalDocScannerState();
}

class _UniversalDocScannerState extends State<UniversalDocScanner> {
  String _statusMessage = "Ready to scan documents";
  String? _savedPdfPath;
  int? _pageCount;
  bool _isScanning = false;

  Future<void> _scanAndSavePdf() async {
    if (_isScanning) return;

    setState(() {
      _isScanning = true;
      _statusMessage = "Launching document scanner...";
      _savedPdfPath = null;
      _pageCount = null;
    });

    print("SCAN & SAVE PDF START");

    try {
      print("Step 1: Calling getScannedDocumentAsPdf(page: 4)");
      final result = await FlutterDocScanner().getScannedDocumentAsPdf(page: 4);

      print("Step 2: Raw result → $result");
      print("Result type: ${result.runtimeType}");

      if (result == null || result is! Map || !result.containsKey('pdfUri')) {
        print("→ No valid pdfUri found");
        setState(() => _statusMessage = "No PDF was returned from scanner");
        return;
      }

      final String? pdfUriStr = result['pdfUri'] as String?;
      final int pageCount = (result['pageCount'] ?? result['count'] ?? 0) as int;

      print("Step 3: pdfUri → $pdfUriStr | pageCount → $pageCount");

      if (pdfUriStr == null || pdfUriStr.isEmpty) {
        setState(() => _statusMessage = "PDF URI is empty");
        return;
      }

      // Clean file:// prefix if present
      String cleanedPath = pdfUriStr.replaceFirst('file://', '');
      final File tempFile = File(cleanedPath);

      print("Step 4: Temp file path → ${tempFile.path}");
      if (!await tempFile.exists()) {
        print("→ Temp PDF file does not exist anymore");
        setState(() => _statusMessage = "Scanned PDF disappeared too quickly");
        return;
      }

      final Uint8List pdfBytes = await tempFile.readAsBytes();
      print("Step 5: PDF bytes read → ${pdfBytes.length} bytes");

      // Prepare filename
      final String fileName = "scanned_document_${DateTime.now().millisecondsSinceEpoch}.pdf";

      print("Step 6: Opening save dialog via file_saver...");
      final String? savedPath = await FileSaver.instance.saveAs(
        name: fileName,
        bytes: pdfBytes,
        ext: 'pdf',
        mimeType: MimeType.pdf,
      );

      print("Step 7: saveAs result path → $savedPath");

      if (savedPath == null || savedPath.isEmpty) {
        setState(() => _statusMessage = "Save cancelled by user");
        return;
      }

      if (!mounted) return;

      setState(() {
        _savedPdfPath = savedPath;
        _pageCount = pageCount;
        _statusMessage = "Success! Scanned $pageCount page(s)\nPDF saved to:\n$savedPath";
      });
    } on PlatformException catch (e) {
      print("PlatformException: ${e.code} → ${e.message}");
      setState(() => _statusMessage = "Scanner error: ${e.message ?? 'Unknown'}");
    } catch (e, stack) {
      print("Error: $e\n$stack");
      setState(() => _statusMessage = "Failed to save PDF: $e");
    } finally {
      print("SCAN & SAVE END");
      if (mounted) {
        setState(() => _isScanning = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Scanner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_savedPdfPath != null) ...[
                        const Icon(
                          Icons.picture_as_pdf,
                          size: 100,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Scanned $_pageCount page(s)',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SelectableText(
                          'Saved to:\n$_savedPdfPath',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Check your Downloads folder or Files app",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ] else
                        Text(
                          _statusMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: _statusMessage.contains('Success')
                                ? Colors.green
                                : Colors.grey[700],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            //load resources to scan
            ElevatedButton.icon(
              onPressed: _isScanning ? null : _scanAndSavePdf,
              icon: _isScanning
                  ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 3),
              )
                  : const Icon(Icons.document_scanner, size: 28),
              label: Text(
                _isScanning ? 'Scanning...' : 'Scan & Save PDF (up to 4 pages)',
                style: const TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}