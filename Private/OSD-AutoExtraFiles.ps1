function OSD-AutoExtraFilesBackup {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    #===================================================================================================
    Write-Verbose '19.1.1 OSD-AutoExtraFilesBackup'
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Copy Auto Extra Files to $OSMediaPath\WinPE\AutoExtraFiles" -ForegroundColor Green
    Write-Verbose "OSMediaPath: $OSMediaPath"

    $AEFLog = "$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Robocopy-AutoExtraFiles.log"
    Write-Verbose "$AEFLog"

    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" cacls.exe* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" choice.exe* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    #robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" cleanmgr.exe* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" comp.exe*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" defrag*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" djoin*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" forfiles*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" getmac*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" makecab.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" msinfo32.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" nslookup.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" systeminfo.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" tskill.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" winver.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
   
    #AeroLite Theme
    robocopy "$MountDirectory\Windows\Resources" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\Resources" aerolite*.* /s /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\Resources" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\Resources" shellstyle*.* /s /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    
    # BCP47
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" bcp47*.dll /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    
    # Browse Dialog
    robocopy "$MountDirectory\Windows\Resources\Themes\aero\shell\normalcolor" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" shellstyle*.* /s /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" explorerframe*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" StructuredQuery*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" edputil*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null

    # Magnify
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" magnify*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" magnification*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    
    # On Screen Keyboard
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" osk*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    
    # RDP
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" mstsc*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" pdh.dll* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" srpapi.dll* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    
    # Shutdown
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" shutdown.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" shutdownext.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" shutdownux.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null

    # Wireless
    # http://www.scconfigmgr.com/2018/03/06/build-a-winpe-with-wireless-support/
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" dmcmnutils*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" mdmregistration*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
}
