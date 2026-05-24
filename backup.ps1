$repoPath = "C:\Users\OfekPass\.claude"
Set-Location $repoPath

$status = git status --porcelain 2>$null
if ($status) {
    git add commands/ plugins/ settings.json settings.local.json projects/C--Users-OfekPass/memory/ 2>$null
    $staged = git diff --cached --name-only 2>$null
    if ($staged) {
        $date = Get-Date -Format "yyyy-MM-dd HH:mm"
        git commit -m "auto-backup $date" 2>$null
        git push 2>$null
    }
}
