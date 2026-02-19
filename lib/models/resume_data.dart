enum TemplateId { classic, modern, minimal, creative, professional }

enum FontSize { small, medium, large }

class ResumeData {
  final TemplateId templateId;
  final String themeColor;
  final String fontFamily;
  final FontSize fontSize;
  final PersonalInfo personalInfo;
  final List<Education> education;
  final List<Experience> experience;
  final List<String> skills;
  final List<Language> languages;
  final List<Certificate> certificates;
  final double experienceFontSize;
  final double educationFontSize;
  final String? experienceFontFamily;
  final String? educationFontFamily;

  ResumeData({
    this.templateId = TemplateId.modern,
    this.themeColor = '#3b82f6',
    this.fontFamily = 'Inter',
    this.fontSize = FontSize.medium,
    required this.personalInfo,
    this.education = const [],
    this.experience = const [],
    this.skills = const [],
    this.languages = const [],
    this.certificates = const [],
    this.experienceFontSize = 12.0,
    this.educationFontSize = 12.0,
    this.experienceFontFamily,
    this.educationFontFamily,
  });

  ResumeData copyWith({
    TemplateId? templateId,
    String? themeColor,
    String? fontFamily,
    FontSize? fontSize,
    PersonalInfo? personalInfo,
    List<Education>? education,
    List<Experience>? experience,
    List<String>? skills,
    List<Language>? languages,
    List<Certificate>? certificates,
    double? experienceFontSize,
    double? educationFontSize,
    String? experienceFontFamily,
    String? educationFontFamily,
  }) {
    return ResumeData(
      templateId: templateId ?? this.templateId,
      themeColor: themeColor ?? this.themeColor,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      personalInfo: personalInfo ?? this.personalInfo,
      education: education ?? this.education,
      experience: experience ?? this.experience,
      skills: skills ?? this.skills,
      languages: languages ?? this.languages,
      certificates: certificates ?? this.certificates,
      experienceFontSize: experienceFontSize ?? this.experienceFontSize,
      educationFontSize: educationFontSize ?? this.educationFontSize,
      experienceFontFamily: experienceFontFamily ?? this.experienceFontFamily,
      educationFontFamily: educationFontFamily ?? this.educationFontFamily,
    );
  }

  bool get hasData {
    return personalInfo.fullName.isNotEmpty ||
        education.isNotEmpty ||
        experience.isNotEmpty ||
        skills.isNotEmpty ||
        languages.isNotEmpty ||
        certificates.isNotEmpty;
  }
}

class PersonalInfo {
  final String fullName;
  final String? title;
  final String? profilePicture;
  final String email;
  final String phone;
  final String address;
  final String summary;
  final String summaryFontFamily;
  final double summaryFontSize;
  final String? linkedin;
  final String? github;
  final String? instagram;
  final String? facebook;
  final String? website;

  PersonalInfo({
    required this.fullName,
    this.title,
    this.profilePicture,
    required this.email,
    required this.phone,
    required this.address,
    this.summary = '',
    this.summaryFontFamily = 'Inter',
    this.summaryFontSize = 14.0,
    this.linkedin,
    this.github,
    this.instagram,
    this.facebook,
    this.website,
  });

  PersonalInfo copyWith({
    String? fullName,
    String? title,
    String? profilePicture,
    String? email,
    String? phone,
    String? address,
    String? summary,
    String? summaryFontFamily,
    double? summaryFontSize,
    String? linkedin,
    String? github,
    String? instagram,
    String? facebook,
    String? website,
  }) {
    return PersonalInfo(
      fullName: fullName ?? this.fullName,
      title: title ?? this.title,
      profilePicture: profilePicture ?? this.profilePicture,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      summary: summary ?? this.summary,
      summaryFontFamily: summaryFontFamily ?? this.summaryFontFamily,
      summaryFontSize: summaryFontSize ?? this.summaryFontSize,
      linkedin: linkedin ?? this.linkedin,
      github: github ?? this.github,
      instagram: instagram ?? this.instagram,
      facebook: facebook ?? this.facebook,
      website: website ?? this.website,
    );
  }
}

class Education {
  final String institution;
  final String degree;
  final String startDate;
  final String endDate;
  final bool isCurrent;
  final String? description;

  Education({
    required this.institution,
    required this.degree,
    required this.startDate,
    required this.endDate,
    this.isCurrent = false,
    this.description,
  });
}

class Experience {
  final String company;
  final String position;
  final String startDate;
  final String endDate;
  final bool isCurrent;
  final String? description;

  Experience({
    required this.company,
    required this.position,
    required this.startDate,
    required this.endDate,
    this.isCurrent = false,
    this.description,
  });
}

class Certificate {
  final String name;
  final String issuer;
  final String date;
  final String? description;

  Certificate({
    required this.name,
    required this.issuer,
    required this.date,
    this.description,
  });
}

class Language {
  final String name;
  final String proficiency;

  Language({required this.name, required this.proficiency});
}
