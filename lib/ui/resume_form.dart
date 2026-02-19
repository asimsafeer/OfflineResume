import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../providers/resume_provider.dart';
import '../models/resume_data.dart';
import 'resume_form_items.dart';

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
  late TextEditingController _skillsController;

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
    _skillsController = TextEditingController(text: data.skills.join(', '));
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
    _skillsController.dispose();
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

  Future<bool> _requestPermission(
    Permission permission,
    String title,
    String message,
  ) async {
    final status = await permission.status;
    if (status.isGranted) return true;

    if (!mounted) return false;

    final proceed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Grant Permission'),
          ),
        ],
      ),
    );

    if (proceed != true) return false;

    final result = await permission.request();
    return result.isGranted;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    bool hasPermission = false;
    if (source == ImageSource.camera) {
      hasPermission = await _requestPermission(
        Permission.camera,
        'Camera Access',
        'We need access to your camera to take a profile picture for your resume.',
      );
    } else {
      if (Platform.isAndroid) {
        // Checking for different Android versions is handled by permission_handler
        // but for photos specifically:
        hasPermission = await _requestPermission(
          Permission.photos,
          'Gallery Access',
          'We need access to your gallery to select a profile picture for your resume.',
        );
      } else {
        hasPermission = await _requestPermission(
          Permission.photos,
          'Photos Access',
          'We need access to your photos to select a profile picture for your resume.',
        );
      }
    }

    if (!hasPermission) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permission denied. You can still fill the form.'),
          ),
        );
      }
      return;
    }

    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      final currentInfo = ref.read(resumeProvider).personalInfo;
      ref
          .read(resumeProvider.notifier)
          .updatePersonalInfo(currentInfo.copyWith(profilePicture: image.path));
    }
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
          const SizedBox(height: 32),
          _buildLanguagesSection(data),
          const SizedBox(height: 120),
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
    const colors = [
      '#3B82F6', // Blue
      '#EF4444', // Red
      '#10B981', // Green
      '#F59E0B', // Amber
      '#8B5CF6', // Purple
      '#EC4899', // Pink
      '#6366F1', // Indigo
      '#1F2937', // Gray
      '#000000', // Black
    ];

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
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Theme Color',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: colors.map((color) {
                    final isSelected =
                        data.themeColor.toLowerCase() == color.toLowerCase();
                    return GestureDetector(
                      onTap: () {
                        ref
                            .read(resumeProvider.notifier)
                            .updateDesign(
                              data.templateId,
                              color,
                              data.fontFamily,
                              data.fontSize,
                            );
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Color(
                            int.parse(color.replaceFirst('#', '0xFF')),
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? Colors.black
                                : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
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
                  onTap: _pickImage,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      image:
                          data.personalInfo.profilePicture != null &&
                              data.personalInfo.profilePicture!.isNotEmpty
                          ? DecorationImage(
                              image:
                                  data.personalInfo.profilePicture!.startsWith(
                                    'http',
                                  )
                                  ? NetworkImage(
                                      data.personalInfo.profilePicture!,
                                    )
                                  : FileImage(
                                          File(
                                            data.personalInfo.profilePicture!,
                                          ),
                                        )
                                        as ImageProvider,
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child:
                        data.personalInfo.profilePicture == null ||
                            data.personalInfo.profilePicture!.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                color: Colors.grey[400],
                                size: 32,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add Photo',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                        : null,
                  ),
                ),

                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      ResumeTextField(
                        label: 'Full Name',
                        controller: _nameController,
                        hint: 'e.g. Ali Khan',
                        onChanged: (_) => _updatePersonalInfo(),
                      ),
                      const SizedBox(height: 16),
                      ResumeTextField(
                        label: 'Job Title',
                        controller: _titleController,
                        hint: 'e.g. Software Engineer',
                        onChanged: (_) => _updatePersonalInfo(),
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
                  child: ResumeTextField(
                    label: 'Email',
                    controller: _emailController,
                    hint: 'yourname@example.com',
                    onChanged: (_) => _updatePersonalInfo(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ResumeTextField(
                    label: 'Phone',
                    controller: _phoneController,
                    hint: '03001234567',
                    onChanged: (_) => _updatePersonalInfo(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ResumeTextField(
              label: 'Address',
              controller: _addressController,
              hint: 'e.g. Lahore, Pakistan',
              onChanged: (_) => _updatePersonalInfo(),
            ),
            const SizedBox(height: 24),
            ResumeTextField(
              label: 'Professional Summary',
              controller: _summaryController,
              hint: 'Briefly describe your career...',
              maxLines: 4,
              onChanged: (_) => _updatePersonalInfo(),
            ),
            const SizedBox(height: 8),
            _buildFontControls(
              fontFamily: data.personalInfo.summaryFontFamily,
              fontSize: data.personalInfo.summaryFontSize,
              onFontChange: (font) {
                ref
                    .read(resumeProvider.notifier)
                    .updateSummaryDesign(
                      font,
                      data.personalInfo.summaryFontSize,
                    );
              },
              onSizeChange: (size) {
                ref
                    .read(resumeProvider.notifier)
                    .updateSummaryDesign(
                      data.personalInfo.summaryFontFamily,
                      size,
                    );
              },
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
                  child: ResumeTextField(
                    label: 'LinkedIn',
                    controller: _linkedinController,
                    hint: 'username',
                    onChanged: (_) => _updatePersonalInfo(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ResumeTextField(
                    label: 'GitHub',
                    controller: _githubController,
                    hint: 'username',
                    onChanged: (_) => _updatePersonalInfo(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ResumeTextField(
                    label: 'Instagram',
                    controller: _instagramController,
                    hint: 'username',
                    onChanged: (_) => _updatePersonalInfo(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ResumeTextField(
                    label: 'Facebook',
                    controller: _facebookController,
                    hint: 'username',
                    onChanged: (_) => _updatePersonalInfo(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ResumeTextField(
              label: 'Website',
              controller: _websiteController,
              hint: 'https://yourwebsite.com',
              onChanged: (_) => _updatePersonalInfo(),
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
            ref
                .read(resumeProvider.notifier)
                .updateExperienceDesign(font, data.experienceFontSize);
          },
          onSizeChange: (size) {
            ref
                .read(resumeProvider.notifier)
                .updateExperienceDesign(data.experienceFontFamily, size);
          },
        ),
        const SizedBox(height: 16),
        if (data.experience.isEmpty)
          _buildEmptyState('No experience added yet.')
        else
          ...data.experience.asMap().entries.map((entry) {
            return ExperienceCard(experience: entry.value, index: entry.key);
          }),
      ],
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
        _buildFontControls(
          fontFamily: data.educationFontFamily,
          fontSize: data.educationFontSize,
          onFontChange: (font) {
            ref
                .read(resumeProvider.notifier)
                .updateEducationDesign(font, data.educationFontSize);
          },
          onSizeChange: (size) {
            ref
                .read(resumeProvider.notifier)
                .updateEducationDesign(data.educationFontFamily, size);
          },
        ),
        const SizedBox(height: 16),
        if (data.education.isEmpty)
          _buildEmptyState('No education added yet.')
        else
          ...data.education.asMap().entries.map((entry) {
            return EducationCard(education: entry.value, index: entry.key);
          }),
      ],
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
              controller: _skillsController,
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
              maxLines: 3,
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
                        description: '',
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
            return CertificateCard(certificate: entry.value, index: entry.key);
          }),
      ],
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
        const Text(
          'Font: ',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
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
              return DropdownMenuItem(value: font, child: Text(font));
            }).toList(),
            onChanged: (val) {
              if (val != null) onFontChange(val);
            },
          ),
        ),
        const SizedBox(width: 24),
        const Text(
          'Size: ',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
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

  Widget _buildLanguagesSection(ResumeData data) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader(Icons.language, 'Languages'),
            OutlinedButton.icon(
              onPressed: () {
                ref
                    .read(resumeProvider.notifier)
                    .addLanguage(Language(name: '', proficiency: 'Native'));
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Language'),
            ),
          ],
        ),
        if (data.languages.isEmpty)
          _buildEmptyState('No languages added yet.')
        else
          ...data.languages.asMap().entries.map((entry) {
            return LanguageCard(language: entry.value, index: entry.key);
          }),
      ],
    );
  }
}
