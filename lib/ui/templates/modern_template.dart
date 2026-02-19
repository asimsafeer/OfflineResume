import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/resume_data.dart';

class ModernTemplate extends StatelessWidget {
  final ResumeData data;

  const ModernTemplate({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
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
            if (data.personalInfo.profilePicture != null &&
                data.personalInfo.profilePicture!.isNotEmpty)
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(data.personalInfo.profilePicture!),
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
          ],
        ),
        const Divider(height: 40),
        // Summary
        if (data.personalInfo.summary.isNotEmpty) ...[
          _buildSectionTitle('PROFILE', themeColor),
          const SizedBox(height: 8),
          Text(
            data.personalInfo.summary,
            style: GoogleFonts.inter(fontSize: 12, height: 1.5),
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

  Widget _buildExperienceItem(Experience exp, Color themeColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                exp.position,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Text(
                '${exp.startDate} - ${exp.endDate}',
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
          Text(
            exp.company,
            style: TextStyle(
              color: themeColor,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          if (exp.description != null && exp.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                exp.description!,
                style: const TextStyle(fontSize: 11, height: 1.4),
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
              Text(
                edu.institution,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Text(
                '${edu.startDate} - ${edu.endDate}',
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
          Text(edu.degree, style: TextStyle(color: themeColor, fontSize: 12)),
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
        style: TextStyle(
          color: themeColor,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
