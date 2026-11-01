import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/resume_data.dart';
import '../services/storage_service.dart';

/// Resume loaded from the device at startup (set in main.dart).
final initialResumeProvider = Provider<ResumeData?>((ref) => null);

final resumeProvider = StateNotifierProvider<ResumeNotifier, ResumeData>((ref) {
  return ResumeNotifier(ref.watch(initialResumeProvider));
});

ResumeData _emptyResume() => ResumeData(
  personalInfo: PersonalInfo(fullName: '', email: '', phone: '', address: ''),
);

class ResumeNotifier extends StateNotifier<ResumeData> {
  ResumeNotifier([ResumeData? initial]) : super(initial ?? _emptyResume());

  Timer? _saveTimer;

  /// Every change is saved to the device shortly after it happens.
  @override
  set state(ResumeData value) {
    super.state = value;
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 400), () {
      StorageService.saveResume(value);
    });
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    StorageService.saveResume(state);
    super.dispose();
  }

  /// Wipes the resume so the user can start a new one.
  Future<void> clear() async {
    _saveTimer?.cancel();
    final photo = state.personalInfo.profilePicture;
    super.state = _emptyResume();
    await StorageService.clearResume();
    // Delete the app's own copy of the photo too.
    if (photo != null && photo.isNotEmpty) {
      try {
        final dir = await getApplicationDocumentsDirectory();
        final file = File(photo);
        if (p.isWithin(dir.path, photo) && await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        debugPrint('Could not delete profile photo: $e');
      }
    }
  }

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

  void updateSummaryDesign(String? fontFamily, double? fontSize) {
    state = state.copyWith(
      personalInfo: state.personalInfo.copyWith(
        summaryFontFamily: fontFamily,
        summaryFontSize: fontSize,
      ),
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
