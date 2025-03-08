[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8

$logFile = "$env:USERPROFILE\Downloads_cleanup_log.txt"
"$(Get-Date) - Скрипт запущен." | Out-File -FilePath $logFile -Append

# Проверка операционной системы
if ($PSVersionTable.Platform -ne 'Win32NT' -and $PSVersionTable.Platform -ne $null) {
    "$(Get-Date) - Ошибка: Этот скрипт работает только на Windows." | Out-File -FilePath $logFile -Append
    exit
}

# Получение пути к папке Downloads
$shell = New-Object -ComObject Shell.Application
$folder = $shell.Namespace('shell:Downloads').Self.Path
"$(Get-Date) - Путь к папке: $folder" | Out-File -FilePath $logFile -Append

# Проверка и установка BurntToast
if (-not (Get-Module -ListAvailable -Name BurntToast)) {
    if (Test-Connection -ComputerName www.google.com -Count 1 -Quiet) {
        "$(Get-Date) - Модуль BurntToast не установлен. Устанавливаю..." | Out-File -FilePath $logFile -Append
        Install-Module -Name BurntToast -Scope CurrentUser
    } else {
        "$(Get-Date) - Ошибка: Нет интернета для установки BurntToast. Уведомления не будут работать." | Out-File -FilePath $logFile -Append
        exit
    }
}

New-BurntToastNotification -Text "Очистка папки Загрузки", "Через 10 минут содержимое будет удалено!" -Sound 'IM'

Start-Sleep -Seconds 600

try {
    Get-ChildItem -Path $folder -File | Remove-Item -Force -ErrorAction Stop
    "$(Get-Date) - Удаление завершено успешно." | Out-File -FilePath $logFile -Append
    New-BurntToastNotification -Text "Очистка папки Загрузки", "Готово, папка 'Загрузки' очищена." -Sound 'IM'
} catch {
    "$(Get-Date) - Ошибка при удалении: $_" | Out-File -FilePath $logFile -Append
    New-BurntToastNotification -Text "Очистка папки Загрузки", "Ошибка: не удалось очистить папку. Подробности: $_" -Sound 'SMS'
}

"$(Get-Date) - Скрипт завершен." | Out-File -FilePath $logFile -Append
