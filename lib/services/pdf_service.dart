import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/resume_data.dart';

/// Builds the PDF so it looks like the on-screen preview
/// (lib/ui/templates/*). Keep the two in sync when changing a template.
class PdfService {
  /// Preview sizes are screen pixels on an ~720px-wide page; the PDF page is
  /// ~515pt wide, so sizes are scaled down to keep the same proportions.
  static const double _k = 0.85;

  static final Map<String, pw.Font> _fontCache = {};

  static const Map<String, String> _fontFiles = {
    'Inter': 'Inter',
    'Roboto': 'Roboto',
    'Open Sans': 'OpenSans',
    'Lato': 'Lato',
    'Merriweather': 'Merriweather',
  };

  static Future<Uint8List> generateResume(ResumeData data) async {
    final isClassic = data.templateId == TemplateId.classic;
    final baseFamily = isClassic ? 'Merriweather' : 'Inter';
    final fonts = await _loadFonts({
      baseFamily,
      data.personalInfo.summaryFontFamily,
      data.experienceFontFamily ?? baseFamily,
      data.educationFontFamily ?? baseFamily,
    });

    final themeColor = _parseColor(data.themeColor);
    final photo = _loadPhoto(data.personalInfo);

    final pdf = pw.Document(
      title: '${data.personalInfo.fullName} CV'.trim(),
      author: data.personalInfo.fullName,
      theme: pw.ThemeData.withFont(
        base: fonts.get(baseFamily),
        bold: fonts.get(baseFamily, bold: true),
        italic: fonts.get(baseFamily, italic: true),
      ),
    );

    final builder = isClassic
        ? _ClassicPdf(data, fonts, themeColor)
        : _ModernPdf(data, fonts, themeColor, photo);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => builder.build(),
      ),
    );

    return pdf.save();
  }

  static PdfColor _parseColor(String hex) {
    try {
      return PdfColor.fromInt(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return PdfColor.fromInt(0xFF3B82F6);
    }
  }

  static pw.MemoryImage? _loadPhoto(PersonalInfo info) {
    final path = info.profilePicture;
    if (path == null || path.isEmpty || path.startsWith('http')) return null;
    try {
      final file = File(path);
      if (!file.existsSync()) return null;
      return pw.MemoryImage(file.readAsBytesSync());
    } catch (e) {
      debugPrint('Could not load photo for PDF: $e');
      return null;
    }
  }

  static Future<_Fonts> _loadFonts(Set<String> families) async {
    for (final family in families) {
      final file = _fontFiles[family] ?? 'Inter';
      for (final variant in _variants) {
        final key = '$file-$variant';
        if (_fontCache.containsKey(key)) continue;
        try {
          final bytes = await rootBundle.load('assets/fonts/$key.ttf');
          _fontCache[key] = pw.Font.ttf(bytes);
        } catch (_) {
          // Missing weight (e.g. Lato has no Medium): falls back below.
        }
      }
    }
    return _Fonts(_fontCache, _fontFiles);
  }

  static const _variants = ['Regular', 'Medium', 'Bold', 'Italic'];
}

class _Fonts {
  final Map<String, pw.Font> _cache;
  final Map<String, String> _files;

  _Fonts(this._cache, this._files);

  pw.Font get(
    String family, {
    bool bold = false,
    bool medium = false,
    bool italic = false,
  }) {
    final file = _files[family] ?? 'Inter';
    final variant = bold
        ? 'Bold'
        : italic
        ? 'Italic'
        : medium
        ? 'Medium'
        : 'Regular';
    return _cache['$file-$variant'] ??
        _cache['$file-Regular'] ??
        _cache['Inter-Regular'] ??
        pw.Font.helvetica();
  }

  pw.TextStyle style(
    String family,
    double size, {
    bool bold = false,
    bool medium = false,
    bool italic = false,
    PdfColor? color,
    double? height,
    double? letterSpacing,
  }) {
    final s = size * PdfService._k;
    return pw.TextStyle(
      font: get(family, bold: bold, medium: medium, italic: italic),
      fontSize: s,
      color: color ?? PdfColors.black,
      lineSpacing: height != null ? s * (height - 1) : null,
      letterSpacing: letterSpacing != null
          ? letterSpacing * PdfService._k
          : null,
    );
  }
}

abstract class _TemplatePdf {
  final ResumeData data;
  final _Fonts f;
  final PdfColor theme;

  _TemplatePdf(this.data, this.f, this.theme);

  PersonalInfo get info => data.personalInfo;

  List<pw.Widget> build();

  pw.Widget gap(double h) => pw.SizedBox(height: h * PdfService._k);

  bool has(String? v) => v != null && v.isNotEmpty;

  /// Text that opens a link when tapped in the PDF.
  pw.Widget link(String text, String? url, pw.TextStyle style) {
    final t = pw.Text(text, style: style);
    if (url == null) return t;
    return pw.UrlLink(destination: url, child: t);
  }

  String webUrl(String v) => v.startsWith('http') ? v : 'https://$v';
}

class _ModernPdf extends _TemplatePdf {
  final pw.MemoryImage? photo;

  _ModernPdf(super.data, super.f, super.theme, this.photo);

  String get expFont => data.experienceFontFamily ?? 'Inter';
  String get eduFont => data.educationFontFamily ?? 'Inter';

  @override
  List<pw.Widget> build() {
    return [
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  info.fullName,
                  style: f.style('Inter', 32, bold: true, color: theme),
                ),
                if (has(info.title))
                  pw.Text(
                    info.title!,
                    style: f.style(
                      'Inter',
                      18,
                      medium: true,
                      color: PdfColors.grey700,
                    ),
                  ),
              ],
            ),
          ),
          if (photo != null)
            pw.ClipRRect(
              horizontalRadius: 8,
              verticalRadius: 8,
              child: pw.Image(
                photo!,
                width: 80 * PdfService._k,
                height: 80 * PdfService._k,
                fit: pw.BoxFit.cover,
              ),
            ),
        ],
      ),
      gap(20),
      pw.Wrap(
        spacing: 16 * PdfService._k,
        runSpacing: 8 * PdfService._k,
        children: _contactItems(),
      ),
      gap(20),
      pw.Divider(color: PdfColors.grey300, thickness: 0.5, height: 1),
      gap(20),
      if (info.summary.isNotEmpty) ...[
        _sectionTitle('PROFILE'),
        gap(8),
        pw.Text(
          info.summary,
          style: f.style(
            info.summaryFontFamily,
            info.summaryFontSize,
            height: 1.5,
          ),
        ),
        gap(24),
      ],
      if (data.experience.isNotEmpty) ...[
        _sectionTitle('EXPERIENCE'),
        gap(12),
        ...data.experience.map(_experience),
        gap(24),
      ],
      if (data.education.isNotEmpty) ...[
        _sectionTitle('EDUCATION'),
        gap(12),
        ...data.education.map(_education),
        gap(24),
      ],
      if (data.skills.isNotEmpty) ...[
        _sectionTitle('SKILLS'),
        gap(8),
        _chips(data.skills),
        gap(24),
      ],
      if (data.languages.isNotEmpty) ...[
        _sectionTitle('LANGUAGES'),
        gap(8),
        _chips(
          data.languages
              .map(
                (l) => l.proficiency.isEmpty
                    ? l.name
                    : '${l.name} · ${l.proficiency}',
              )
              .toList(),
        ),
        gap(24),
      ],
      if (data.certificates.isNotEmpty) ...[
        _sectionTitle('CERTIFICATIONS'),
        gap(12),
        ...data.certificates.map(_certificate),
      ],
    ];
  }

  List<pw.Widget> _contactItems() {
    final style = f.style('Inter', 11, color: PdfColors.grey800);
    return [
      if (info.email.isNotEmpty)
        link(info.email, 'mailto:${info.email}', style),
      if (info.phone.isNotEmpty) link(info.phone, 'tel:${info.phone}', style),
      if (info.address.isNotEmpty) pw.Text(info.address, style: style),
      if (has(info.website)) link(info.website!, webUrl(info.website!), style),
      if (has(info.linkedin))
        link(
          'in/${info.linkedin!}',
          'https://linkedin.com/in/${info.linkedin!}',
          style,
        ),
      if (has(info.github))
        link(
          'github.com/${info.github!}',
          'https://github.com/${info.github!}',
          style,
        ),
      if (has(info.instagram))
        link(
          '@${info.instagram!}',
          'https://instagram.com/${info.instagram!}',
          style,
        ),
      if (has(info.facebook))
        link(
          'fb.com/${info.facebook!}',
          'https://facebook.com/${info.facebook!}',
          style,
        ),
    ];
  }

  pw.Widget _sectionTitle(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: f.style(
            'Inter',
            14,
            bold: true,
            color: theme,
            letterSpacing: 1.2,
          ),
        ),
        pw.Container(
          width: 30 * PdfService._k,
          height: 2,
          color: theme,
          margin: pw.EdgeInsets.only(top: 4 * PdfService._k),
        ),
      ],
    );
  }

  pw.Widget _experience(Experience exp) {
    final size = data.experienceFontSize;
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: 16 * PdfService._k),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Text(
                  exp.position,
                  style: f.style(expFont, size + 1, bold: true),
                ),
              ),
              pw.Text(
                '${exp.startDate} - ${exp.endDate}',
                style: f.style(expFont, size - 1, color: PdfColors.grey600),
              ),
            ],
          ),
          pw.Text(
            exp.company,
            style: f.style(expFont, size, medium: true, color: theme),
          ),
          if (has(exp.description))
            pw.Padding(
              padding: pw.EdgeInsets.only(top: 4 * PdfService._k),
              child: pw.Text(
                exp.description!,
                style: f.style(expFont, size - 1, height: 1.4),
              ),
            ),
        ],
      ),
    );
  }

  pw.Widget _education(Education edu) {
    final size = data.educationFontSize;
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: 12 * PdfService._k),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Text(
                  edu.institution,
                  style: f.style(eduFont, size + 1, bold: true),
                ),
              ),
              pw.Text(
                '${edu.startDate} - ${edu.endDate}',
                style: f.style(eduFont, size - 1, color: PdfColors.grey600),
              ),
            ],
          ),
          pw.Text(edu.degree, style: f.style(eduFont, size, color: theme)),
          if (has(edu.description))
            pw.Padding(
              padding: pw.EdgeInsets.only(top: 4 * PdfService._k),
              child: pw.Text(
                edu.description!,
                style: f.style(eduFont, size - 1),
              ),
            ),
        ],
      ),
    );
  }

  pw.Widget _certificate(Certificate cert) {
    final meta = [
      cert.issuer,
      cert.date,
    ].where((s) => s.isNotEmpty).join(' · ');
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: 10 * PdfService._k),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(cert.name, style: f.style('Inter', 12, bold: true)),
          if (meta.isNotEmpty)
            pw.Text(meta, style: f.style('Inter', 11, color: theme)),
          if (has(cert.description))
            pw.Padding(
              padding: pw.EdgeInsets.only(top: 2 * PdfService._k),
              child: pw.Text(
                cert.description!,
                style: f.style('Inter', 11, height: 1.4),
              ),
            ),
        ],
      ),
    );
  }

  pw.Widget _chips(List<String> items) {
    // Theme colour at 10% over white, like the preview's chip background.
    final bg = PdfColor(
      0.9 + theme.red * 0.1,
      0.9 + theme.green * 0.1,
      0.9 + theme.blue * 0.1,
    );
    return pw.Wrap(
      spacing: 8 * PdfService._k,
      runSpacing: 8 * PdfService._k,
      children: items
          .map(
            (text) => pw.Container(
              padding: pw.EdgeInsets.symmetric(
                horizontal: 10 * PdfService._k,
                vertical: 4 * PdfService._k,
              ),
              decoration: pw.BoxDecoration(
                color: bg,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(3)),
              ),
              child: pw.Text(
                text,
                style: f.style('Inter', 11, medium: true, color: theme),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ClassicPdf extends _TemplatePdf {
  _ClassicPdf(super.data, super.f, super.theme);

  static const _serif = 'Merriweather';

  String get expFont => data.experienceFontFamily ?? _serif;
  String get eduFont => data.educationFontFamily ?? _serif;

  @override
  List<pw.Widget> build() {
    final contact = [
      info.email,
      info.phone,
      info.address,
    ].where((s) => s.isNotEmpty).join(' | ');
    final social = [
      if (has(info.linkedin)) 'LinkedIn: ${info.linkedin}',
      if (has(info.github)) 'GitHub: ${info.github}',
      if (has(info.website)) info.website!,
    ].join(' | ');

    return [
      pw.Center(
        child: pw.Column(
          children: [
            pw.Text(
              info.fullName.toUpperCase(),
              textAlign: pw.TextAlign.center,
              style: f.style(_serif, 24, bold: true, letterSpacing: 1.2),
            ),
            if (has(info.title)) ...[
              gap(4),
              pw.Text(
                info.title!.toUpperCase(),
                textAlign: pw.TextAlign.center,
                style: f.style(_serif, 14, medium: true, letterSpacing: 1.0),
              ),
            ],
            gap(8),
            if (contact.isNotEmpty)
              pw.Text(
                contact,
                textAlign: pw.TextAlign.center,
                style: f.style(_serif, 10),
              ),
            if (social.isNotEmpty) ...[
              gap(4),
              pw.Text(
                social,
                textAlign: pw.TextAlign.center,
                style: f.style(_serif, 10),
              ),
            ],
          ],
        ),
      ),
      gap(24),
      pw.Divider(color: PdfColors.black, thickness: 1, height: 1),
      gap(8),
      if (info.summary.isNotEmpty) ...[
        _sectionTitle('PROFESSIONAL SUMMARY'),
        pw.Text(
          info.summary,
          style: f.style(
            info.summaryFontFamily,
            info.summaryFontSize,
            height: 1.5,
          ),
        ),
        gap(16),
      ],
      if (data.experience.isNotEmpty) ...[
        _sectionTitle('WORK EXPERIENCE'),
        ...data.experience.map(_experience),
        gap(16),
      ],
      if (data.education.isNotEmpty) ...[
        _sectionTitle('EDUCATION'),
        ...data.education.map(_education),
        gap(16),
      ],
      if (data.skills.isNotEmpty) ...[
        _sectionTitle('SKILLS'),
        pw.Text(
          data.skills.join(' • '),
          style: f.style(_serif, 12, height: 1.5),
        ),
        gap(16),
      ],
      if (data.languages.isNotEmpty) ...[
        _sectionTitle('LANGUAGES'),
        pw.Text(
          data.languages.map((l) => '${l.name} (${l.proficiency})').join(' • '),
          style: f.style(_serif, 12, height: 1.5),
        ),
        gap(16),
      ],
      if (data.certificates.isNotEmpty) ...[
        _sectionTitle('CERTIFICATIONS'),
        ...data.certificates.map(_certificate),
      ],
    ];
  }

  pw.Widget _sectionTitle(String title) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(
        bottom: 8 * PdfService._k,
        top: 4 * PdfService._k,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title, style: f.style(_serif, 14, bold: true, color: theme)),
          pw.Divider(color: theme, thickness: 1.5, height: 8 * PdfService._k),
        ],
      ),
    );
  }

  pw.Widget _experience(Experience exp) {
    final size = data.experienceFontSize;
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: 12 * PdfService._k),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Text(
                  exp.company,
                  style: f.style(expFont, size, bold: true, color: theme),
                ),
              ),
              pw.Text(
                '${exp.startDate} - ${exp.endDate}',
                style: f.style(expFont, size),
              ),
            ],
          ),
          pw.Text(exp.position, style: f.style(expFont, size, italic: true)),
          if (has(exp.description))
            pw.Padding(
              padding: pw.EdgeInsets.only(top: 4 * PdfService._k),
              child: pw.Text(
                exp.description!,
                style: f.style(expFont, size, height: 1.4),
              ),
            ),
        ],
      ),
    );
  }

  pw.Widget _education(Education edu) {
    final size = data.educationFontSize;
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: 12 * PdfService._k),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Text(
                  edu.institution,
                  style: f.style(eduFont, size, bold: true, color: theme),
                ),
              ),
              pw.Text(
                '${edu.startDate} - ${edu.endDate}',
                style: f.style(eduFont, size),
              ),
            ],
          ),
          pw.Text(edu.degree, style: f.style(eduFont, size, italic: true)),
          if (has(edu.description))
            pw.Padding(
              padding: pw.EdgeInsets.only(top: 4 * PdfService._k),
              child: pw.Text(edu.description!, style: f.style(eduFont, size)),
            ),
        ],
      ),
    );
  }

  pw.Widget _certificate(Certificate cert) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: 8 * PdfService._k),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('• ', style: f.style(_serif, 12)),
          pw.Expanded(
            child: pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: '${cert.name}, ',
                    style: f.style(_serif, 12, bold: true),
                  ),
                  pw.TextSpan(
                    text: '${cert.issuer} (${cert.date})',
                    style: f.style(_serif, 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
