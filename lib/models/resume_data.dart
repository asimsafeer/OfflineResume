import 'dart:io';

enum TemplateId { classic, modern, minimal, creative, professional }

enum FontSize { small, medium, large }

/// Templates that are finished and shown in the picker.
const availableTemplates = [TemplateId.classic, TemplateId.modern];

T _enumByName<T extends Enum>(List<T> values, Object? name, T fallback) {
  for (final v in values) {
    if (v.name == name) return v;
  }
  return fallback;
}

String _str(Object? v, [String fallback = '']) => v is String ? v : fallback;
String? _strOrNull(Object? v) => v is String ? v : null;
double _dbl(Object? v, double fallback) => v is num ? v.toDouble() : fallback;
bool _bool(Object? v) => v is bool ? v : false;
List<T> _list<T>(Object? v, T Function(Map<String, dynamic>) f) => v is List
    ? v.whereType<Map>().map((e) => f(Map<String, dynamic>.from(e))).toList()
    : <T>[];

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

  Map<String, dynamic> toJson() => {
    'templateId': templateId.name,
    'themeColor': themeColor,
    'fontFamily': fontFamily,
    'fontSize': fontSize.name,
    'personalInfo': personalInfo.toJson(),
    'education': education.map((e) => e.toJson()).toList(),
    'experience': experience.map((e) => e.toJson()).toList(),
    'skills': skills,
    'languages': languages.map((e) => e.toJson()).toList(),
    'certificates': certificates.map((e) => e.toJson()).toList(),
    'experienceFontSize': experienceFontSize,
    'educationFontSize': educationFontSize,
    'experienceFontFamily': experienceFontFamily,
    'educationFontFamily': educationFontFamily,
  };

  factory ResumeData.fromJson(Map<String, dynamic> json) {
    final template = _enumByName(
      TemplateId.values,
      json['templateId'],
      TemplateId.modern,
    );
    final info = json['personalInfo'];
    return ResumeData(
      templateId: availableTemplates.contains(template)
          ? template
          : TemplateId.modern,
      themeColor: _str(json['themeColor'], '#3b82f6'),
      fontFamily: _str(json['fontFamily'], 'Inter'),
      fontSize: _enumByName(FontSize.values, json['fontSize'], FontSize.medium),
      personalInfo: info is Map
          ? PersonalInfo.fromJson(Map<String, dynamic>.from(info))
          : PersonalInfo(fullName: '', email: '', phone: '', address: ''),
      education: _list(json['education'], Education.fromJson),
      experience: _list(json['experience'], Experience.fromJson),
      skills: json['skills'] is List
          ? (json['skills'] as List).whereType<String>().toList()
          : const [],
      languages: _list(json['languages'], Language.fromJson),
      certificates: _list(json['certificates'], Certificate.fromJson),
      experienceFontSize: _dbl(json['experienceFontSize'], 12.0),
      educationFontSize: _dbl(json['educationFontSize'], 12.0),
      experienceFontFamily: _strOrNull(json['experienceFontFamily']),
      educationFontFamily: _strOrNull(json['educationFontFamily']),
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

  factory PersonalInfo.fromJson(Map<String, dynamic> json) => PersonalInfo(
    fullName: _str(json['fullName']),
    title: _strOrNull(json['title']),
    profilePicture: _strOrNull(json['profilePicture']),
    email: _str(json['email']),
    phone: _str(json['phone']),
    address: _str(json['address']),
    summary: _str(json['summary']),
    summaryFontFamily: _str(json['summaryFontFamily'], 'Inter'),
    summaryFontSize: _dbl(json['summaryFontSize'], 14.0),
    linkedin: _strOrNull(json['linkedin']),
    github: _strOrNull(json['github']),
    instagram: _strOrNull(json['instagram']),
    facebook: _strOrNull(json['facebook']),
    website: _strOrNull(json['website']),
  );

  /// True when there is a photo that can actually be shown.
  bool get hasPhoto {
    final path = profilePicture;
    if (path == null || path.isEmpty) return false;
    if (path.startsWith('http')) return true;
    try {
      return File(path).existsSync();
    } catch (_) {
      return false;
    }
  }

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'title': title,
    'profilePicture': profilePicture,
    'email': email,
    'phone': phone,
    'address': address,
    'summary': summary,
    'summaryFontFamily': summaryFontFamily,
    'summaryFontSize': summaryFontSize,
    'linkedin': linkedin,
    'github': github,
    'instagram': instagram,
    'facebook': facebook,
    'website': website,
  };

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

  factory Education.fromJson(Map<String, dynamic> json) => Education(
    institution: _str(json['institution']),
    degree: _str(json['degree']),
    startDate: _str(json['startDate']),
    endDate: _str(json['endDate']),
    isCurrent: _bool(json['isCurrent']),
    description: _strOrNull(json['description']),
  );

  Map<String, dynamic> toJson() => {
    'institution': institution,
    'degree': degree,
    'startDate': startDate,
    'endDate': endDate,
    'isCurrent': isCurrent,
    'description': description,
  };
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

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
    company: _str(json['company']),
    position: _str(json['position']),
    startDate: _str(json['startDate']),
    endDate: _str(json['endDate']),
    isCurrent: _bool(json['isCurrent']),
    description: _strOrNull(json['description']),
  );

  Map<String, dynamic> toJson() => {
    'company': company,
    'position': position,
    'startDate': startDate,
    'endDate': endDate,
    'isCurrent': isCurrent,
    'description': description,
  };
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

  factory Certificate.fromJson(Map<String, dynamic> json) => Certificate(
    name: _str(json['name']),
    issuer: _str(json['issuer']),
    date: _str(json['date']),
    description: _strOrNull(json['description']),
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'issuer': issuer,
    'date': date,
    'description': description,
  };
}

class Language {
  final String name;
  final String proficiency;

  Language({required this.name, required this.proficiency});

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    name: _str(json['name']),
    proficiency: _str(json['proficiency']),
  );

  Map<String, dynamic> toJson() => {'name': name, 'proficiency': proficiency};
}
