---
name: ""
description: "אפליקציית תזכורות וואטסאפ + יומן גוגל — כל פרטי הפרויקט, credentials, URLs, תיקונים ופיתוחים שהושלמו"
metadata: 
  node_type: memory
  type: project
  originSessionId: 7b6fd389-a0e4-460d-87a8-43e00b7671ba
---

אפליקציית Node.js עם ממשק עברי (RTL) לניהול תזכורות וואטסאפ ואירועים בגוגל קלנדר.

**Why:** בנוי לפי מסמך אפיון של המשתמש.
**How to apply:** כשהמשתמש מזכיר את הסוכן האישי / ai-agent / תזכורות וואטסאפ — זה הפרויקט.

## מיקום קוד
`C:\Users\OfekPass\Ofek-GitHub\ai-personal-agent\`
(הועבר מ-ai-agent-demo ב-24/5/2026)

## URLs
- **פרודקשן (Railway):** https://ai-personal-agent-production.up.railway.app
- **לוקאלי:** http://localhost:3000

## הפעלה מקומית
לחיצה כפולה על `C:\Users\OfekPass\Ofek-GitHub\ai-personal-agent\הפעל-סוכן.bat`

## עדכון פרודקשן
```
cd C:\Users\OfekPass\Ofek-GitHub\ai-personal-agent
git add .
git commit -m "תיאור"
git push
```
Railway מעדכן אוטומטית.

## טכנולוגיות
- Node.js (פורטבילי: `C:\Users\OfekPass\tools\node-v20.19.1-win-x64\`)
- Express, googleapis, node-schedule
- פריסה: Railway (GitHub repo: https://github.com/ofek7pass-arch/ai-personal-agent)
- **Dockerfile** קיים בריפו — חובה, עוקף בעיית Railpack build secrets

## WhatsApp — Green API ✅ עובד
- **שירות:** Green API (green-api.com) — Developer plan (חינמי, ללא session expiry)
- **Instance ID:** 7107617295
- **API URL:** https://7107.api.greenapi.com
- **chatId שלח לעצמי (קבוצה):** `972507226589-1549032200@g.us`
- **איך עובד:** השרת שולח הודעה מחשבון הוואטסאפ של המשתמש לעצמו → מגיע ל-Saved Messages
- **חשוב:** אם הסטטוס ב-Green API הופך "לא מחובר" — יש לסרוק QR מחדש
- **פורמט טלפון ישראלי:** `05XXXXXXXX` → `972XXXXXXXXX@c.us` (מסיר 0 מקדימה, מוסיף 972)

## Railway Variables (env vars בפרודקשן)
⚠️ שמות משתנים חייבים להיות ניטרליים — Railway חוסם משתנים עם TOKEN/INSTANCE/KEY בשם בזמן build
- `GR_ID` = 7107617295 (instance id)
- `GR_CODE` = (הטוקן של Green API — סודי)
- `GR_HOST` = https://7107.api.greenapi.com
- `WA_NUM` = 972507226589
- `WA_CHAT_ID` = 972507226589-1549032200@g.us (chatId קבוצת "לעצמי")
- `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`, `REDIRECT_URI`, `GOOGLE_TOKENS`

## Google OAuth
- Google Client ID: 96893237301-k3cg4sual4rbivu5mes5sf4d5n99o34g.apps.googleusercontent.com
- Google OAuth Redirect (prod): https://ai-personal-agent-production.up.railway.app/auth/google/callback
- Google Calendar: מחובר לחשבון ofek7pass@gmail.com
- **חשוב:** אפליקציית OAuth פורסמה ל-Production (לא Testing) — אין תפוגת 7 ימים לטוקן

## Railway Volume
- מחובר ל-`/app/data` — שומר reminders.json, google-tokens.json, contacts.json בין deploys
- חיוני לשרידות תזכורות ממתינות אחרי restart/redeploy

## מבנה קבצים
- `server.js` — backend (Express + Green API + Google Calendar API)
- `public/index.html` — frontend (RTL עברית, 3 טאבים: תזכורות / אירועים / אנשי קשר)
- `Dockerfile` — build מפורש (חובה לפריסה ב-Railway)
- `nixpacks.toml` — קיים אך לא פעיל (Dockerfile גובר)
- `data/reminders.json` — תזכורות ממתינות (נשמר ב-Volume)
- `data/google-tokens.json` — טוקני OAuth (נשמר ב-Volume)
- `data/contacts.json` — אנשי קשר (נשמר ב-Volume)

## פיתוחים שהושלמו (מאי 2026)

### תיקונים בסיסיים
1. **Timezone bug** — תוקן עם `toIsraelDate()` — offset מפורש +03:00/+02:00
2. **ביטול תזכורת** — כפתור ✕ + DELETE /api/reminder/:id
3. **Railway ephemeral storage** — נפתר עם Railway Volume ב-/app/data
4. **Twilio → Green API** — הוחלף בגלל session expiry של 24 שעות
5. **Railpack build secrets bug** — נפתר עם Dockerfile + שמות ניטרליים למשתנים

### פיתוחי טאב אירועים
6. **אנשי קשר (CRUD)** — טאב שלישי: הוסף/ערוך/מחק (שם, טלפון, אימייל), נשמר ב-contacts.json
7. **Attendees dropdown** — בטאב אירועים: dropdown מותאם אישית לבחירת אנשי קשר + כפתור "הוסף חדש" שמקשר לטאב אנשי קשר
8. **Overflow bug תוקן** — `.app { overflow: hidden }` חתך את הdropdown; הוסרה + נוסף border-radius ל-.app-header
9. **invalid_grant handling** — HTTP 400 (לא 401!) — זוהה ע"י `err.response?.data?.error === 'invalid_grant'`; מנקה טוקנים ומציג banner צהוב לחיבור מחדש
10. **Proactive token validation** — validateGoogleToken() בסטארטאפ
11. **Google app → Production** — פורסם מ-Testing לProduction למניעת תפוגת טוקן כל 7 ימים

### פיתוחי וואטסאפ
12. **שלח למי?** — תזכורות ניתן לשלוח לאנשי קשר (לא רק לעצמי); שדה "שלח למי?" בטאב תזכורות עם dropdown של אנשי קשר
13. **`sendWhatsApp(chatId, message)`** — chatId כפרמטר ראשון (לא hardcoded); `scheduleReminder` משתמש ב-`reminder.targetChatId || WHATSAPP_CHAT_ID`
14. **פורמט הודעה — plain text** — הוסרו אמוג'י/כוכביות מהודעות וואטסאפ

### שיפורי UX
15. **Parser עברי משופר** — `parseEvent()` מזהה: "יום לפני", "שבועיים לפני", "שעתיים לפני", "חצי שעה לפני", "רבע שעה לפני", מספרים בעברית (שני ימים, שלושה ימים...)
16. **בורר שעה HH:MM** — הוחלף מ-3 עמודות גלילה לשתי קוביות HH:MM (פורמט 24 שעות), קופץ אוטומטית מ-HH ל-MM, ולידציה, ללא AM/PM

## לוגיקת זמן (24 שעות)
- הקלדה ישירה: 00–23 לשעות, 00–59 לדקות
- `02:40` = AM (לילה/בוקר), `14:40` = PM — המערכת מבינה לבד
- ampm הוסר לחלוטין מ-client ומ-server

## פיתוחים עתידיים (טרם מומשו)

### 1. שיפור בולטות התראות וואטסאפ
- הבעיה: ההודעות מגיעות ל-Saved Messages ולא בולטות
- לבחון: שליחה לקבוצה עם עצמו, פורמט בולט יותר
- רמת מורכבות: נמוכה-בינונית

### 2. שיפור parser מלל חופשי
- לשפר: regex patterns, תמיכה בביטויים מורכבים ומשולבים בעברית
- רמת מורכבות: בינונית

### 3. טאב ניהול משימות
- כותרת, דדליין, סטטוס (לא התחיל / בתהליך / בוצע)
- התראות אוטומטיות: 3 ימים / 2 ימים / יום לפני / אותו יום 09:00 → מייל + וואטסאפ
- נשמר ב-tasks.json (ב-Railway Volume)
- רמת מורכבות: גבוהה (דורש שליחת מייל + לוגיקת תזמון מרובה)
