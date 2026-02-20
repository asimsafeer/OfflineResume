import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../providers/resume_provider.dart';
import '../services/pdf_service.dart';
import 'resume_form.dart';
import 'resume_preview.dart';

class MainLayout extends ConsumerWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text(
          'Offline CV',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: () async {
                final data = ref.read(resumeProvider);
                try {
                  final pdfBytes = await PdfService.generateResume(data);

                  final fileName =
                      '${data.personalInfo.fullName.replaceAll(' ', '_')}_Resume.pdf';

                  if (kIsWeb ||
                      Platform.isWindows ||
                      Platform.isMacOS ||
                      Platform.isLinux) {
                    final String? outputFile = await FilePicker.platform
                        .saveFile(
                          dialogTitle:
                              'Please select where to save your resume',
                          fileName: fileName,
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );

                    if (outputFile != null) {
                      final file = File(outputFile);
                      await file.writeAsBytes(pdfBytes);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('PDF Saved to: $outputFile')),
                        );
                      }
                    }
                  } else {
                    // Mobile platforms (iOS / Android)
                    // Write to temp directory, then share so the user can natively select "Save to Files"
                    final tempDir = await getTemporaryDirectory();
                    final file = await File(
                      '${tempDir.path}/$fileName',
                    ).create();
                    await file.writeAsBytes(pdfBytes);

                    if (context.mounted) {
                      final box = context.findRenderObject() as RenderBox?;
                      await Share.shareXFiles(
                        [XFile(file.path, mimeType: 'application/pdf')],
                        sharePositionOrigin:
                            box!.localToGlobal(Offset.zero) & box.size,
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error saving PDF: $e')),
                    );
                  }
                }
              },
              icon: const Icon(Icons.download),
              label: const Text('Download PDF'),
            ),
          ),
        ],
      ),
      body: isDesktop
          ? Row(
              children: [
                const Expanded(flex: 1, child: ResumeForm()),
                VerticalDivider(width: 1, color: Colors.grey[300]),
                const Expanded(flex: 1, child: ResumePreview()),
              ],
            )
          : const ResumeForm(),
      floatingActionButton: isDesktop || !ref.watch(resumeProvider).hasData
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => Container(
                    height: MediaQuery.of(context).size.height * 0.9,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            child: const ResumePreview(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.visibility),
              label: const Text('Live Preview'),
            ),
    );
  }
}
