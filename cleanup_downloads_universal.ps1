[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8

# Проверка операционной системы
if ($PSVersionTable.Platform -ne 'Win32NT' -and $PSVersionTable.Platform -ne $null) {
    exit
}

# Получение пути к папке Downloads
$shell = New-Object -ComObject Shell.Application
$folder = $shell.Namespace('shell:Downloads').Self.Path

# Проверка и установка BurntToast
if (-not (Get-Module -ListAvailable -Name BurntToast)) {
    if (Test-Connection -ComputerName www.google.com -Count 1 -Quiet) {
        Install-Module -Name BurntToast -Scope CurrentUser
    } else {
        exit
    }
}

New-BurntToastNotification -Text "Очистка папки Загрузки", "Через 10 минут содержимое будет удалено!" -Sound 'IM'

Start-Sleep -Seconds 600

try {
    Get-ChildItem -Path $folder -Recurse | Remove-Item -Force -ErrorAction Stop
    New-BurntToastNotification -Text "Очистка папки Загрузки", "Готово, папка 'Загрузки' очищена." -Sound 'IM'
} catch {
    New-BurntToastNotification -Text "Очистка папки Загрузки", "Ошибка: не удалось очистить папку. Подробности: $_" -Sound 'SMS'
}
