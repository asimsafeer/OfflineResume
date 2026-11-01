import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/resume_data.dart';

class ModernTemplate extends StatelessWidget {
  final ResumeData data;

  const ModernTemplate({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Robust color parsing
    final themeColor = Color(
      int.parse(data.themeColor.replaceFirst('#', '0xFF')),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.personalInfo.fullName.isEmpty
                        ? 'YOUR NAME'
                        : data.personalInfo.fullName,
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: themeColor,
                    ),
                  ),
                  if (data.personalInfo.title != null &&
                      data.personalInfo.title!.isNotEmpty)
                    Text(
                      data.personalInfo.title!,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            // Photo placeholder (Simplified)
            if (data.personalInfo.hasPhoto)
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: data.personalInfo.profilePicture!.startsWith('http')
                        ? NetworkImage(data.personalInfo.profilePicture!)
                        : FileImage(File(data.personalInfo.profilePicture!))
                              as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        // Contact Info
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildContactIcon(Icons.email, data.personalInfo.email),
            _buildContactIcon(Icons.phone, data.personalInfo.phone),
            _buildContactIcon(Icons.location_on, data.personalInfo.address),
            if (data.personalInfo.website != null &&
                data.personalInfo.website!.isNotEmpty)
              _buildContactIcon(Icons.language, data.personalInfo.website!),
            if (data.personalInfo.linkedin != null &&
                data.personalInfo.linkedin!.isNotEmpty)
              _buildContactIcon(
                Icons.link,
                'in/${data.personalInfo.linkedin!}',
              ),
            if (data.personalInfo.github != null &&
                data.personalInfo.github!.isNotEmpty)
              _buildContactIcon(
                Icons.code,
                'github.com/${data.personalInfo.github!}',
              ),
            if (data.personalInfo.instagram != null &&
                data.personalInfo.instagram!.isNotEmpty)
              _buildContactIcon(
                Icons.camera_alt,
                '@${data.personalInfo.instagram!}',
              ),
            if (data.personalInfo.facebook != null &&
                data.personalInfo.facebook!.isNotEmpty)
              _buildContactIcon(
                Icons.people,
                'fb.com/${data.personalInfo.facebook!}',
              ),
          ],
        ),
        const Divider(height: 40),
        // Summary
        if (data.personalInfo.summary.isNotEmpty) ...[
          _buildSectionTitle('PROFILE', themeColor),
          const SizedBox(height: 8),
          Text(
            data.personalInfo.summary,
            style: GoogleFonts.getFont(
              data.personalInfo.summaryFontFamily,
              fontSize: data.personalInfo.summaryFontSize,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
        ],
        // Experience
        if (data.experience.isNotEmpty) ...[
          _buildSectionTitle('EXPERIENCE', themeColor),
          const SizedBox(height: 12),
          ...data.experience.map(
            (exp) => _buildExperienceItem(exp, themeColor),
          ),
          const SizedBox(height: 24),
        ],
        // Education
        if (data.education.isNotEmpty) ...[
          _buildSectionTitle('EDUCATION', themeColor),
          const SizedBox(height: 12),
          ...data.education.map((edu) => _buildEducationItem(edu, themeColor)),
          const SizedBox(height: 24),
        ],
        // Skills
        if (data.skills.isNotEmpty) ...[
          _buildSectionTitle('SKILLS', themeColor),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: data.skills
                .map((skill) => _buildSkillChip(skill, themeColor))
                .toList(),
          ),
          const SizedBox(height: 24),
        ],
        // Languages
        if (data.languages.isNotEmpty) ...[
          _buildSectionTitle('LANGUAGES', themeColor),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: data.languages
                .map(
                  (l) => _buildSkillChip(
                    l.proficiency.isEmpty
                        ? l.name
                        : '${l.name} · ${l.proficiency}',
                    themeColor,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
        ],
        // Certificates
        if (data.certificates.isNotEmpty) ...[
          _buildSectionTitle('CERTIFICATIONS', themeColor),
          const SizedBox(height: 12),
          ...data.certificates.map(
            (cert) => _buildCertificateItem(cert, themeColor),
          ),
        ],
      ],
    );
  }

  Widget _buildContactIcon(IconData icon, String text) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[800]),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
            letterSpacing: 1.2,
          ),
        ),
        Container(
          width: 30,
          height: 2,
          color: color,
          margin: const EdgeInsets.only(top: 4),
        ),
      ],
    );
  }

  TextStyle _expStyle({
    double delta = 0,
    FontWeight? weight,
    Color? color,
    double? height,
  }) => GoogleFonts.getFont(
    data.experienceFontFamily ?? 'Inter',
    fontSize: data.experienceFontSize + delta,
    fontWeight: weight,
    color: color,
    height: height,
  );

  TextStyle _eduStyle({double delta = 0, FontWeight? weight, Color? color}) =>
      GoogleFonts.getFont(
        data.educationFontFamily ?? 'Inter',
        fontSize: data.educationFontSize + delta,
        fontWeight: weight,
        color: color,
      );

  Widget _buildExperienceItem(Experience exp, Color themeColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  exp.position,
                  style: _expStyle(delta: 1, weight: FontWeight.bold),
                ),
              ),
              Text(
                '${exp.startDate} - ${exp.endDate}',
                style: _expStyle(delta: -1, color: Colors.grey[600]),
              ),
            ],
          ),
          Text(
            exp.company,
            style: _expStyle(weight: FontWeight.w500, color: themeColor),
          ),
          if (exp.description != null && exp.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                exp.description!,
                style: _expStyle(delta: -1, height: 1.4),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEducationItem(Education edu, Color themeColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  edu.institution,
                  style: _eduStyle(delta: 1, weight: FontWeight.bold),
                ),
              ),
              Text(
                '${edu.startDate} - ${edu.endDate}',
                style: _eduStyle(delta: -1, color: Colors.grey[600]),
              ),
            ],
          ),
          Text(edu.degree, style: _eduStyle(color: themeColor)),
          if (edu.description != null && edu.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(edu.description!, style: _eduStyle(delta: -1)),
            ),
        ],
      ),
    );
  }

  Widget _buildCertificateItem(Certificate cert, Color themeColor) {
    final meta = [
      cert.issuer,
      cert.date,
    ].where((s) => s.isNotEmpty).join(' · ');
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cert.name,
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          if (meta.isNotEmpty)
            Text(
              meta,
              style: GoogleFonts.inter(fontSize: 11, color: themeColor),
            ),
          if (cert.description != null && cert.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                cert.description!,
                style: GoogleFonts.inter(fontSize: 11, height: 1.4),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skill, Color themeColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: themeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        skill,
        style: GoogleFonts.inter(
          color: themeColor,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
