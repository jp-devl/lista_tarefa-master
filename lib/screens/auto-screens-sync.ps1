$projectPath = "C:\repos\lista_tarefa_master\lib\screens"$gitPath = 'C:\Program Files\Git\cmd\git.exe'
$debounceSeconds = 3

Set-Location $projectPath

function Sync-Repository {
    $status = & $gitPath status --porcelain
    if (-not $status) {
        Write-Host "Nenhuma alteracao para enviar ao GitHub."
        return
    }

    & $gitPath add --all
    $message = "chore: auto-sync $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    & $gitPath commit -m $message

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Commit nao realizado."
        return
    }

    Write-Host "Arquivo comitado em $(Get-Date -Format 'HH:mm:ss')"
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

Register-ObjectEvent $watcher Created -Action $action | Out-Null
Register-ObjectEvent $watcher Changed -Action $action | Out-Null
Register-ObjectEvent $watcher Deleted -Action $action | Out-Null
Register-ObjectEvent $watcher Renamed -Action $action | Out-Null

Write-Host "Sincronizacao ativa em $projectPath"
Write-Host "Pressione Ctrl+C para parar."

while ($true) {
    Start-Sleep -Seconds 5
}