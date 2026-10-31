# Offline CV — App Store Optimization (Google Play)

> **App:** Offline CV · `com.asimsafeer.offlineresume` · v1.0.5 (build 6) · developer "Nova byte" · [Play listing](https://play.google.com/store/apps/details?id=com.asimsafeer.offlineresume)
> **Scope:** Google Play (primary). Short iOS appendix at the end.
> **Data pulled:** 2026-10-31, US store unless noted.
> **Sources:** this repo's code · `mcp-appstore` (`search_app`, `get_app_details`, `get_pricing_details`, `get_keyword_scores`, `fetch_reviews`, `analyze_reviews`, `analyze_top_keywords`) · Tavily web search + page reads · Reddit (search snippets only; Reddit blocked full-page reads).
> **Not used:** `aso-mcp` failed to connect this session, so `discover_keywords`, `keyword_gap` and `suggest_keywords` data is missing. Re-run those when it's back. `get_app_details` failed for Offline CV itself (likely because it has no ratings yet), and `analyze_top_keywords` failed for Android.
> ⚠️ **Every traffic and difficulty number in this file is an ESTIMATE** from `mcp-appstore`'s 0–10 heuristic scores, not real search volume. Check real ranks in Play Console after each update.

---

## 0. App Reality Summary (from the code)

| | |
|---|---|
| **What it does** | Fill in a one-screen form → Live Preview → export an A4 PDF (save via the file picker on Android, share sheet on iOS). |
| **Sections in the form** | Name, title, photo, email, phone, address, summary, LinkedIn/GitHub/Instagram/Facebook/website, experience, education, skills, languages, certificates. |
| **Design options** | 2 real preview templates (Modern, Classic), accent color, 4 fonts (Inter, Roboto, Open Sans, Lato), per-section font size. |
| **Privacy** | The merged **release** manifest requests only `CAMERA`. **No `INTERNET` permission**, and no analytics, ads, account or backend. Checked in `build/app/intermediates/merged_manifests/release/`, so re-check after the next release build. |
| **Monetization** | Free. No ads, no IAP, no subscription. |
| **Locales** | English only. No l10n files. |
| **Platforms** | Android (live). iOS project exists, but the bundle ID is still `com.example.offlineResumeFlutter`. |
| **Target user** | Students, fresh graduates and first-time or low-income job seekers who need a quick resume on their phone, plus privacy-minded users. |
| **Hook** | Free PDF with no paywall, no account and no ads, and the app *cannot* send data anywhere. |

### Copy vs code: what the current listing gets wrong

Current listing: [play_console_descriptions.md](play_console_descriptions.md).

| # | Current claim / UI | What the code does | Fix in copy | Fix in code |
|---|---|---|---|---|
| 1 | "Choose from a **variety** of… templates" | Picker lists 5 templates. Minimal, Creative and Professional all fall back to Classic ([resume_preview.dart](lib/ui/resume_preview.dart)). | Copy A doesn't claim templates. Copy B says "Modern and Classic". | Hide the 3 unbuilt templates. |
| 2 | PDF = what you designed | [pdf_service.dart](lib/services/pdf_service.dart) uses **one fixed layout**. It ignores template, fonts and photo, and drops languages, certificates and social links. | Copy A lists only what the PDF contains. | Render the chosen template into the PDF. |
| 3 | "stored entirely locally" (implies saving) | State is **only in memory** ([resume_provider.dart](lib/providers/resume_provider.dart)), so the resume is lost when the app closes. | Copy A has an honest "Good to know" line. | Save to a local JSON file or shared_preferences. |
| 4 | "100% offline" | True: there is no INTERNET permission. But `google_fonts` tries to download fonts at runtime and silently falls back, so preview fonts may not be what the user picked. | — | Bundle the 4 fonts and set `GoogleFonts.config.allowRuntimeFetching = false`. |
| 5 | Privacy policy: "Contact Us: [Your Contact Email/Website]" | Placeholder still live. | — | Add a real support email (Play requires one, and it's needed for the review strategy in §5). |

**Two copy sets follow:** **A** ships today and is honest about gaps 1–3. **B** is for after fixes 1–3 land; each claim in B is tagged with the fix it depends on.

---

## 1. Keyword research

### 1a. Raw `mcp-appstore` scores — Google Play (0–10, estimates)

Higher traffic = more searches (estimate). Higher difficulty = harder to rank (estimate).

| Keyword | Country | Traffic | Difficulty | Tool read |
|---|---|---|---|---|
| cv maker | US | 9.23 | 7.04 | Very high traffic / difficult |
| cv maker | **IN** | 8.27 | **6.33** | High / moderately difficult |
| cv maker | GB | 8.77 | 7.11 | High / difficult |
| ats resume | US | 8.77 | **6.20** | High / moderately difficult |
| resume maker | US | 8.52 | 7.01 | High / difficult |
| cv builder | US | 8.41 | **6.45** | High / moderately difficult |
| cv maker pdf | US | 8.34 | 6.80 | High / moderately difficult |
| resume pdf | US | 8.21 | **6.42** | High / moderately difficult |
| resume builder | US | 7.95 | 8.05 | High / difficult |
| curriculum vitae | US | 7.70 | 7.40 | High / difficult |
| resume template | US | 6.91 | 7.28 | Moderate / difficult |
| simple resume | US | 6.75 | 6.71 | Moderate / moderately difficult |
| offline resume builder | US | 6.45 | 7.51 | Moderate / difficult |
| private resume | US | 6.43 | 6.97 | Moderate / moderately difficult |
| resume builder no sign up | US | 6.33 | 8.90 | Moderate / difficult |
| offline cv maker | US | 5.88 | 7.94 | Moderate / difficult |
| resume builder no ads | US | 5.77 | 7.08 | Moderate / difficult |
| free resume builder | US | 5.31 | 7.98 | Moderate / difficult |
| resume without internet | US | 5.18 | 8.88 | Moderate / difficult |

**iOS (`analyze_top_keywords`, "resume builder"):** the top 10 average 4.74★, 0% are paid, and the field is "High – diverse set of developers". Microsoft Word and Google Docs both rank on the term.

### 1b. Targeting table — Google Play

| Tier | Keyword | Traffic (est.) | Difficulty (est.) | Why target it |
|---|---|---|---|---|
| Primary | resume builder | 7.95 | 8.05 | The category's main term. Hard to win, but it must be in the title for relevance. |
| Primary | cv maker | 9.23 | 7.04 | Highest-traffic term. Easier in India (6.33), where "CV" is the everyday word. |
| Primary | resume pdf / cv maker pdf | 8.21 / 8.34 | 6.42 / 6.80 | Matches the app's core action (export a PDF). Among the easier high-traffic terms. |
| Secondary | cv builder | 8.41 | 6.45 | High traffic, moderate difficulty. Used in the FAQ and the UK/India pitch. |
| Secondary | resume maker | 8.52 | 7.01 | Synonym. Woven into the long description. |
| Secondary | ats resume | 8.77 | 6.20 | Easiest high-traffic term. Claim it carefully (see §7): the PDF is text-based and single-column. |
| Secondary | curriculum vitae | 7.70 | 7.40 | Formal/international searches. One natural mention. |
| Long-tail (wedge) | offline resume builder / offline cv maker | 6.45 / 5.88 | 7.51 / 7.94 | Matches the brand name exactly. "Offline" is in the title, so relevance is strong. |
| Long-tail (wedge) | resume builder no sign up / no ads | 6.33 / 5.77 | 8.90 / 7.08 | Matches the #1 and #6 complaints in competitor reviews (§3). |
| Long-tail (wedge) | free resume builder / free pdf | 5.31 | 7.98 | Real intent: Reddit threads ask for builders that are "actually free" (§3c). |
| Long-tail | private resume / simple resume | 6.43 / 6.75 | 6.97 / 6.71 | Privacy and simplicity positioning. |

### 1c. Read on the data
- **The easiest wins are terms about the action, not the app type:** `ats resume` (6.20), `resume pdf` (6.42), `cv builder` (6.45), `cv maker pdf` (6.80). All have high estimated traffic and the lowest difficulty in the set.
- **Country wedge:** `cv maker` is noticeably easier in India (6.33) than in the US (7.04) or UK (7.11). Using a "CV" title plus an en-IN custom listing (§8) points the app at the easier market.
- **Where the tool and real intent disagree:** the tool rates long-tails like "resume builder no sign up" (8.90) and "resume without internet" (8.88) as *harder* than head terms. That's because its difficulty score is driven by the install counts of whichever big apps rank for those words. Web research (§3c) shows these needs are real and repeated. Treat them as conversion and description terms, not as title-slot bets.
- **"Offline" alone is no longer unique.** [Resume Builder Pro with AI](https://play.google.com/store/apps/details?id=app.uncaughtexception.snapresume2) already says "no ads, no internet required, fully offline", and other Android apps (NanoCV, an "Offline CV Maker" listing) use the word too. The defensible wedge is the combination that is verifiable: **free PDF + no account + no ads + no internet permission.**
- **Missing:** `aso-mcp` keyword-gap and suggestion data. Re-run it against the 5 competitors in §3a before the next keyword iteration.

---

## 2. Paste-ready listing copy (Google Play)

Primaries appear in the long description: "resume builder" 3×, "CV maker" 3×, "resume maker" 2×, "CV builder" 1×, "PDF" 9–11×. The first two lines carry "free resume builder", "CV maker", "no internet", "no account", "no ads" and "PDF".

### Title (same for A and B)
```
Offline CV: Resume Builder PDF
```
= 30 chars ✅ (limit 30)

Alternative to test later: `Offline CV - Resume & CV Maker` (30 chars). It trades "PDF" for "CV maker".

### Copy set A — ships today

**Short description**
```
Free resume & CV maker. No ads, no sign-up, no internet. Free PDF export.
```
= 73 chars ✅ (limit 80)

**Long description**
```
Offline CV is a free resume builder and CV maker that works with no internet, no account and no ads. Type your details, see a live preview, and export your resume as a PDF for free. No paywall at the download step, no subscription, no "free trial" that charges you later.

WHY OFFLINE CV IS DIFFERENT
Many resume apps let you type everything in, then ask you to pay, sign up or watch ads before you can download your CV. Offline CV doesn't. The PDF export is free, every time.

YOUR DATA STAYS ON YOUR PHONE
• No sign-up, no login, no email needed
• No internet permission: the app cannot send your data anywhere
• No analytics, no tracking, no ads

WHAT YOU CAN ADD
• Name, job title, email, phone and address
• Professional summary
• Work experience and education
• Skills

FREE PDF RESUME EXPORT
• One tap creates a clean, single-column A4 PDF resume
• Real, selectable text (not a screenshot), so you can upload it to job sites or email it
• Pick an accent color for headings and skills
• Save the PDF to your phone or share it straight to email or messaging apps

The PDF includes your header, contact details, summary, experience, education and skills.

SIMPLE AND FAST
The resume maker walks you through each section in one screen. Switch to Live Preview at any time to see your CV take shape. It's built for students, fresh graduates, first-time job seekers and anyone who needs a quick, professional resume on their phone.

GOOD TO KNOW
Offline CV keeps your details in memory while the app is open. Export your PDF before you close the app; saved drafts are coming in a future update.

QUESTIONS
Is this resume builder really free? Yes. Building and exporting your PDF resume is free. There are no in-app purchases.
Do I need an account? No. Open the CV maker and start typing.
Is the PDF ATS-friendly? The PDF uses real text in a single column with standard section headings (Profile, Experience, Education, Skills), a layout that applicant tracking systems (ATS) read easily.
Resume or CV? Both. Use Offline CV as a resume maker for US jobs or a CV builder for UK, Europe, India, Pakistan, the Gulf and Africa.

Offline CV: a free, private, offline resume builder and CV maker with free PDF download.
```
= 2212 chars ✅ (limit 4000)

### Copy set B — after fixes ship

Each B claim depends on a fix:
- "saved on your device… edit it later" → **Fix 3** (saving)
- "What you see in Live Preview is what you get in the PDF", "in the template you chose", and photo/languages/certificates/links in the PDF → **Fix 2** (PDF matches preview)
- "Modern and Classic resume templates" → **Fix 1** (hide unbuilt templates)
- "choose your… font" → **Fix 4** (bundled fonts)

**Short description**
```
Free resume builder & CV maker. No ads, no account, no paywall. Free PDF.
```
= 73 chars ✅ (limit 80)

**Long description**
```
Offline CV is a free resume builder and CV maker that works with no internet, no account and no ads. Fill in your details, pick a template, and export your resume as a PDF for free. No paywall at the download step, no subscription, no "free trial" that charges you later.

WHY OFFLINE CV IS DIFFERENT
Many resume apps let you type everything in, then ask you to pay, sign up or watch ads before you can download your CV. Offline CV doesn't. The PDF export is free, every time.

YOUR DATA STAYS ON YOUR PHONE
• No sign-up, no login, no email needed
• No internet permission: the app cannot send your data anywhere
• Your resume is saved on your device, so you can come back and edit it later
• No analytics, no tracking, no ads

RESUME TEMPLATES
• Modern and Classic resume templates
• Choose your accent color, font and text size
• What you see in Live Preview is what you get in the PDF

WHAT YOU CAN ADD
• Name, job title, profile photo and contact details
• Professional summary
• Work experience and education
• Skills, languages and certificates
• LinkedIn, GitHub and website links

FREE PDF RESUME EXPORT
• One tap creates an A4 PDF resume in the template you chose
• Real, selectable text (not a screenshot), so you can upload it to job sites or email it
• Save the PDF to your phone or share it straight to email or messaging apps

SIMPLE AND FAST
The resume maker walks you through each section in one screen. Switch to Live Preview at any time to see your CV take shape. It's built for students, fresh graduates, first-time job seekers and anyone who needs a professional resume on their phone.

QUESTIONS
Is this resume builder really free? Yes. Building, saving and exporting your PDF resume is free. There are no in-app purchases.
Do I need an account? No. Open the CV maker and start typing.
Is the PDF ATS-friendly? The Classic template uses real text in a single column with standard section headings, a layout that applicant tracking systems (ATS) read easily.
Resume or CV? Both. Use Offline CV as a resume maker for US jobs or a CV builder for UK, Europe, India, Pakistan, the Gulf and Africa.

Offline CV: a free, private, offline resume builder and CV maker with free PDF download.
```
= 2203 chars ✅ (limit 4000)

---

## 3. Market & competitors

### 3a. Competitor set (Google Play, US)

| App | Rating | Ratings count | Category | Monetization (tool) | Notes |
|---|---|---|---|---|---|
| [Resume - Intelligent CV maker](https://play.google.com/store/apps/details?id=icv.resume.curriculumvitae) | 4.5 | 547,842 | Business | Free with ads | Market leader. Reviewers report a $1.99 trial → ~$28/mo charge. The tool shows no IAP; one reviewer says it comes from an in-app ad (unverified). |
| [Resume Builder - CV Engineer](https://play.google.com/store/apps/details?id=sampson.cvbuilder) | 4.6 | 104,012 | Business | Freemium, ads + IAP $1.99–$44.99 | Claims 6.1M downloads (self-reported). AI writing, ATS checker, 14 resume languages. |
| [Resume Builder Pro with AI](https://play.google.com/store/apps/details?id=app.uncaughtexception.snapresume2) | 4.6 | 11,452 | **Productivity** | Freemium, IAP $1.99–$49.99 | Already claims "no ads… fully offline". The direct positioning rival. |
| [Resume Builder: PDF Resume App (Resume.com / Indeed)](https://play.google.com/store/apps/details?id=com.resume.builder.resumecom) | 4.5 | 7,350 | Business | Free (per listing) | Recently added Google/Apple login. Reviews cite forced Indeed login. |
| [Resume Builder - CV Maker App (DuckResume)](https://play.google.com/store/apps/details?id=com.duckresume.cvmaker) | 4.7 | 6,280 | Business | Freemium, ads + IAP $3.99–$5.99 | Released Jul 2025. Cloud sync, AI cover letter. |

The iOS top 10 for "resume builder" includes [Resume Builder⁺](https://apps.apple.com/us/app/resume-builder/id1047522998), [Resume Builder Pro with AI](https://apps.apple.com/us/app/resume-builder-pro-with-ai/id1457411537), [Resume.com](https://apps.apple.com/us/app/resume-builder-pdf-resume-app/id1527659872), [Kickresume](https://apps.apple.com/us/app/kickresume-ai-resume-builder/id1523618695), [Resume Star](https://apps.apple.com/us/app/resume-star-cv-maker-builder/id730643547), Microsoft Word and Google Docs.

### 3b. What users hate: 1–3★ reviews

Sample: 266 deduplicated 1–3★ reviews from the 5 apps above (150 "helpful" + 150 "newest" per app, fetched via `mcp-appstore`). Counts are approximate hand-tags, and one review can count toward several themes.

| Rank | Complaint | ~Reviews | Offline CV's answer |
|---|---|---|---|
| 1 | **Surprise paywall at download** ("not really free") | ~55 | Free PDF export, always. |
| 2 | **Subscription traps** (can't cancel, paid but nothing delivered, purchase lost) | ~35 | No purchases at all. |
| 3 | **Can't export / PDF broken or rejected by job sites** | ~30 | Text-based PDF (not a screenshot). Must be reliable. |
| 4 | Crashes and freezes (mostly Resume.com) | ~32 | Quality claim. Track crash-free rate. |
| 5 | **Lost data / progress** | ~23 | ⚠️ **Offline CV is worse here today** (no saving). Fix 3 is the top priority. |
| 6 | **Forced login / account** | ~19 | No account, ever. |
| 7 | **Ads**, including ads you must watch before downloading | ~13 | No ads. |
| — | PDF formatting (font size, spacing) | ~20 | ⚠️ Today the PDF ignores font choices (Fix 2). |
| — | Privacy distrust | ~5 | No INTERNET permission. |

Watermarks were **not** a theme in these low reviews, so don't lead with "no watermark".

**Verbatim quotes:**
- Resume Builder Pro with AI, 1★, "A Google user", 2019-10-07: *"Its not really free , After letting you complete the whole information input process. And just before generating a PDF only than it tells you it will cost you 7.99$."* ([listing](https://play.google.com/store/apps/details?id=app.uncaughtexception.snapresume2))
- CV Engineer, 1★, Yeasin Ryan, 2024-09-30: *"I made a resume which took painfully long time and the moment I went to download, I'm getting pop-up to pay or the app won't let me download."* ([listing](https://play.google.com/store/apps/details?id=sampson.cvbuilder))
- Intelligent CV, 1★, Ike, 2026-09-16: *"terrible they don't give anyway to end subscription so they can keep charging you."* ([listing](https://play.google.com/store/apps/details?id=icv.resume.curriculumvitae))
- CV Engineer, 1★, M M, 2026-08-28: *"When you download your resumes, they are saved as a screenshot PDF that will not upload into any job application, even when they specify that PDFs are accepted."* ([listing](https://play.google.com/store/apps/details?id=sampson.cvbuilder))
- Resume.com, 1★, Brittany Earl, 2023-09-15: *"Was 80% done with my resume content when a text message came in on my phone, and somehow that wiped all of my entered data."* ([listing](https://play.google.com/store/apps/details?id=com.resume.builder.resumecom))
- Resume.com, 1★, Tatiana Pinto, 2024-12-03: *"Doesn't let me download unless i connect to indeed."* ([listing](https://play.google.com/store/apps/details?id=com.resume.builder.resumecom))
- CV Engineer, 1★, collins uche, 2026-10-27: *"your app is now too full of ads and one cannot even download the CV despite watching 5 ads"* ([listing](https://play.google.com/store/apps/details?id=sampson.cvbuilder))
- Intelligent CV, 1★, "A Google user", 2020-02-19: *"I should not have to exchange my money, or my personal information by creating an account and giving you my info to sell to 3rd parties."* ([listing](https://play.google.com/store/apps/details?id=icv.resume.curriculumvitae))

### 3c. Web search intent
- **How people phrase it** (Reddit titles, from search snippets): *"Actually free resume builders? Tired of getting paywalled"* ([r/ResumeTips](https://www.reddit.com/r/ResumeTips/comments/1wjjadc/actually_free_resume_builders_tired_of_getting)), *"Where can I build AND download my resume for free?"* ([r/jobs](https://www.reddit.com/r/jobs/comments/1li6mws/where_can_i_build_and_download_my_resume_for_free)), *"free resume builders that actually give you the file"* ([r/jobs](https://www.reddit.com/r/jobs/comments/1oa6jwq/are_there_any_free_resume_builders_that_actually)), *"no signup, no data stored, privacy first"* ([r/microsaas](https://www.reddit.com/r/microsaas/comments/1l4hxb1/built_a_free_resume_builder_no_signup_no_data)). Many of these threads are builders promoting their own tools, so they show phrasing, not neutral demand.
- **The paywall complaint is mainstream:** in April 2026 a competitor sued BOLD (Zety, LiveCareer, MyPerfectResume, Resume Genius…) over "free" builders that charge at download, and a consumer class action followed. Source: a competitor's blog, [resumevera.com](https://resumevera.com/blogs/why-free-resume-builders-charge-download). Case numbers were not checked against court records (`unverified`).
- **Privacy:** an audit quotes resume.io's policy as allowing resume data to be sold to data brokers ([toolbox-kit.com](https://www.toolbox-kit.com/blog/free-resume-builders-selling-your-career-data-privacy-audit)). These are second-hand quotes, `unverified` against current policies.
- **Seasonality (US):** Google Trends for "resume" peaks in **January (+13.2%) and February (+9.7%)**, with **September** third (+7.2%). December is the low point for downloads ([Enhancv](https://enhancv.com/blog/best-time-to-job-search-data)). A May graduation spike is `unverified`.
- **CV vs resume:** the US and Canada say "resume". The UK, Europe, India, Australia/NZ and the Gulf say "CV", and India, Africa and the Gulf often use both ([applyvita](https://www.applyvita.com/career-advice/cv-vs-resume-difference-by-country)). In South Asia "biodata" also means CV, but it's often for marriage profiles ([Wikipedia](https://en.wikipedia.org/wiki/Biodata)), which is a weaker fit.

---

## 4. Category

| | Recommendation | Why |
|---|---|---|
| **Primary: Business** | ✅ | 4 of 5 competitors (including the leader with 547k ratings) sit in Business, so that's where users browse for resume apps. It also lends credibility. |
| Alternative: Productivity | Test only if Business ranks poorly | Resume Builder Pro with AI uses it. It's a smaller resume field, but less relevant to someone browsing for a CV. |

Play allows one category. Check what is currently set in Play Console (`unverified`: the details call failed for this app). Tags: pick "Resume", "Job search" or similar if offered.

---

## 5. Creative & conversion

### Icon
- Competitors' icons are mostly blue/teal documents with a pen or person. Stand out with a **document + "offline" mark** (a crossed-out wifi symbol or a shield) in a contrasting color, keeping the app's blue `#3B82F6` as an accent only.
- At 48px, use just one shape: a document with a bold check or shield. No text.
- A/B (Play Console store listing experiment): (a) document + shield, (b) document + crossed wifi, (c) current icon.

### Screenshots (first 3 do the converting)

| # | Caption | Answers complaint | Set |
|---|---|---|---|
| 1 | **Free PDF resume. No paywall at the end.** | #1 surprise paywall | A + B |
| 2 | **No account. No login. Just start typing.** | #6 forced login | A + B |
| 3 | **No internet permission — your CV stays on your phone** | privacy | A + B |
| 4 | **No ads. Not one.** | #7 ads | A + B |
| 5 | **Real-text PDF that uploads to job sites** | #3 broken PDF | A + B |
| 6 | **Live preview as you type** | ease | A + B |
| 7 | **Saved on your phone — pick up where you left off** | #5 lost data | **B only** |
| 8 | **Modern & Classic templates, your colors and fonts** | templates | **B only** |

For set A, screenshots 1 and 5 must show the **exported PDF**, not the preview, because today they look different.

### Promo video (20s)
- 0–3s: "Built your resume… then asked to pay?" with a paywall pop-up crossed out.
- 3–8s: open the app, no login screen, start typing.
- 8–14s: Live Preview fills in.
- 14–18s: tap Download PDF → the PDF opens in the file picker/email.
- 18–20s: "Free. Private. Offline." + logo.

---

## 6. Ratings & reviews

Offline CV has **no ratings** today, which hurts conversion.

1. **Ask at the right moment:** add the `in_app_review` package and call it right after a **successful PDF save** (first or second export). Never ask on launch or after an error. This needs no internet permission; the Play Store app handles it.
2. **Catch unhappy users first:** before the system prompt, show "Did Offline CV help you?" **Yes** → review API. **No** → open a `mailto:` feedback email. This needs a real support email (Fix 5).
3. **First 2 weeks after the update:** ask friends, classmates and job-seeker groups to install, make a real CV and review honestly. No incentives (that's against Play policy).
4. **Reply to every 1–3★** within 48h. Point to the fix or update that addresses it, especially "my resume disappeared" until Fix 3 ships.
5. Competitors are weak on billing support and cancellations (theme #2). "Free, nothing to cancel" is the reply template for comparison reviews.

---

## 7. Launch & ranking plan

1. **Now (copy set A):** update the short and long description and fix the privacy policy email. Don't spend on ads yet; with no ratings and no saving, paid installs will turn into 1★ reviews.
2. **Ship Fixes 1–3**, then switch the listing to **copy set B** and add screenshots 7–8.
3. **Custom store listings:** create en-GB and en-IN listings that lead with "CV maker / CV builder" (§8).
4. **Paid test (after ~20 ratings):** a Google Ads App campaign (you give themes, not exact keywords). Seed it with the easier terms: `cv maker pdf`, `resume pdf`, `cv builder`, `ats resume`. Time the budget for **January–February** and **September** peaks.
5. **Monthly:** re-pull `get_keyword_scores` for §1b terms (and `aso-mcp` once it's back). Move a long-tail into the title or short description if Play Console shows it bringing installs, and drop terms with no impressions.
6. **Store listing experiments:** icon (3 variants) → short description (A vs. "no paywall"-led line) → screenshot 1 caption.

**KPIs:** store listing conversion rate (Play Console), installs by search term, ranks for the §1b primaries, D1/D7/D30 retention (Play Console), crash-free rate ≥ 99.5%, ANR rate, average rating ≥ 4.5 and rating count.

---

## 8. Compliance & data safety

**Google Play Data safety form** (matches the code):
- Data collected: **None.** Name, contact, work history and photo are entered and processed only on the device and never leave it. There is no INTERNET permission, and on-device processing doesn't count as "collection" under Play's definitions.
- Data shared: **None.**
- Encrypted in transit: N/A (no transmission).
- Deletion: the data isn't stored after the app closes (today). After Fix 3: "Uninstall or clear app data". Add a "Delete my resume" button.
- Permissions: CAMERA (only when the user taps "take photo"). Photo picker for gallery. No storage permission is requested.

**Privacy policy fixes:**
- Replace `[Your Contact Email/Website]` with a real address.
- Section 3 mentions a storage permission the app no longer requests.
- Section 2 says data is "stored locally". Today it isn't stored at all. Reword until Fix 3 ships.

**Claims to avoid:**
- No "ATS-approved", "guaranteed interviews" or "get hired faster". The ATS line in the FAQ only describes the layout (text-based, single column, standard headings). Before calling the PDF ATS-friendly, test the exported PDF with a free ATS parser and with a job site upload.
- **Trademarks:** don't put LinkedIn, Indeed, Canva, Zety or other brand names in the title or short description. "LinkedIn, GitHub and website links" in copy B is descriptive use and is fine.
- **Pricing honesty:** "free" is accurate today. If you ever add paid features, say so in the first line of the description, never only at the export step. That is exactly what competitors get 1★ reviews for.

---

## 9. Localization

| Order | Locale | Why | Needs app work? |
|---|---|---|---|
| 1 | **en-IN** custom listing | "CV" wording. `cv maker` is easier there (6.33 vs 7.04 US). | No |
| 2 | **en-GB** custom listing | "CV" is the native word. | No |
| 3 | es (es-419 / es-ES), pt-BR | Large job-seeker markets. CV Engineer already supports these resume languages. | Translate UI first. The PDF's default font handles Latin accents. |
| 4 | id, fr, de, tr | Same reasoning (CV Engineer covers these too). | Translate UI first. |
| 5 | ar, ur, hi | Big "CV" markets (Gulf, Pakistan, India). | **Yes**: the PDF uses the `pdf` package's default font, which can't render Arabic/Urdu/Devanagari, plus RTL layout. |

Don't translate the store listing into a language the app UI doesn't support. Users install, find English and leave a 1★.

---

## Appendix A — Prioritized fix list

| Priority | Fix | Why it matters for ASO |
|---|---|---|
| P0 | **3. Save the resume locally** | Lost data is complaint #5, and Offline CV currently has the problem. It unlocks copy B. |
| P0 | **2. PDF matches the preview** (template, fonts, photo, languages, certificates, links) | PDF quality is complaint #3. "What you see is what you get" is a strong screenshot line. |
| P1 | **1. Hide Minimal / Creative / Professional** until built | The picker shows options that don't do anything. |
| P1 | **4. Bundle the 4 fonts**, `allowRuntimeFetching = false` | Preview fonts actually match the user's choice. |
| P1 | **5. Real support email** in the privacy policy and listing | Play requirement, and needed for review interception. |
| P2 | `in_app_review` + feedback prompt | Ratings flywheel (§6). |
| P2 | PDF font with non-Latin script support | Unlocks ar/ur/hi (§9). |
| P2 | Android `namespace` is still `com.example.offline_resume_flutter` | Cosmetic. The applicationId is correct. |

## Appendix B — iOS (if you launch there later)

- Set a real bundle ID first (e.g. `com.asimsafeer.offlineresume`). It's currently `com.example.offlineResumeFlutter`, which App Store Connect won't accept for your team.
- Apple indexes the name, subtitle and keyword field together, so no word is repeated across them:

**App Name**
```
Offline CV: Resume Builder
```
= 26 chars ✅ (limit 30)

**Subtitle**
```
Private CV Maker, Free PDF
```
= 26 chars ✅ (limit 30)

**Keyword field** (no spaces, no words from the name or subtitle)
```
template,curriculum,vitae,job,ats,simple,secure,ads,signup,student,fresher,format,biodata,career
```
= 96 chars ✅ (limit 100)

**Promotional text**
```
Build your resume with no account, no ads and no internet. Your details stay on your iPhone. Export a free PDF in one tap, no paywall at the end.
```
= 145 chars ✅ (limit 170)

- Privacy nutrition label: "Data Not Collected". Note that the iOS Runner may use network for Google Fonts unless Fix 4 is done, so do Fix 4 before claiming "no internet" on iOS.
- The iOS promo text says "your details stay on your iPhone". That's true for privacy, but until Fix 3 nothing is saved. Use copy-B wording only after the fixes.

---

*Sources: repo code (2026-10-31), `mcp-appstore` store data and keyword scores, Tavily web search, Reddit search snippets. `aso-mcp` was unavailable. All traffic and difficulty figures are directional **estimates**, not search volumes. Confirm with Play Console acquisition reports after each listing change.*
