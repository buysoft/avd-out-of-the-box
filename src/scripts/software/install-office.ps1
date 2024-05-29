function Install-Office365
{
    [cmdletbinding()]
    param ()

    begin
    {
        $loggingUri = "https://dev.azure.com/WTXBV/DTX-External/_apis/git/repositories/DTX-External/items?scopePath=load-defaults.ps1&api-version=7.0"
        $scriptBlockDefaults = [Scriptblock]::Create((([System.Text.Encoding]::ASCII).getString((Invoke-WebRequest -Uri $($loggingUri) -UseBasicParsing).Content)))
        #
        # Load script function Write-Logging, Add-Folder
        # Setting variable logPrefix, logFolder, downloadFolder
        #
        . $scriptBlockDefaults
        #
        # Set parameters for this script
        #
        $appName = "Office365"
        $appFileName = "OfficeC2RClient.exe"
        $pathToOffice = "C:\Program Files\Common Files\microsoft shared\ClickToRun"
        $arguments = "/update user forceappshutdown=true"
        $DTXLogPath = "$($logFolder)/$($appName)-$(Get-Date -UFormat "%Y-%m-%d %H%M%S").log" -replace '\\', '/'
    }
    process
    {
        #
        # Start logging
        #
        Start-Transcript -Path $DTXLogPath -Append
        #
        # Set registry key to enable updates
        #
        $registryPath = 'HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration'
        $name = 'UpdatesEnabled'
        $value = 'True'
        Write-Logging -text "$($logPrefix) $appName change registry key [ $($registryPath) ] name [ $($name) ] with value [ $($value) ]"
        Set-ItemProperty -Path $registryPath -Name $name -Value $value
        #
        # Install updates
        #
        Write-Logging -text "$($logPrefix) Update $($appName)"
        Start-Process -Wait $($appFileName) -WorkingDirectory $($pathToOffice) -ArgumentList $arguments
        #
        # Set registry key to disable updates
        #
        $value = 'False'
        Write-Logging -text "$($logPrefix) $appName change registry key [ $($registryPath) ] name [ $($name) ] with value [ $($value) ]"
        Set-ItemProperty -Path $registryPath -Name $name -Value $value
    }
    end
    {
        #
        # Stop logging
        #
        Stop-Transcript
    }
}

Install-Office365
