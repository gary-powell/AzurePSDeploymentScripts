function Test-AzWebAppSlotAndPromote {
    param(
        [string]
        [Parameter(Mandatory = $true)]
        $WebAppName,

        [string]
        [Parameter(Mandatory = $true)]
        $UrlToTest,

        [string]
        [Parameter(Mandatory = $true)]
        $SourceSlotName,

        [string]
        [Parameter(Mandatory = $true)]
        $DestinationSlotName,

        [string]
        [Parameter(Mandatory = $true)]
        $ResourceGroupName
    )
    Set-StrictMode -Version Latest
    $ErrorActionPreference = "Stop"

    try
    {
        $Request = [System.Net.WebRequest]::Create($UrlToTest)
        try 
        {
            $Response = $Request.GetResponse()
        }
        catch [System.Net.WebException] {
            $Response = $_.Exception.Response
        }
        
        if ($Response.StatusCode -eq "200")
        {
            Write-Output "##[section] $( $UrlToTest ) is up (Return code: $( $Response.StatusCode ) - $( [int]$Response.StatusCode ))"
        }
        else
        {
            Write-Output "##[error] Site - $( $UrlToTest ) is down (Return code: $( $Response.StatusCode ))"
            throw
        }
    }
    catch
    {
        Write-Output "##[error] Site - $( $UrlToTest ) is not accessible"
        throw
    }

    Write-Output "Switching Web App slot $($WebAppName)..."
    Switch-AzWebAppSlot `
        -SourceSlotName $SourceSlotName `
        -DestinationSlotName $DestinationSlotName `
        -ResourceGroupName $ResourceGroupName `
        -Name $WebAppName
    Write-Output "##[section] Switched $( $SourceSlotName ) to $( $DestinationSlotName )!"

}