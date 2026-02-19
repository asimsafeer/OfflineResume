import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/resume_provider.dart';
import '../services/pdf_service.dart';
import 'resume_form.dart';
import 'resume_preview.dart';

class MainLayout extends ConsumerWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text(
          'OfflineCV',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: () async {
                final data = ref.read(resumeProvider);
                try {
                  final file = await PdfService.generateResume(data);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('PDF Generated: ${file.path}')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error generating PDF: $e')),
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            // Tablet/Desktop Split View
            return Row(
              children: [
                const Expanded(flex: 1, child: ResumeForm()),
                VerticalDivider(width: 1, color: Colors.grey[300]),
                const Expanded(flex: 1, child: ResumePreview()),
              ],
            );
          } else {
            // Mobile Stack View (Form with floating/bottom sheet preview)
            return DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'Editor'),
                      Tab(text: 'Preview'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [const ResumeForm(), const ResumePreview()],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
