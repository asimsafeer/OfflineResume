import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_resume_flutter/models/resume_data.dart';
import 'package:offline_resume_flutter/services/pdf_service.dart';

ResumeData _fullResume({TemplateId template = TemplateId.classic}) => ResumeData(
  templateId: template,
  themeColor: '#ef4444',
  fontFamily: 'Lato',
  fontSize: FontSize.large,
  personalInfo: PersonalInfo(
    fullName: 'Thandi Nkosi',
    title: 'Accountant',
    email: 'thandi@example.com',
    phone: '+27 82 000 0000',
    address: 'Johannesburg',
    summary: 'Detail-oriented accountant • 5 years',
    summaryFontFamily: 'Open Sans',
    summaryFontSize: 13,
    linkedin: 'thandi',
    github: 'thandi-n',
    instagram: 'thandi.ig',
    facebook: 'thandi.fb',
    website: 'thandi.dev',
  ),
  experience: [
    Experience(
      company: 'Acme',
      position: 'Junior Accountant',
      startDate: '2020',
      endDate: 'Present',
      isCurrent: true,
      description: 'Did the books',
    ),
  ],
  education: [
    Education(
      institution: 'Wits',
      degree: 'BCom',
      startDate: '2016',
      endDate: '2019',
    ),
  ],
  skills: ['Excel', 'Sage'],
  languages: [Language(name: 'Zulu', proficiency: 'Native')],
  certificates: [Certificate(name: 'SAIPA', issuer: 'SAIPA', date: '2021')],
  experienceFontSize: 13,
  educationFontSize: 11,
  experienceFontFamily: 'Roboto',
  educationFontFamily: 'Merriweather',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('ResumeData survives a JSON round trip', () {
    final original = _fullResume();
    final restored = ResumeData.fromJson(
      jsonDecode(jsonEncode(original.toJson())) as Map<String, dynamic>,
    );
    expect(restored.toJson(), original.toJson());
  });

  test('partial or bad JSON falls back to defaults', () {
    final r = ResumeData.fromJson({
      'templateId': 'creative', // hidden template
      'fontSize': 'huge',
      'skills': 'not a list',
      'experience': [
        {'company': 'X'},
        'garbage',
      ],
    });
    expect(r.templateId, TemplateId.modern);
    expect(r.fontSize, FontSize.medium);
    expect(r.skills, isEmpty);
    expect(r.experience.single.company, 'X');
    expect(r.experience.single.position, '');
    expect(r.personalInfo.fullName, '');
  });

  for (final template in availableTemplates) {
    test('PDF builds for ${template.name} template', () async {
      final bytes = await PdfService.generateResume(
        _fullResume(template: template),
      );
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    });
  }
}
