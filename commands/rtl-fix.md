# RTL Fix for Claude Code VS Code Extension

## רקע טכני (לשימוש פנימי - לא להציג למשתמש אלא אם שואל)

תוסף ה-RTL עובד על ידי הזרקת קוד JavaScript לסוף הקובץ `webview/index.js` של תוסף Claude Code.
הבעיה: כשקלוד קוד מתעדכן לגרסה חדשה, הקובץ מוחלף בנקי - וההזרקה נעלמת.
בנוסף, ה-CSS class names של Claude Code הם minified ומשתנים בין גרסאות - לכן צריך לסרוק ולעדכן אותם.

## איך לנהל את השיחה
שפה: עברית תמיד.

### עיקרון מרכזי: אבחן → תקן → דווח
כשהמשתמש מבקש "תקן RTL" - פשוט תתקן. לא לשאול אישור להתקנה עצמה.

### שלב 1: אבחון (שקט, אוטומטי)
1. בדוק אילו גרסאות Claude Code קיימות ב-`~/.vscode/extensions/anthropic.claude-code-*/`
2. בדוק באילו מהן RTL כבר מותקן (חפש הזרקה ב-`webview/index.js`)
3. המשך ישירות לביצוע

### שלב 2: סריקת תאימות סלקטורים (חובה!)
חובה בכל הרצה — סרוק את ה-class names הנוכחיים של Claude Code ב-CSS.
חלץ: message, userMessageContainer, timelineMessage, userMessage ועוד.
השווה עם הסקריפט הקיים. עדכן אם השתנו.

### שלב 3: ביצוע (אוטומטי)
הזרק את קוד ה-RTL לקובץ `webview/index.js` של כל גרסה פעילה.
גבה לפני שינוי.

### שלב 4: דיווח (תמיד בסוף)
מה נמצא, מה תוקן, שינויי סלקטורים, הצורך ב-Reload Window ב-VS Code.

## קוד RTL להזרקה

```javascript
// RTL Fix for Claude Code VS Code Extension
(function() {
  'use strict';

  const RTL_STYLE = `
    [class*="message"], [class*="userMessage"], [class*="assistantMessage"],
    [class*="timelineMessage"], [class*="content"] {
      direction: rtl !important;
      text-align: right !important;
      unicode-bidi: plaintext !important;
    }

    [class*="userMessage"] {
      direction: rtl !important;
    }

    code, pre, [class*="code"] {
      direction: ltr !important;
      text-align: left !important;
    }
  `;

  function injectRTL() {
    if (document.getElementById('rtl-fix-style')) return;
    const style = document.createElement('style');
    style.id = 'rtl-fix-style';
    style.textContent = RTL_STYLE;
    document.head.appendChild(style);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', injectRTL);
  } else {
    injectRTL();
  }

  const observer = new MutationObserver(injectRTL);
  observer.observe(document.documentElement, { childList: true, subtree: true });
})();
```

## הערה חשובה
לאחר הזרקה — הנחה את המשתמש לבצע Reload Window ב-VS Code:
`Ctrl+Shift+P` → "Developer: Reload Window"
