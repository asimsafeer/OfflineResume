import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/resume_provider.dart';
import '../models/resume_data.dart';

class ResumeForm extends ConsumerStatefulWidget {
  const ResumeForm({super.key});

  @override
  ConsumerState<ResumeForm> createState() => _ResumeFormState();
}

class _ResumeFormState extends ConsumerState<ResumeForm> {
  late TextEditingController _nameController;
  late TextEditingController _titleController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _summaryController;
  late TextEditingController _linkedinController;
  late TextEditingController _githubController;
  late TextEditingController _instagramController;
  late TextEditingController _facebookController;
  late TextEditingController _websiteController;

  @override
  void initState() {
    super.initState();
    final data = ref.read(resumeProvider);
    _nameController = TextEditingController(text: data.personalInfo.fullName);
    _titleController = TextEditingController(text: data.personalInfo.title);
    _emailController = TextEditingController(text: data.personalInfo.email);
    _phoneController = TextEditingController(text: data.personalInfo.phone);
    _addressController = TextEditingController(text: data.personalInfo.address);
    _summaryController = TextEditingController(text: data.personalInfo.summary);
    _linkedinController = TextEditingController(
      text: data.personalInfo.linkedin,
    );
    _githubController = TextEditingController(text: data.personalInfo.github);
    _instagramController = TextEditingController(
      text: data.personalInfo.instagram,
    );
    _facebookController = TextEditingController(
      text: data.personalInfo.facebook,
    );
    _websiteController = TextEditingController(text: data.personalInfo.website);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _summaryController.dispose();
    _linkedinController.dispose();
    _githubController.dispose();
    _instagramController.dispose();
    _facebookController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  void _updatePersonalInfo() {
    final currentInfo = ref.read(resumeProvider).personalInfo;
    ref
        .read(resumeProvider.notifier)
        .updatePersonalInfo(
          currentInfo.copyWith(
            fullName: _nameController.text,
            title: _titleController.text,
            email: _emailController.text,
            phone: _phoneController.text,
            address: _addressController.text,
            summary: _summaryController.text,
            linkedin: _linkedinController.text,
            github: _githubController.text,
            instagram: _instagramController.text,
            facebook: _facebookController.text,
            website: _websiteController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(resumeProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(Icons.layers, 'Design & Template'),
          _buildDesignCard(data),
          const SizedBox(height: 32),
          _buildSectionHeader(Icons.person, 'Personal Information'),
          _buildPersonalInfoCard(data),
          const SizedBox(height: 32),
          _buildExperienceSection(data),
          const SizedBox(height: 32),
          _buildEducationSection(data),
          const SizedBox(height: 32),
          _buildCertificatesSection(data),
          const SizedBox(height: 32),
          _buildSkillsSection(data),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF3B82F6)),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDesignCard(ResumeData data) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blue.withValues(alpha: 0.2)),
      ),
      color: Colors.blue.withValues(alpha: 0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Template Style',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<TemplateId>(
                        initialValue: data.templateId,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                        ),
                        isExpanded: true,
                        items: TemplateId.values.map((id) {
                          return DropdownMenuItem(
                            value: id,
                            child: Text(
                              id.name.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            ref
                                .read(resumeProvider.notifier)
                                .updateDesign(
                                  val,
                                  data.themeColor,
                                  data.fontFamily,
                                  data.fontSize,
                                );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Theme Color',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(
                                int.parse(
                                  data.themeColor.replaceFirst('#', '0xFF'),
                                ),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: '#3B82F6',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                              ),
                              onChanged: (val) {
                                if (val.startsWith('#') &&
                                    (val.length == 7 || val.length == 4)) {
                                  ref
                                      .read(resumeProvider.notifier)
                                      .updateDesign(
                                        data.templateId,
                                        val,
                                        data.fontFamily,
                                        data.fontSize,
                                      );
                                }
                              },
                            ),
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

  Widget _buildPersonalInfoCard(ResumeData data) {
    return Card(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    // TODO: Implement Image Picker
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo, color: Colors.grey),
                        SizedBox(height: 4),
                        Text(
                          'Photo',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      _buildTextField(
                        'Full Name',
                        _nameController,
                        hint: 'e.g. Ali Khan',
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        'Job Title',
                        _titleController,
                        hint: 'e.g. Software Engineer',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Email',
                    _emailController,
                    hint: 'yourname@example.com',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    'Phone',
                    _phoneController,
                    hint: '03001234567',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Address',
              _addressController,
              hint: 'e.g. Lahore, Pakistan',
            ),
            const SizedBox(height: 24),
            _buildTextField(
              'Professional Summary',
              _summaryController,
              hint: 'Briefly describe your career...',
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Social Links',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'LinkedIn',
                    _linkedinController,
                    hint: 'username',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    'GitHub',
                    _githubController,
                    hint: 'username',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Instagram',
                    _instagramController,
                    hint: 'username',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    'Facebook',
                    _facebookController,
                    hint: 'username',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Website',
              _websiteController,
              hint: 'https://yourwebsite.com',
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceSection(ResumeData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader(Icons.work, 'Work Experience'),
            OutlinedButton.icon(
              onPressed: () {
                ref
                    .read(resumeProvider.notifier)
                    .addExperience(
                      Experience(
                        company: '',
                        position: '',
                        startDate: '',
                        endDate: '',
                      ),
                    );
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add'),
            ),
          ],
        ),
        _buildFontControls(
          fontFamily: data.experienceFontFamily,
          fontSize: data.experienceFontSize,
          onFontChange: (font) {
            ref.read(resumeProvider.notifier).updateExperienceDesign(
              font,
              data.experienceFontSize,
            );
          },
          onSizeChange: (size) {
            ref.read(resumeProvider.notifier).updateExperienceDesign(
              data.experienceFontFamily,
              size,
            );
          },
        ),
        const SizedBox(height: 16),
        if (data.experience.isEmpty)
          _buildEmptyState('No experience added yet.')
        else
          ...data.experience.asMap().entries.map((entry) {
            return _buildExperienceCard(entry.value, entry.key);
          }),
      ],
    );
  }

  Widget _buildExperienceCard(Experience exp, int index) {
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
                  onPressed: () =>
                      ref.read(resumeProvider.notifier).removeExperience(index),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            _buildTextField(
              'Company *',
              TextEditingController(text: exp.company),
              hint: 'Company Name',
              onChanged: (val) {
                final list = [...ref.read(resumeProvider).experience];
                list[index] = Experience(
                  company: val,
                  position: exp.position,
                  startDate: exp.startDate,
                  endDate: exp.endDate,
                  isCurrent: exp.isCurrent,
                  description: exp.description,
                );
                ref.read(resumeProvider.notifier).updateExperienceList(list);
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Position *',
              TextEditingController(text: exp.position),
              hint: 'Job Title',
              onChanged: (val) {
                final list = [...ref.read(resumeProvider).experience];
                list[index] = Experience(
                  company: exp.company,
                  position: val,
                  startDate: exp.startDate,
                  endDate: exp.endDate,
                  isCurrent: exp.isCurrent,
                  description: exp.description,
                );
                ref.read(resumeProvider.notifier).updateExperienceList(list);
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Start Date *',
                    TextEditingController(text: exp.startDate),
                    hint: 'Select start date', // Assuming a date picker, sticking to text for now based on existing patterns
                    onChanged: (val) {
                      final list = [...ref.read(resumeProvider).experience];
                      list[index] = Experience(
                        company: exp.company,
                        position: exp.position,
                        startDate: val,
                        endDate: exp.endDate,
                        isCurrent: exp.isCurrent,
                        description: exp.description,
                      );
                      ref
                          .read(resumeProvider.notifier)
                          .updateExperienceList(list);
                    },
                    icon: Icons.calendar_today,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                       Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: exp.isCurrent,
                              visualDensity: VisualDensity.compact,
                              onChanged: (val) {
                                final list = [...ref.read(resumeProvider).experience];
                                list[index] = Experience(
                                  company: exp.company,
                                  position: exp.position,
                                  startDate: exp.startDate,
                                  endDate: val == true ? 'Present' : '',
                                  isCurrent: val ?? false,
                                  description: exp.description,
                                );
                                ref
                                    .read(resumeProvider.notifier)
                                    .updateExperienceList(list);
                              },
                            ),
                            const Text('Currently working', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      _buildTextField(
                        'End Date *',
                        TextEditingController(text: exp.endDate),
                        hint: 'Select end date',
                        enabled: !exp.isCurrent,
                        onChanged: (val) {
                          final list = [...ref.read(resumeProvider).experience];
                          list[index] = Experience(
                            company: exp.company,
                            position: exp.position,
                            startDate: exp.startDate,
                            endDate: val,
                            isCurrent: exp.isCurrent,
                            description: exp.description,
                          );
                          ref
                              .read(resumeProvider.notifier)
                              .updateExperienceList(list);
                        },
                        icon: Icons.calendar_today,
                      ),
                    ],
                  ),
                ),
              ],
            ),
                    list[index] = Experience(
                      company: exp.company,
                      position: exp.position,
                      startDate: exp.startDate,
                      endDate: val == true ? 'Present' : '',
                      isCurrent: val ?? false,
                      description: exp.description,
                    );
                    ref
                        .read(resumeProvider.notifier)
                        .updateExperienceList(list);
                  },
                ),
                const Text('Currently working', style: TextStyle(fontSize: 12)),
              ],
            ),


            const SizedBox(height: 16),
            _buildTextField(
              'Description',
              TextEditingController(text: exp.description),
              hint: 'Responsibilities...',
              maxLines: 3,
              onChanged: (val) {
                final list = [...ref.read(resumeProvider).experience];
                list[index] = Experience(
                  company: exp.company,
                  position: exp.position,
                  startDate: exp.startDate,
                  endDate: exp.endDate,
                  isCurrent: exp.isCurrent,
                  description: val,
                );
                ref.read(resumeProvider.notifier).updateExperienceList(list);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationSection(ResumeData data) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader(Icons.school, 'Education'),
            OutlinedButton.icon(
              onPressed: () {
                ref
                    .read(resumeProvider.notifier)
                    .addEducation(
                      Education(
                        institution: '',
                        degree: '',
                        startDate: '',
                        endDate: '',
                      ),
                    );
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add'),
            ),
          ],
        ),
        if (data.education.isEmpty)
          _buildEmptyState('No education added yet.')
        else
          ...data.education.asMap().entries.map((entry) {
            return _buildEducationCard(entry.value, entry.key);
          }),
      ],
    );
  }

  Widget _buildEducationCard(Education edu, int index) {
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
                  onPressed: () =>
                      ref.read(resumeProvider.notifier).removeEducation(index),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            _buildTextField(
              'Institution',
              TextEditingController(text: edu.institution),
              hint: 'University/School Name',
              onChanged: (val) {
                final list = [...ref.read(resumeProvider).education];
                list[index] = Education(
                  institution: val,
                  degree: edu.degree,
                  startDate: edu.startDate,
                  endDate: edu.endDate,
                  isCurrent: edu.isCurrent,
                  description: edu.description,
                );
                ref.read(resumeProvider.notifier).updateEducationList(list);
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Degree',
              TextEditingController(text: edu.degree),
              hint: 'Bachelors/Masters in...',
              onChanged: (val) {
                final list = [...ref.read(resumeProvider).education];
                list[index] = Education(
                  institution: edu.institution,
                  degree: val,
                  startDate: edu.startDate,
                  endDate: edu.endDate,
                  isCurrent: edu.isCurrent,
                  description: edu.description,
                );
                ref.read(resumeProvider.notifier).updateEducationList(list);
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Start Date',
                    TextEditingController(text: edu.startDate),
                    hint: 'MM/YYYY',
                    onChanged: (val) {
                      final list = [...ref.read(resumeProvider).education];
                      list[index] = Education(
                        institution: edu.institution,
                        degree: edu.degree,
                        startDate: val,
                        endDate: edu.endDate,
                        isCurrent: edu.isCurrent,
                        description: edu.description,
                      );
                      ref
                          .read(resumeProvider.notifier)
                          .updateEducationList(list);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    'End Date',
                    TextEditingController(text: edu.endDate),
                    hint: 'MM/YYYY',
                    enabled: !edu.isCurrent,
                    onChanged: (val) {
                      final list = [...ref.read(resumeProvider).education];
                      list[index] = Education(
                        institution: edu.institution,
                        degree: edu.degree,
                        startDate: edu.startDate,
                        endDate: val,
                        isCurrent: edu.isCurrent,
                        description: edu.description,
                      );
                      ref
                          .read(resumeProvider.notifier)
                          .updateEducationList(list);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsSection(ResumeData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(Icons.bolt, 'Skills'),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[200]!),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'React, TypeScript, Node.js...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              controller: TextEditingController(text: data.skills.join(', ')),
              onChanged: (val) {
                final skills = val
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();
                ref.read(resumeProvider.notifier).updateSkills(skills);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildCertificatesSection(ResumeData data) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader(Icons.card_membership, 'Certificates'),
            OutlinedButton.icon(
              onPressed: () {
                ref
                    .read(resumeProvider.notifier)
                    .addCertificate(
                      Certificate(
                        name: '',
                        issuer: '',
                        date: '',
                        description: ''
                      ),
                    );
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Certificate'),
            ),
          ],
        ),
        if (data.certificates.isEmpty)
          _buildEmptyState('No certificates added yet.')
        else
          ...data.certificates.asMap().entries.map((entry) {
            return _buildCertificateCard(entry.value, entry.key);
          }),
      ],
    );
  }

  Widget _buildCertificateCard(Certificate cert, int index) {
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
                  onPressed: () =>
                      ref.read(resumeProvider.notifier).removeCertificate(index),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            _buildTextField(
              'Certificate Name *',
              TextEditingController(text: cert.name),
              hint: 'e.g. AWS Certified Solutions Architect',
              onChanged: (val) {
                final list = [...ref.read(resumeProvider).certificates];
                list[index] = Certificate(
                  name: val,
                  issuer: cert.issuer,
                  date: cert.date,
                  description: cert.description,
                );
                ref.read(resumeProvider.notifier).updateCertificatesList(list);
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Issuer *',
              TextEditingController(text: cert.issuer),
              hint: 'e.g. Amazon Web Services',
              onChanged: (val) {
                final list = [...ref.read(resumeProvider).certificates];
                list[index] = Certificate(
                  name: cert.name,
                  issuer: val,
                  date: cert.date,
                  description: cert.description,
                );
                ref.read(resumeProvider.notifier).updateCertificatesList(list);
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Date *',
              TextEditingController(text: cert.date),
              hint: 'Select date',
              icon: Icons.calendar_today,
              onChanged: (val) {
                final list = [...ref.read(resumeProvider).certificates];
                list[index] = Certificate(
                  name: cert.name,
                  issuer: cert.issuer,
                  date: val,
                  description: cert.description,
                );
                ref.read(resumeProvider.notifier).updateCertificatesList(list);
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Description',
              TextEditingController(text: cert.description ?? ''),
              hint: 'Optional brief description',
              onChanged: (val) {
                final list = [...ref.read(resumeProvider).certificates];
                list[index] = Certificate(
                  name: cert.name,
                  issuer: cert.issuer,
                  date: cert.date,
                  description: val,
                );
                ref.read(resumeProvider.notifier).updateCertificatesList(list);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontControls({
    required String? fontFamily,
    required double? fontSize,
    required Function(String) onFontChange,
    required Function(double) onSizeChange,
  }) {
    return Row(
      children: [
        const Text('Font: ', style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(width: 8),
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButton<String>(
            value: fontFamily ?? 'Inter',
            underline: const SizedBox(),
            style: const TextStyle(fontSize: 12, color: Colors.black),
            icon: const Icon(Icons.keyboard_arrow_down, size: 16),
            items: ['Inter', 'Roboto', 'Open Sans', 'Lato'].map((font) {
              return DropdownMenuItem(
                value: font,
                child: Text(font),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) onFontChange(val);
            },
          ),
        ),
        const SizedBox(width: 24),
        const Text('Size: ', style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(width: 8),
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButton<double>(
            value: fontSize ?? 12.0,
            underline: const SizedBox(),
            style: const TextStyle(fontSize: 12, color: Colors.black),
            icon: const Icon(Icons.keyboard_arrow_down, size: 16),
            items: [10.0, 11.0, 12.0, 13.0, 14.0].map((size) {
              return DropdownMenuItem(
                value: size,
                child: Text('${size.toInt()}px'),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) onSizeChange(val);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    String? hint,
    int maxLines = 1,
    bool enabled = true,
    Function(String)? onChanged,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Text(
               label.replaceAll('*', ''), // Helper to remove * for label if needed, or keep it
               style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
             ),
             if (label.contains('*'))
                const Text('*', style: TextStyle(color: Colors.red, fontSize: 13)),
           ]
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          enabled: enabled,
          onChanged: (val) {
            if (onChanged != null) {
              onChanged(val);
            } else {
              _updatePersonalInfo();
            }
          },
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon, size: 18, color: Colors.grey) : null,
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
