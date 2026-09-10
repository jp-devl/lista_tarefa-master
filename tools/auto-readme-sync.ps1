$projectPath = Split-Path -Parent $PSScriptRoot
$gitPath = 'C:\Program Files\Git\cmd\git.exe'
$readmePath = Join-Path $projectPath 'README.md'

Set-Location $projectPath

$features = @(
    '- Adicionar tarefas pelo botão ou pressionando Enter',
    '- Marcar tarefas como concluídas',
    '- Filtrar entre Todas, Ativas e Concluídas',
    '- Remover tarefas individualmente',
    '- Exibir mensagem quando a lista estiver vazia'
)

$generatedSection = @"
## Funcionalidades atuais
<!-- AUTO-README:START -->
$($features -join "`n")
<!-- AUTO-README:END -->
"@

if (-not (Test-Path $readmePath)) {
    throw "Arquivo README.md nao encontrado em $readmePath"
}

$content = Get-Content -Path $readmePath -Raw

if ($content -match '(?s)<!-- AUTO-README:START -->.*?<!-- AUTO-README:END -->') {
    $content = [regex]::Replace($content, '(?s)<!-- AUTO-README:START -->.*?<!-- AUTO-README:END -->', $generatedSection.Trim())
} else {
    $hook = '## Funcionalidades'
    if ($content -match [regex]::Escape($hook)) {
        $content = $content -replace [regex]::Escape($hook), $generatedSection.Trim() + "`n`n$hook"
    } else {
        $content = $content + "`n`n$generatedSection"
    }
}

Set-Content -Path $readmePath -Value $content -Encoding utf8

Write-Host "README atualizado com as funcionalidades atuais."

$status = & $gitPath status --porcelain
if (-not $status) {
    Write-Host "Nenhuma alteracao para enviar ao GitHub."
    return
}

& $gitPath add README.md
$commitMessage = "docs: atualizar README automaticamente"
& $gitPath commit -m $commitMessage

if ($LASTEXITCODE -ne 0) {
    Write-Host "Commit nao realizado. Verifique se o README realmente mudou ou se o Git foi configurado corretamente."
    return
}

Write-Host "README comitado. Enviando para o GitHub..."
& $gitPath push origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host "README sincronizado com sucesso!"
} else {
    Write-Host "Falha no push. Verifique sua autenticacao do GitHub."
}
