# n8n Workflow JSON Generator

## מטרה
יצירת JSON תקני ל-n8n מוכן להדבקה ישירה.

## מבנה חובה
כל JSON חייב לכלול 4 חלקים: `meta`, `nodes`, `connections`, `pinData`.

## כללים קריטיים

### עטיפת פריטים יחידים
גם node יחיד צריך עטיפה מלאה:
```json
{ "nodes": [...], "connections": {} }
```

### שדות חובה בכל node
- `id` — UUID ייחודי
- `name` — שם ייחודי
- `type` — מזהה סוג
- `typeVersion`
- `position` — מערך [x, y]
- `parameters` — פרמטרים ספציפיים

### סינטקס ביטויים
- טקסט רגיל: `"value"`
- ביטוי: `={{ $json.fieldName }}`
- תבנית: `={{ \`https://api.example.com/${$json.id}\` }}`

### HTTP Request Body
`jsonBody` חייב להיות string של Expression:
```
"={{ { groupId: $json.groupId, active: true } }}"
```

### פורמט חיבורים
```json
"Node Name": { "main": [[{ "node": "Next Node", "type": "main", "index": 0 }]] }
```

## פלט
תמיד הצג את ה-JSON ישירות בצ'אט כ-code block, אלא אם ביקשו אחרת.
