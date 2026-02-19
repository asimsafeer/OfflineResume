import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/resume_data.dart';

class PdfService {
  static Future<Uint8List> generateResume(ResumeData data) async {
    final pdf = pw.Document();

    final themeColor = PdfColor.fromInt(
      int.parse(data.themeColor.replaceFirst('#', '0xFF')),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          _buildHeader(data, themeColor),
          pw.SizedBox(height: 20),
          _buildContactInfo(data),
          pw.Divider(thickness: 1, color: PdfColors.grey300),
          pw.SizedBox(height: 20),
          if (data.personalInfo.summary.isNotEmpty) ...[
            _buildSectionTitle('PROFILE', themeColor),
            pw.SizedBox(height: 8),
            pw.Text(
              data.personalInfo.summary,
              style: const pw.TextStyle(fontSize: 11, lineSpacing: 1.5),
            ),
            pw.SizedBox(height: 24),
          ],
          if (data.experience.isNotEmpty) ...[
            _buildSectionTitle('EXPERIENCE', themeColor),
            pw.SizedBox(height: 12),
            ...data.experience.map(
              (exp) => _buildExperienceItem(exp, themeColor),
            ),
            pw.SizedBox(height: 24),
          ],
          if (data.education.isNotEmpty) ...[
            _buildSectionTitle('EDUCATION', themeColor),
            pw.SizedBox(height: 12),
            ...data.education.map(
              (edu) => _buildEducationItem(edu, themeColor),
            ),
            pw.SizedBox(height: 24),
          ],
          if (data.skills.isNotEmpty) ...[
            _buildSectionTitle('SKILLS', themeColor),
            pw.SizedBox(height: 8),
            pw.Wrap(
              spacing: 8,
              runSpacing: 8,
              children: data.skills
                  .map((skill) => _buildSkillChip(skill, themeColor))
                  .toList(),
            ),
          ],
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(ResumeData data, PdfColor color) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              data.personalInfo.fullName.toUpperCase(),
              style: pw.TextStyle(
                fontSize: 28,
                fontWeight: pw.FontWeight.bold,
                color: color,
              ),
            ),
            if (data.personalInfo.title != null &&
                data.personalInfo.title!.isNotEmpty)
              pw.Text(
                data.personalInfo.title!,
                style: pw.TextStyle(fontSize: 16, color: PdfColors.grey700),
              ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildContactInfo(ResumeData data) {
    return pw.Wrap(
      spacing: 15,
      children: [
        if (data.personalInfo.email.isNotEmpty)
          pw.Text(
            data.personalInfo.email,
            style: const pw.TextStyle(fontSize: 10),
          ),
        if (data.personalInfo.phone.isNotEmpty)
          pw.Text(
            data.personalInfo.phone,
            style: const pw.TextStyle(fontSize: 10),
          ),
        if (data.personalInfo.address.isNotEmpty)
          pw.Text(
            data.personalInfo.address,
            style: const pw.TextStyle(fontSize: 10),
          ),
      ],
    );
  }

  static pw.Widget _buildSectionTitle(String title, PdfColor color) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 13,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
        pw.Container(
          width: 25,
          height: 2,
          color: color,
          margin: const pw.EdgeInsets.only(top: 2),
        ),
      ],
    );
  }

  static pw.Widget _buildExperienceItem(Experience exp, PdfColor color) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 15),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                exp.position,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              pw.Text(
                '${exp.startDate} - ${exp.endDate}',
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
          pw.Text(exp.company, style: pw.TextStyle(color: color, fontSize: 11)),
          if (exp.description != null && exp.description!.isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 5),
              child: pw.Text(
                exp.description!,
                style: const pw.TextStyle(fontSize: 10, lineSpacing: 1.3),
              ),
            ),
        ],
      ),
    );
  }

  static pw.Widget _buildEducationItem(Education edu, PdfColor color) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                edu.institution,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              pw.Text(
                '${edu.startDate} - ${edu.endDate}',
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
          pw.Text(edu.degree, style: pw.TextStyle(color: color, fontSize: 11)),
        ],
      ),
    );
  }

  static pw.Widget _buildSkillChip(String skill, PdfColor color) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(3)),
      ),
      child: pw.Text(skill, style: pw.TextStyle(fontSize: 9, color: color)),
    );
  }
}
