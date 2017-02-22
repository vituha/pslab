Function GetPasswordStatusString([int] $passwordStatus) 
{
    Switch ($passwordStatus) 
    {
        1 {return 'Disabled'}
        2 {return 'Enabled'}
        3 {return 'NA'}
        4 {return 'Unknown'}
    }
}

Function GetOSInfo([string[]] $computerNames)
{
    $computerNames `
    | Select-Object -Property `
        @{Name='csinfo'; Expression={Get-CimInstance -ComputerName $_ -ClassName Win32_ComputerSystem}}, `
        @{Name='biosinfo'; Expression={Get-CimInstance -ComputerName $_ -ClassName Win32_BIOS}}, `
        @{Name='osinfo'; Expression={Get-CimInstance -ComputerName $_ -ClassName Win32_OperatingSystem}} `
    | Select-Object -Property `
        @{Name='ComputerName'; Expression={$_.csinfo.Name}}, `
        @{Name='Workgroup'; Expression={$_.csinfo.Workgroup}}, `
        @{Name='AdminPassword'; Expression={GetPasswordStatusString -passwordStatus $_.csinfo.AdminPassworStatus}}, `
        @{Name='Model'; Expression={$_.csinfo.Model}}, `
        @{Name='Manufacturer'; Expression={$_.csinfo.Manufacturer}}, `
        @{Name='BIOSSerial'; Expression={$_.biosinfo.SerialNumber}}, `
        @{Name='OSVersion'; Expression={$_.osinfo.Version}}, `
        @{Name='SPVersion'; Expression={$_.osinfo.ServicePackMajorVersion}}
}

GetOSInfo -computerNames localhost