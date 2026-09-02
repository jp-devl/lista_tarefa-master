$projectPath = Split-Path -Parent $PSScriptRoot
$gitPath = 'C:\Program Files\Git\cmd\git.exe'
$debounceSeconds = 3

Set-Location $projectPath

function Sync-Repository {
    $status = & $gitPath status --porcelain
    if (-not $status) {
        return
    }

    & $gitPath add --all
    $message = "chore: auto-sync $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    & $gitPath commit -m $message
    & $gitPath push origin main
}

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $projectPath
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

$action = {
    $changedPath = $Event.SourceEventArgs.FullPath
    if ($changedPath -match '\\.git([\\/]|$)|[\\/]build([\\/]|$)|[\\/]\.dart_tool([\\/]|$)') {
        return
    }

    Start-Sleep -Seconds $debounceSeconds
    Sync-Repository
}

$createdSubscription = Register-ObjectEvent $watcher Created -Action $action
$changedSubscription = Register-ObjectEvent $watcher Changed -Action $action
$deletedSubscription = Register-ObjectEvent $watcher Deleted -Action $action
$renamedSubscription = Register-ObjectEvent $watcher Renamed -Action $action

Write-Host "Sincronizacao automatica ativa em $projectPath"
Write-Host 'Pressione Ctrl+C para encerrar.'

try {
    while ($true) {
        Wait-Event -Timeout 5 | Out-Null
    }
}
finally {
    Unregister-Event -SubscriptionId $createdSubscription.Id -ErrorAction SilentlyContinue
    Unregister-Event -SubscriptionId $changedSubscription.Id -ErrorAction SilentlyContinue
    Unregister-Event -SubscriptionId $deletedSubscription.Id -ErrorAction SilentlyContinue
    Unregister-Event -SubscriptionId $renamedSubscription.Id -ErrorAction SilentlyContinue
    $watcher.Dispose()
}