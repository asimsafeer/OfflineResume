import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/resume_data.dart';

final resumeProvider = StateNotifierProvider<ResumeNotifier, ResumeData>((ref) {
  return ResumeNotifier();
});

class ResumeNotifier extends StateNotifier<ResumeData> {
  ResumeNotifier()
    : super(
        ResumeData(
          personalInfo: PersonalInfo(
            fullName: '',
            email: '',
            phone: '',
            address: '',
          ),
        ),
      );

  void updatePersonalInfo(PersonalInfo info) {
    state = state.copyWith(personalInfo: info);
  }

  void updateDesign(
    TemplateId templateId,
    String themeColor,
    String fontFamily,
    FontSize fontSize,
  ) {
    state = state.copyWith(
      templateId: templateId,
      themeColor: themeColor,
      fontFamily: fontFamily,
      fontSize: fontSize,
    );
  }

  void addExperience(Experience exp) {
    state = state.copyWith(experience: [...state.experience, exp]);
  }

  void removeExperience(int index) {
    final list = [...state.experience];
    list.removeAt(index);
    state = state.copyWith(experience: list);
  }

  void updateExperienceList(List<Experience> list) {
    state = state.copyWith(experience: list);
  }

  void addEducation(Education edu) {
    state = state.copyWith(education: [...state.education, edu]);
  }

  void removeEducation(int index) {
    final list = [...state.education];
    list.removeAt(index);
    state = state.copyWith(education: list);
  }

  void updateEducationList(List<Education> list) {
    state = state.copyWith(education: list);
  }

  void updateSkills(List<String> skills) {
    state = state.copyWith(skills: skills);
  }

  void updateExperienceDesign(String? fontFamily, double? fontSize) {
    state = state.copyWith(
      experienceFontFamily: fontFamily,
      experienceFontSize: fontSize,
    );
  }

  void updateEducationDesign(String? fontFamily, double? fontSize) {
    state = state.copyWith(
      educationFontFamily: fontFamily,
      educationFontSize: fontSize,
    );
  }

  void updateCertificatesList(List<Certificate> list) {
    state = state.copyWith(certificates: list);
  }

  void addCertificate(Certificate cert) {
    state = state.copyWith(certificates: [...state.certificates, cert]);
  }

  void removeCertificate(int index) {
    final list = [...state.certificates];
    list.removeAt(index);
    state = state.copyWith(certificates: list);
  }

  void addLanguage(Language lang) {
    state = state.copyWith(languages: [...state.languages, lang]);
  }

  void removeLanguage(int index) {
    final list = [...state.languages];
    list.removeAt(index);
    state = state.copyWith(languages: list);
  }

  void updateLanguageList(List<Language> list) {
    state = state.copyWith(languages: list);
  }
}
