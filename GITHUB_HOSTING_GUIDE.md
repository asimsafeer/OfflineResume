# Hosting your Privacy Policy on GitHub

Google Play Console requires a public URL for your Privacy Policy. Hosting it on GitHub is a free and professional way to do this.

## Option 1: Using GitHub Pages (Recommended)
This creates a clean, professional-looking webpage (`https://yourusername.github.io/your-repository/PRIVACY_POLICY`).

1.  **Push your code to GitHub**:
    If you haven't already, push your `PRIVACY_POLICY.md` to your repository:
    ```bash
    git add PRIVACY_POLICY.md
    git commit -m "Add privacy policy"
    git push origin main
    ```

2.  **Enable GitHub Pages**:
    *   Go to your repository on GitHub.com.
    *   Click on **Settings** (top tab).
    *   On the left sidebar, click **Pages**.
    *   Under **Build and deployment > Branch**, select `main` (or your primary branch) and folder `/ (root)`.
    *   Click **Save**.

3.  **Get your URL**:
    *   After a minute, GitHub will provide a link like: `https://asimsafeer.github.io/OfflineResume/`.
    *   Your Privacy Policy will be at: `https://asimsafeer.github.io/OfflineResume/PRIVACY_POLICY` (GitHub automatically renders the `.md` file).

---

## Option 2: Using the Raw Link (Quickest)
If you don't want to set up Pages, you can use the direct link to the file.

1.  Go to your repository on GitHub.
2.  Click on the `PRIVACY_POLICY.md` file.
3.  Copy the URL from your browser's address bar. It will look like: 
    `https://github.com/asimsafeer/OfflineResume/blob/main/PRIVACY_POLICY.md`

---

## Next Steps in Play Console
1.  Copy the URL from either Option 1 or Option 2.
2.  Go to the **Google Play Console**.
3.  Select your app.
4.  Navigate to **Policy and programs > App content**.
5.  Find the **Privacy policy** section and click **Start** or **Manage**.
6.  Paste your URL and click **Save**.
