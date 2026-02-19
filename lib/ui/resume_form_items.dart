import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/resume_data.dart';
import '../providers/resume_provider.dart';

class ResumeTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final int maxLines;
  final bool enabled;
  final Function(String)? onChanged;
  final IconData? icon;

  const ResumeTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.maxLines = 1,
    this.enabled = true,
    this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label.replaceAll('*', ''),
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
            if (label.contains('*'))
              const Text(
                '*',
                style: TextStyle(color: Colors.red, fontSize: 13),
              ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          enabled: enabled,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null
                ? Icon(icon, size: 18, color: Colors.grey)
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class ExperienceCard extends ConsumerStatefulWidget {
  final Experience experience;
  final int index;

  const ExperienceCard({
    super.key,
    required this.experience,
    required this.index,
  });

  @override
  ConsumerState<ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends ConsumerState<ExperienceCard> {
  late TextEditingController _companyController;
  late TextEditingController _positionController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _companyController = TextEditingController(text: widget.experience.company);
    _positionController = TextEditingController(
      text: widget.experience.position,
    );
    _startDateController = TextEditingController(
      text: widget.experience.startDate,
    );
    _endDateController = TextEditingController(text: widget.experience.endDate);
    _descriptionController = TextEditingController(
      text: widget.experience.description,
    );
  }

  @override
  void didUpdateWidget(ExperienceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.experience.company != _companyController.text) {
      _companyController.text = widget.experience.company;
    }
    if (widget.experience.position != _positionController.text) {
      _positionController.text = widget.experience.position;
    }
    if (widget.experience.startDate != _startDateController.text) {
      _startDateController.text = widget.experience.startDate;
    }
    if (widget.experience.endDate != _endDateController.text) {
      _endDateController.text = widget.experience.endDate;
    }
    if (widget.experience.description != _descriptionController.text) {
      _descriptionController.text = widget.experience.description ?? '';
    }
  }

  @override
  void dispose() {
    _companyController.dispose();
    _positionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateExperience() {
    final list = [...ref.read(resumeProvider).experience];
    if (widget.index < list.length) {
      list[widget.index] = Experience(
        company: _companyController.text,
        position: _positionController.text,
        startDate: _startDateController.text,
        endDate: _endDateController.text,
        isCurrent: widget.experience.isCurrent,
        description: _descriptionController.text,
      );
      ref.read(resumeProvider.notifier).updateExperienceList(list);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => ref
                      .read(resumeProvider.notifier)
                      .removeExperience(widget.index),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            ResumeTextField(
              label: 'Company *',
              controller: _companyController,
              hint: 'Company Name',
              onChanged: (val) => _updateExperience(),
            ),
            const SizedBox(height: 16),
            ResumeTextField(
              label: 'Position *',
              controller: _positionController,
              hint: 'Job Title',
              onChanged: (val) => _updateExperience(),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ResumeTextField(
                    label: 'Start Date *',
                    controller: _startDateController,
                    hint: 'Select start date',
                    icon: Icons.calendar_today,
                    onChanged: (val) => _updateExperience(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ResumeTextField(
                        label: 'End Date *',
                        controller: _endDateController,
                        hint: 'Select end date',
                        enabled: !widget.experience.isCurrent,
                        icon: Icons.calendar_today,
                        onChanged: (val) => _updateExperience(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: widget.experience.isCurrent,
                  onChanged: (val) {
                    final list = [...ref.read(resumeProvider).experience];
                    if (widget.index < list.length) {
                      list[widget.index] = Experience(
                        company: _companyController.text,
                        position: _positionController.text,
                        startDate: _startDateController.text,
                        endDate: val == true ? 'Present' : '',
                        isCurrent: val ?? false,
                        description: _descriptionController.text,
                      );
                      ref
                          .read(resumeProvider.notifier)
                          .updateExperienceList(list);
                    }
                  },
                ),
                const Text('Currently working', style: TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 16),
            ResumeTextField(
              label: 'Description',
              controller: _descriptionController,
              hint: 'Responsibilities...',
              maxLines: 3,
              onChanged: (val) => _updateExperience(),
            ),
          ],
        ),
      ),
    );
  }
}

class EducationCard extends ConsumerStatefulWidget {
  final Education education;
  final int index;

  const EducationCard({
    super.key,
    required this.education,
    required this.index,
  });

  @override
  ConsumerState<EducationCard> createState() => _EducationCardState();
}

class _EducationCardState extends ConsumerState<EducationCard> {
  late TextEditingController _institutionController;
  late TextEditingController _degreeController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;

  @override
  void initState() {
    super.initState();
    _institutionController = TextEditingController(
      text: widget.education.institution,
    );
    _degreeController = TextEditingController(text: widget.education.degree);
    _startDateController = TextEditingController(
      text: widget.education.startDate,
    );
    _endDateController = TextEditingController(text: widget.education.endDate);
  }

  @override
  void didUpdateWidget(EducationCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.education.institution != _institutionController.text) {
      _institutionController.text = widget.education.institution;
    }
    if (widget.education.degree != _degreeController.text) {
      _degreeController.text = widget.education.degree;
    }
    if (widget.education.startDate != _startDateController.text) {
      _startDateController.text = widget.education.startDate;
    }
    if (widget.education.endDate != _endDateController.text) {
      _endDateController.text = widget.education.endDate;
    }
  }

  @override
  void dispose() {
    _institutionController.dispose();
    _degreeController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  void _updateEducation() {
    final list = [...ref.read(resumeProvider).education];
    if (widget.index < list.length) {
      list[widget.index] = Education(
        institution: _institutionController.text,
        degree: _degreeController.text,
        startDate: _startDateController.text,
        endDate: _endDateController.text,
        isCurrent: widget.education.isCurrent,
        description: widget.education.description,
      );
      ref.read(resumeProvider.notifier).updateEducationList(list);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => ref
                      .read(resumeProvider.notifier)
                      .removeEducation(widget.index),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            ResumeTextField(
              label: 'Institution *',
              controller: _institutionController,
              hint: 'University/School Name',
              onChanged: (val) => _updateEducation(),
            ),
            const SizedBox(height: 16),
            ResumeTextField(
              label: 'Degree *',
              controller: _degreeController,
              hint: 'Bachelors/Masters in...',
              onChanged: (val) => _updateEducation(),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ResumeTextField(
                    label: 'Start Date *',
                    controller: _startDateController,
                    hint: 'Select start date',
                    icon: Icons.calendar_today,
                    onChanged: (val) => _updateEducation(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ResumeTextField(
                        label: 'End Date *',
                        controller: _endDateController,
                        hint: 'Select end date',
                        enabled: !widget.education.isCurrent,
                        icon: Icons.calendar_today,
                        onChanged: (val) => _updateEducation(),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            visualDensity: VisualDensity.compact,
                            value: widget.education.isCurrent,
                            onChanged: (val) {
                              final list = [
                                ...ref.read(resumeProvider).education,
                              ];
                              if (widget.index < list.length) {
                                list[widget.index] = Education(
                                  institution: _institutionController.text,
                                  degree: _degreeController.text,
                                  startDate: _startDateController.text,
                                  endDate: val == true ? 'Present' : '',
                                  isCurrent: val ?? false,
                                  description: widget.education.description,
                                );
                                ref
                                    .read(resumeProvider.notifier)
                                    .updateEducationList(list);
                              }
                            },
                          ),
                          const Text(
                            'Currently studying',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CertificateCard extends ConsumerStatefulWidget {
  final Certificate certificate;
  final int index;

  const CertificateCard({
    super.key,
    required this.certificate,
    required this.index,
  });

  @override
  ConsumerState<CertificateCard> createState() => _CertificateCardState();
}

class _CertificateCardState extends ConsumerState<CertificateCard> {
  late TextEditingController _nameController;
  late TextEditingController _issuerController;
  late TextEditingController _dateController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.certificate.name);
    _issuerController = TextEditingController(text: widget.certificate.issuer);
    _dateController = TextEditingController(text: widget.certificate.date);
    _descriptionController = TextEditingController(
      text: widget.certificate.description,
    );
  }

  @override
  void didUpdateWidget(CertificateCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.certificate.name != _nameController.text) {
      _nameController.text = widget.certificate.name;
    }
    if (widget.certificate.issuer != _issuerController.text) {
      _issuerController.text = widget.certificate.issuer;
    }
    if (widget.certificate.date != _dateController.text) {
      _dateController.text = widget.certificate.date;
    }
    if (widget.certificate.description != _descriptionController.text) {
      _descriptionController.text = widget.certificate.description ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _issuerController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateCertificate() {
    final list = [...ref.read(resumeProvider).certificates];
    if (widget.index < list.length) {
      list[widget.index] = Certificate(
        name: _nameController.text,
        issuer: _issuerController.text,
        date: _dateController.text,
        description: _descriptionController.text,
      );
      ref.read(resumeProvider.notifier).updateCertificatesList(list);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => ref
                      .read(resumeProvider.notifier)
                      .removeCertificate(widget.index),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            ResumeTextField(
              label: 'Certificate Name *',
              controller: _nameController,
              hint: 'e.g. AWS Certified Solutions Architect',
              onChanged: (val) => _updateCertificate(),
            ),
            const SizedBox(height: 16),
            ResumeTextField(
              label: 'Issuer *',
              controller: _issuerController,
              hint: 'e.g. Amazon Web Services',
              onChanged: (val) => _updateCertificate(),
            ),
            const SizedBox(height: 16),
            ResumeTextField(
              label: 'Date *',
              controller: _dateController,
              hint: 'Select date',
              icon: Icons.calendar_today,
              onChanged: (val) => _updateCertificate(),
            ),
            const SizedBox(height: 16),
            ResumeTextField(
              label: 'Description',
              controller: _descriptionController,
              hint: 'Optional brief description',
              onChanged: (val) => _updateCertificate(),
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageCard extends ConsumerStatefulWidget {
  final Language language;
  final int index;

  const LanguageCard({super.key, required this.language, required this.index});

  @override
  ConsumerState<LanguageCard> createState() => _LanguageCardState();
}

class _LanguageCardState extends ConsumerState<LanguageCard> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.language.name);
  }

  @override
  void didUpdateWidget(LanguageCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.language.name != _nameController.text) {
      _nameController.text = widget.language.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _updateLanguage() {
    final list = [...ref.read(resumeProvider).languages];
    if (widget.index < list.length) {
      list[widget.index] = Language(
        name: _nameController.text,
        proficiency: widget.language.proficiency,
      );
      ref.read(resumeProvider.notifier).updateLanguageList(list);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => ref
                      .read(resumeProvider.notifier)
                      .removeLanguage(widget.index),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ResumeTextField(
                    label: 'Language',
                    controller: _nameController,
                    hint: 'English, Spanish...',
                    onChanged: (val) => _updateLanguage(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Proficiency',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value:
                            [
                              'Native',
                              'Fluent',
                              'Intermediate',
                              'Beginner',
                            ].contains(widget.language.proficiency)
                            ? widget.language.proficiency
                            : 'Native',
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                        items: ['Native', 'Fluent', 'Intermediate', 'Beginner']
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            final list = [
                              ...ref.read(resumeProvider).languages,
                            ];
                            if (widget.index < list.length) {
                              list[widget.index] = Language(
                                name: _nameController.text,
                                proficiency: val,
                              );
                              ref
                                  .read(resumeProvider.notifier)
                                  .updateLanguageList(list);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
