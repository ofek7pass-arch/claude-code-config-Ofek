# RTL Fix for Claude Code VS Code Extension

שפה: עברית תמיד.

## מה לעשות — זה כל התהליך

הרץ את הסקריפט. אל תגזור CSS מחדש, אל תסרוק class names, אל תזריק JavaScript.

```powershell
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.claude\scripts\rtl-fix.ps1"
```

אמת ש-`applied=True` ושהסוגריים מאוזנים בפלט, ואז דווח למשתמש להריץ:
`Ctrl+Shift+P` → **Developer: Reload Window**

ביטול: אותה פקודה עם `-Revert`.

הסקריפט אידמפוטנטי (בלוק מסומן `/* == RTL-FIX START == */`), מגבה פעם אחת ל-`index.css.rtl-backup`, מטפל בכל הגרסאות המותקנות תחת `~/.vscode/extensions/anthropic.claude-code-*`, ומדפיס `applied / blocks / braces / size`.

תיעוד מלא: `~/.claude/scripts/RTL-FIX-README.md`

## אחרי עדכון גרסה של Claude Code

העדכון מביא `index.css` נקי וההוספה נעלמת. הפתרון הוא להריץ את הסקריפט שוב — **בלי** סריקת סלקטורים. הסלקטורים חסינים ל-hash ולכן שורדים עדכונים.

---

## המלכודות — אל תחזור עליהן

התיעוד נכתב אחרי שיחה שבזבזה שעה על ניחושים, שלושה סבבי CSS שגוי ודיווחי הצלחה בלי אימות.

### 1. התיבה בנויה משתי שכבות — זה היה השורש
`.messageInput_*` הוא contenteditable **שקוף**: `color:#0000`, רק `caret-color` נראה.
הטקסט שהמשתמש רואה מרונדר ב-`.mentionMirror_*` — `position:absolute; inset:0; pointer-events:none; color: var(--app-input-foreground)`.
`direction: rtl` על `messageInput_` לבד מזיז את הקורסור ולא פיקסל מהטקסט הנראה. חייבים את **שתי** השכבות יחד.

### 2. `text-align: start` הוא שמאל
בבלוק שכיוונו `ltr`, `start` מתרגם לשמאל. `unicode-bidi: plaintext` מסדר אותיות בתוך השורה אבל **לא מיישר** — יישור נקבע ברמת הבלוק. אין יישור-לימין בלי `direction: rtl`. גישת "plaintext בלי direction" לא יכולה לעבוד.

### 3. `direction: rtl` על מכל flex הופך את הפריסה
כפתורים, אייקון המיקרופון וה-toolbar עוברים לצד ההפוך. להחיל `direction` רק על תגיות טקסט (`p`, `li`, כותרות, `blockquote`, `td`, `th`) ועל שכבות התיבה — לעולם לא על ה-div-ים שמחזיקים אותן.

### 4. סלקטורים רחבים תופסים את Monaco
`[class*="message"]` ו-`[class*="content"]` תופסים גם `monaco-hover-content`, `lines-content`, `sticky-line-content`, `quick-input-message`. יש 1479 class-ים ב-`index.css`. תמיד לכלול את הקו התחתון: `[class^="messagesContainer_"]`.

### 5. `[class^=]` לבד מפספס אלמנטים מרובי-class
`[class^="x_"]` תופס רק כשזה ה-class הראשון. צריך גם `[class*=" x_"]` עם רווח. הסקריפט מייצר את שני הווריאנטים אוטומטית, וזו הסיבה שאין צורך לסרוק hash-ים.

### 6. PowerShell לא רגיש לרישיות
אל תקרא למשתנה התוכן `$CSS` כשיש בלולאה `$css` עם נתיב הקובץ — השני דורס את הראשון בשקט והקובץ מקבל את הנתיב במקום את ה-CSS. באג אמיתי שקרה כאן. בסקריפט המשתנה נקרא `$RtlBlock`.

### 7. `Select-String` משקר על קבצים מינופיים
`index.js` הוא שורה אחת של ~5MB, ו-`Select-String` החזיר 0 התאמות למרות שהטקסט קיים. לאימות תמיד `[System.IO.File]::ReadAllText($f).Contains('...')`.

---

## ארכיטקטורה: CSS ולא JS

הגישה הישנה של הסקיל הזה הזריקה JavaScript לסוף `webview/index.js`. **הוחלפה.**

אומת ב-`extension.js` ש-`getHtmlForWebview` בונה את ה-HTML של פאנל הצ'אט כך:

```
Uri.joinPath(extensionUri,"webview","index.js")   -> <script nonce=...>
Uri.joinPath(extensionUri,"webview","index.css")  -> <link rel="stylesheet">
```

CSP: `default-src 'none'; style-src <cspSource> 'unsafe-inline'; script-src 'nonce-...'; worker-src ...`

`index.css` נטען ישירות כ-stylesheet, ולכן הוספה אליו לא תלויה בהרצת JS, ב-nonce, ב-CSP או בסדר טעינה.

## מה לא לעשות

- לא לשאול אישור להתקנה עצמה — לתקן.
- לא להסתמך על `[class*="message"]` או `[class*="content"]`.
- לא להזריק JS.
- לא לדווח הצלחה בלי `applied=True` ואיזון סוגריים מפלט הסקריפט. אימות סטטי אינו אישור ויזואלי — לומר את זה במפורש.
- אם אחרי Reload זה לא עובד: לבקש `Developer: Open Webview Developer Tools` → Elements עם שורת טקסט עברית מסומנת, במקום סבב ניחושים נוסף.
