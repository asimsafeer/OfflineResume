import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/resume_data.dart';

class ClassicTemplate extends StatelessWidget {
  final ResumeData data;

  const ClassicTemplate({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Center(
          child: Column(
            children: [
              Text(
                data.personalInfo.fullName.toUpperCase(),
                style: GoogleFonts.merriweather(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _getContactString(),
                textAlign: TextAlign.center,
                style: GoogleFonts.merriweather(fontSize: 10),
              ),
              if (data.personalInfo.linkedin != null ||
                  data.personalInfo.github != null ||
                  data.personalInfo.website != null) ...[
                const SizedBox(height: 4),
                Text(
                  _getSocialString(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.merriweather(fontSize: 10),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Divider(color: Colors.black, thickness: 1),

        // Summary
        if (data.personalInfo.summary.isNotEmpty) ...[
          _buildSectionTitle('PROFESSIONAL SUMMARY'),
          Text(
            data.personalInfo.summary,
            style: GoogleFonts.merriweather(fontSize: 12, height: 1.5),
          ),
          const SizedBox(height: 16),
        ],

        // Experience
        if (data.experience.isNotEmpty) ...[
          _buildSectionTitle('WORK EXPERIENCE'),
          ...data.experience.map((exp) => _buildExperienceItem(exp)),
          const SizedBox(height: 16),
        ],

        // Education
        if (data.education.isNotEmpty) ...[
          _buildSectionTitle('EDUCATION'),
          ...data.education.map((edu) => _buildEducationItem(edu)),
          const SizedBox(height: 16),
        ],

        // Skills
        if (data.skills.isNotEmpty) ...[
          _buildSectionTitle('SKILLS'),
          Text(
            data.skills.join(' • '),
            style: GoogleFonts.merriweather(fontSize: 12, height: 1.5),
          ),
          const SizedBox(height: 16),
        ],

        // Languages
        if (data.languages.isNotEmpty) ...[
          _buildSectionTitle('LANGUAGES'),
          Text(
            data.languages
                .map((l) => '${l.name} (${l.proficiency})')
                .join(' • '),
            style: GoogleFonts.merriweather(fontSize: 12, height: 1.5),
          ),
          const SizedBox(height: 16),
        ],

        // Certificates
        if (data.certificates.isNotEmpty) ...[
          _buildSectionTitle('CERTIFICATIONS'),
          ...data.certificates.map((cert) => _buildCertificateItem(cert)),
        ],
      ],
    );
  }

  String _getContactString() {
    final list = <String>[];
    if (data.personalInfo.email.isNotEmpty) list.add(data.personalInfo.email);
    if (data.personalInfo.phone.isNotEmpty) list.add(data.personalInfo.phone);
    if (data.personalInfo.address.isNotEmpty) {
      list.add(data.personalInfo.address);
    }
    return list.join(' | ');
  }

  String _getSocialString() {
    final list = <String>[];
    if (data.personalInfo.linkedin != null &&
        data.personalInfo.linkedin!.isNotEmpty) {
      list.add('LinkedIn: ${data.personalInfo.linkedin}');
    }
    if (data.personalInfo.github != null &&
        data.personalInfo.github!.isNotEmpty) {
      list.add('GitHub: ${data.personalInfo.github}');
    }
    if (data.personalInfo.website != null &&
        data.personalInfo.website!.isNotEmpty) {
      list.add(data.personalInfo.website!);
    }
    return list.join(' | ');
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.merriweather(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(color: Colors.black, thickness: 0.5),
        ],
      ),
    );
  }

  Widget _buildExperienceItem(Experience exp) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                exp.company,
                style: GoogleFonts.merriweather(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Text(
                '${exp.startDate} - ${exp.endDate}',
                style: GoogleFonts.merriweather(fontSize: 12),
              ),
            ],
          ),
          Text(
            exp.position,
            style: GoogleFonts.merriweather(
              fontStyle: FontStyle.italic,
              fontSize: 12,
            ),
          ),
          if (exp.description != null && exp.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                exp.description!,
                style: GoogleFonts.merriweather(fontSize: 12, height: 1.4),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEducationItem(Education edu) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                edu.institution,
                style: GoogleFonts.merriweather(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Text(
                '${edu.startDate} - ${edu.endDate}',
                style: GoogleFonts.merriweather(fontSize: 12),
              ),
            ],
          ),
          Text(edu.degree, style: GoogleFonts.merriweather(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCertificateItem(Certificate cert) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: GoogleFonts.merriweather(fontSize: 12)),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.merriweather(
                  fontSize: 12,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: '${cert.name}, ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '${cert.issuer} (${cert.date})'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
