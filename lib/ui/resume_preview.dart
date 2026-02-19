import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/resume_provider.dart';
import '../models/resume_data.dart';
import 'templates/modern_template.dart';
import 'templates/classic_template.dart';

class ResumePreview extends ConsumerWidget {
  const ResumePreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(resumeProvider);

    return Container(
      color: const Color(0xFFE5E7EB), // Light grey background
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.all(40),
            child: _buildTemplate(data),
          ),
        ),
      ),
    );
  }

  Widget _buildTemplate(ResumeData data) {
    switch (data.templateId) {
      case TemplateId.modern:
        return ModernTemplate(data: data);
      case TemplateId.classic: // Using Classic as default ATS template
        return ClassicTemplate(data: data);
      default:
        return ClassicTemplate(data: data);
    }
  }
}
