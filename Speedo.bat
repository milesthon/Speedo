:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                   by  MilesthoN                     ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@ECHO OFF
CHCP 65001>NUL
COLOR F9
TITLE Speedo (Windows 10+) by MilesthoN

ECHO.&ECHO.
ECHO        Check update..
ECHO        Проверка обновлений..
curl -# --ssl-no-revoke --insecure -L https://github.com/milesthon/Speedo/raw/main/Speedo.bat -o "%temp%\CheckSpeedoVersion.txt"
if %errorlevel% neq 0 goto noupdate
ECHO.&ECHO.
findstr /c:"CheckSpeedoVersion 26012024" "%temp%\CheckSpeedoVersion.txt" > nul
if %errorlevel%==0 (
goto noupdate
) else (
cls
COLOR F9
ECHO.&ECHO.
ECHO        Update..
curl -# --ssl-no-revoke --insecure -L https://codeload.github.com/milesthon/Speedo/zip/refs/heads/main  -o "%temp%\Speedo-main.zip"
ECHO.
powershell -command "Expand-Archive -Path "%temp%\Speedo-main.zip" -DestinationPath "%temp%\Speedo-main" -Force"         2>nul >nul
copy "%temp%\Speedo-main\Speedo-main\*" "%~dp0"                                                                          2>nul >nul
start "" "%~f0"&exit
)

:noupdate
MODE 62,8
ECHO.&ECHO.&ECHO.&ECHO                Run as Administrator..&ECHO                Запуск от имени Администратора..&ECHO.&ECHO.
net sess>NUL 2>&1||(powershell try{saps '%0'-Verb RunAs}catch{}&exit)

cls

MODE 62,26
COLOR F9
ECHO.&ECHO.&ECHO.&ECHO.
CALL :COLOR F5
CALL :ECHO "                              ###"
CALL :COLOR F5
CALL :ECHO "                           #######"
CALL :COLOR F5
CALL :ECHO "                         #########"
CALL :COLOR F5
CALL :ECHO "                        #########"
CALL :COLOR FD
CALL :ECHO "                      ###########" /
CALL :COLOR FD
CALL :ECHO "    #####"
CALL :COLOR FD
CALL :ECHO "                     ###########" /
CALL :COLOR FD
CALL :ECHO "  ########"
CALL :COLOR F1
CALL :ECHO "                    #####" /
CALL :COLOR F1
CALL :ECHO "  ###############"
CALL :COLOR F1
CALL :ECHO "                    ####" /
CALL :COLOR F1
CALL :ECHO "   ###############"
CALL :COLOR F9
CALL :ECHO "                           #######" /
CALL :COLOR F9
CALL :ECHO "  ######"
CALL :COLOR F9
CALL :ECHO "                            ###" /
CALL :COLOR F9
CALL :ECHO "     #####"
CALL :COLOR F3
CALL :ECHO "                                    ####"
CALL :COLOR F3
CALL :ECHO "                                   ####"
CALL :COLOR F3
CALL :ECHO "                                   ####"
CALL :COLOR F3
CALL :ECHO "                                   ####"
CALL :COLOR FB
CALL :ECHO "                                   ####"
CALL :COLOR FB
CALL :ECHO "                                  #####"
CALL :COLOR FB
CALL :ECHO "                                   ####"
CALL :COLOR FB
CALL :ECHO "                                    ####"
ping localhost -n 2 >NUL
goto sett
exit/b
:COLOR
 set c=%1& exit/b
:ECHO
 for /f %%i in ('"prompt $h& for %%i in (.) do rem"') do (
  pushd "%~dp0"& <NUL>"%~1_" set/p="%%i%%i  "& findstr/a:%c% . "%~1_*"
  (if "%~2" neq "/" ECHO.)& del "%~1_"& popd& set c=& exit/b
 )

:sett

cls
MODE 62,7

cls
echo.
echo Wait..

:: Default MSConfig
bcdedit /deletevalue {current} numproc         2>nul >nul
bcdedit /deletevalue {current} truncatememory  2>nul >nul
bcdedit /deletevalue {current} removememory    2>nul >nul
bcdedit /deletevalue {current} maxmem          2>nul >nul
bcdedit /set {default} bootmenupolicy standard 2>nul >nul

:: Virtual Memory Paging File
wmic computersystem where name="%computername%" set AutomaticManagedPagefile=True 2>nul >nul

:: Disabling hibernation
powercfg.exe /hibernate off 2>nul >nul

:: Enabling high performance
powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>nul >nul

:: Enable Windows features
powershell -command "Enable-WindowsOptionalFeature -Online -All -FeatureName "NetFx3""     2>nul >nul
powershell -command "Enable-WindowsOptionalFeature -Online -All -FeatureName "DirectPlay"" 2>nul >nul
powershell -command "Enable-WindowsOptionalFeature -Online -All -FeatureName "Containers"" 2>nul >nul

:: Registry tweaks..
:: Offline maps
REG ADD "HKLM\SYSTEM\Maps" /v AutoUpdateEnabled /d 0 /t REG_DWORD /f 2>nul >nul
:: Autoload
REG ADD "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\Microsoft.549981C3F5F10_8wekyb3d8bbwe\CortanaStartupId" /v UserEnabledStartupOnce /d 0 /t REG_DWORD /f 2>nul >nul
REG ADD "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\Microsoft.549981C3F5F10_8wekyb3d8bbwe\CortanaStartupId" /v State /d 1                  /t REG_DWORD /f 2>nul >nul
:: Accessibility Keyboard
REG ADD "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d 506        /f 2>nul >nul
REG ADD "HKCU\Control Panel\Accessibility\Keyboard Response" /v Flags /t REG_SZ /d 122 /f 2>nul >nul
REG ADD "HKCU\Control Panel\Accessibility\ToggleKeys" /v Flags /t REG_SZ /d 58         /f 2>nul >nul
:: Settings - Privacy - General
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /d 0 /t REG_DWORD /f 2>nul >nul
REG ADD "HKCU\Control Panel\International\User Profile" /v HttpAcceptLanguageOptOut /d 1 /t REG_DWORD /f 2>nul >nul
:: Settings - Privacy - Voice Features
REG ADD "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" /v HasAccepted /d 0 /t REG_DWORD /f 2>nul >nul
:: Settings - Privacy - Personalize handwriting and keyboard input
REG ADD "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v RestrictImplicitInkCollection /d 1    /t REG_DWORD /f 2>nul >nul
REG ADD "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v RestrictImplicitTextCollection /d 1   /t REG_DWORD /f 2>nul >nul
REG ADD "HKCU\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v HarvestContacts /d 0 /t REG_DWORD /f 2>nul >nul
REG ADD "HKCU\SOFTWARE\Microsoft\Personalization\Settings" /v AcceptedPrivacyPolicy /d 0        /t REG_DWORD /f 2>nul >nul
:: Background applications
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.Windows.Photos_8wekyb3d8bbwe" /v Disabled /d 1       /t REG_DWORD /f 2>nul >nul
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.Windows.Photos_8wekyb3d8bbwe" /v DisabledByUser /d 1 /t REG_DWORD /f 2>nul >nul
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.YourPhone_8wekyb3d8bbwe" /v Disabled /d 1            /t REG_DWORD /f 2>nul >nul
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.YourPhone_8wekyb3d8bbwe" /v DisabledByUser /d 1      /t REG_DWORD /f 2>nul >nul
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.WindowsMaps_8wekyb3d8bbwe" /v Disabled /d 1          /t REG_DWORD /f 2>nul >nul
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.WindowsMaps_8wekyb3d8bbwe" /v DisabledByUser /d 1    /t REG_DWORD /f 2>nul >nul
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.WindowsAlarms_8wekyb3d8bbwe" /v Disabled /d 1        /t REG_DWORD /f 2>nul >nul
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.WindowsAlarms_8wekyb3d8bbwe" /v DisabledByUser /d 1  /t REG_DWORD /f 2>nul >nul
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.MSPaint_8wekyb3d8bbwe" /v Disabled /d 1              /t REG_DWORD /f 2>nul >nul
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.MSPaint_8wekyb3d8bbwe" /v DisabledByUser /d 1        /t REG_DWORD /f 2>nul >nul
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.549981C3F5F10_8wekyb3d8bbwe" /v Disabled /d 1        /t REG_DWORD /f 2>nul >nul
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.549981C3F5F10_8wekyb3d8bbwe" /v DisabledByUser /d 1  /t REG_DWORD /f 2>nul >nul
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.People_8wekyb3d8bbwe" /v Disabled /d 1               /t REG_DWORD /f 2>nul >nul
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.People_8wekyb3d8bbwe" /v DisabledByUser /d 1         /t REG_DWORD /f 2>nul >nul
:: Reducing application startup speed
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /d 0 /t REG_DWORD /f 2>nul >nul
:: Increase file system cache
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /d 0 /t REG_DWORD /f 2>nul >nul
:: Sound - When using a computer for conversation
REG ADD "HKCU\Software\Microsoft\Multimedia\Audio" /v "UserDuckingPreference" /d 3 /t REG_DWORD /f 2>nul >nul
:: Feedback & diagnostics. Disable telemetry
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /d 0                                                                                                                                                                                            /t REG_DWORD /f 2>nul >nul
REG ADD "HKLM\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /d 0                                                                                                                                                                                /t REG_DWORD /f 2>nul >nul
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /d 0                                                                                                                                                                             /t REG_DWORD /f 2>nul >nul
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "MaxTelemetryAllowed" /d 0                                                                                                                                                                        /t REG_DWORD /f 2>nul >nul
REG ADD "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /d 0                                                                                                                                                                 /t REG_DWORD /f 2>nul >nul
REG ADD "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "MaxTelemetryAllowed" /d 0                                                                                                                                                            /t REG_DWORD /f 2>nul >nul
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /d 0                                                                                                                                                                                                      /t REG_DWORD /f 2>nul >nul
:: Disable Diagtrack-Listener
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Diagtrack-Listener" /v "Start" /d 0                                                                                                                                                                                     /t REG_DWORD /f 2>nul >nul
:: Save attachment zone information
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v "SaveZoneInformation" /d 1                                                                                                                                                                           /t REG_DWORD /f 2>nul >nul
:: Disable experiments
REG ADD "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\System" /v "AllowExperimentation" /d 0                                                                                                                                                                                  /t REG_DWORD /f 2>nul >nul
:: Disable SIUF
REG ADD "HKCU\Software\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /d 0                                                                                                                                                                                                           /t REG_DWORD /f 2>nul >nul
REG ADD "HKCU\Software\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /d 0                                                                                                                                                                                                            /t REG_DWORD /f 2>nul >nul
:: Disable UAR
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /d 1                                                                                                                                                                                                     /t REG_DWORD /f 2>nul >nul
:: Disable camera on lock screen
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoLockScreenCamera" /d 1                                                                                                                                                                                       /t REG_DWORD /f 2>nul >nul
:: Disable handwriting sharing
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /d 1                                                                                                                                                                                   /t REG_DWORD /f 2>nul >nul
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /d 1                                                                                                                                                                   /t REG_DWORD /f 2>nul >nul
:: Disable TIPC
REG ADD "HKCU\Software\Microsoft\Input\TIPC" /v "Enabled" /d 0                                                                                                                                                                                                                        /t REG_DWORD /f 2>nul >nul
:: Disable inventory
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /d 1                                                                                                                                                                                               /t REG_DWORD /f 2>nul >nul
:: Disable AD Bluetooth
REG ADD "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Bluetooth" /v "AllowAdvertising" /d 0                                                                                                                                                                                   /t REG_DWORD /f 2>nul >nul
:: General. Disable track app launches
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t REG_DWORD /d 0 /f                                                                                                                                                                 /t REG_DWORD /f 2>nul >nul
:: Speech. Prevent sending your voice input to Microsoft Speech services:
REG ADD "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" /v "HasAccepted" /t REG_DWORD /d 0 /f                                                                                                                                                                   /t REG_DWORD /f 2>nul >nul
:: Feedback & diagnostics. Turn off tailored experiences
REG ADD "HKCU\Software\Policies\Microsoft\Windows\CloudContent" /v "DisableTailoredExperiencesWithDiagnosticData" /d 1                                                                                                                                                                /t REG_DWORD /f 2>nul >nul
:: Inking & Typing. Turn off Inking & Typing data collection
REG ADD "HKCU\Software\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /d 0                                                                                                                                                                              /t REG_DWORD /f 2>nul >nul
REG ADD "HKCU\Software\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /d 0                                                                                                                                                                               /t REG_DWORD /f 2>nul >nul
REG ADD "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /d 1                                                                                                                                                                                        /t REG_DWORD /f 2>nul >nul
REG ADD "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /d 1                                                                                                                                                                                       /t REG_DWORD /f 2>nul >nul
:: Personalized Experiences. Disable feature
REG ADD "HKCU\Software\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightFeatures" /d 1                                                                                                                                                                             /t REG_DWORD /f 2>nul >nul
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableCloudOptimizedContent" /d 1                                                                                                                                                                                /t REG_DWORD /f 2>nul >nul
:: Disable Cortana
REG ADD "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Experience\AllowCortana" /v "value" /d 0                                                                                                                                                                                       /t REG_DWORD /f 2>nul >nul
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search" /v "CortanaConsent" /d 0                                                                                                                                                                                      /t REG_DWORD /f 2>nul >nul
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "CortanaEnabled" /d 0                                                                                                                                                                                              /t REG_DWORD /f 2>nul >nul
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "CortanaEnabled" /d 0                                                                                                                                                                                              /t REG_DWORD /f 2>nul >nul
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "CanCortanaBeEnabled" /d 0                                                                                                                                                                                         /t REG_DWORD /f 2>nul >nul
:: Cortana and Search Group Policies. Turn off Cortana
REG ADD "HKLM\Software\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /d 0                                                                                                                                                                                              /t REG_DWORD /f 2>nul >nul
:: Cortana and Search Group Policies. Block access to location information for Cortana
REG ADD "HKLM\Software\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /d 0                                                                                                                                                                                  /t REG_DWORD /f 2>nul >nul
:: Cortana and Search Group Policies. Firewall block rule
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\FirewallRules" /v "{0DE40C8E-C126-4A27-9371-A27DAB1039F7}" /t REG_SZ /d "v2.25|Action=Block|Active=TRUE|Dir=Out|Protocol=6|App=%windir%\\SystemApps\\Microsoft.Windows.Cortana_cw5n1h2txyewy\\searchUI.exe|Name=Block outbound Cortana|" /f 2>nul >nul
:: Device metadata retrieval. Prevent
REG ADD "HKLM\Software\Policies\Microsoft\Windows\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /d 1                                                                                                                                                                         /t REG_DWORD /f 2>nul >nul
:: Internet Explorer. Turn off background synchronization for feeds and Web Slices
REG ADD "HKLM\Software\Policies\Microsoft\Internet Explorer\Feeds" /v "BackgroundSyncStatus" /d 0                                                                                                                                                                                     /t REG_DWORD /f 2>nul >nul
:: Microsoft Edge Group Policies. Don't send "Do Not Track"
REG ADD "HKLM\Software\Policies\Microsoft\MicrosoftEdge\Main" /v "DoNotTrack" /d 1                                                                                                                                                                                                    /t REG_DWORD /f 2>nul >nul
:: Offline maps. Disable download and update offline maps
REG ADD "HKLM\Software\Policies\Microsoft\Windows\Maps" /v "AutoDownloadAndUpdateMapData" /d 0                                                                                                                                                                                        /t REG_DWORD /f 2>nul >nul
REG ADD "HKLM\Software\Policies\Microsoft\Windows\Maps" /v "AllowUntriggeredNetworkTrafficOnSettingsPage" /d 0                                                                                                                                                                        /t REG_DWORD /f 2>nul >nul
:: OneDrive. Prevent OneDrive from generating network traffic until the user signs in to OneDrive
REG ADD "HKLM\Software\Microsoft\OneDrive" /v "PreventNetworkTrafficPreUserSignIn" /d 1                                                                                                                                                                                               /t REG_DWORD /f 2>nul >nul
:: General. Turn off advertising ID
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /d 0                                                                                                                                                                                            /t REG_DWORD /f 2>nul >nul
REG ADD "HKLM\Software\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d 1                                                                                                                                                                       /t REG_DWORD /f 2>nul >nul
:: General. Disable continue experiences
REG ADD "HKLM\Software\Policies\Microsoft\Windows\System" /v "EnableCdp" /d 0                                                                                                                                                                                                         /t REG_DWORD /f 2>nul >nul
:: Feedback & diagnostics. Turn off Feedback notifications
REG ADD "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /d 1                                                                                                                                                                            /t REG_DWORD /f 2>nul >nul                                                                                                                                                                                      /t REG_DWORD /f 2>nul >nul
:: Feedback & diagnostics. Turn off tailored experiences
REG ADD "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /d 1                                                                                                                                                                              /t REG_DWORD /f 2>nul >nul
:: Inking & Typing. Turn off Inking & Typing data collection
REG ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\TextInput" /v "AllowLinguisticDataCollection" /d 0                                                                                                                                                                   /t REG_DWORD /f 2>nul >nul
:: Activity History. Turn off tracking of your Activity History
REG ADD "HKLM\Software\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /d 0                                                                                                                                                                                                /t REG_DWORD /f 2>nul >nul
REG ADD "HKLM\Software\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /d 0                                                                                                                                                                                             /t REG_DWORD /f 2>nul >nul
REG ADD "HKLM\Software\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /d 0                                                                                                                                                                                              /t REG_DWORD /f 2>nul >nul
:: News and interests. Disable Windows Feeds
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v "EnableFeeds" /d 0                                                                                                                                                                                                /t REG_DWORD /f 2>nul >nul
:: Microsoft Defender Antivirus. Stop sending file samples back to Microsoft
REG ADD "HKLM\Software\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /d 2                                                                                                                                                                                     /t REG_DWORD /f 2>nul >nul


:: Disabling unnecessary services
:: Connected user functionality and telemetry
sc stop DiagTrack                         2>nul >nul
sc config DiagTrack start=disabled        2>nul >nul
:: Parental control
sc stop WpcMonSvc                         2>nul >nul
sc config WpcMonSvc start=disabled        2>nul >nul
:: Certificate Distribution
sc stop CertPropSvc                       2>nul >nul
sc config CertPropSvc start=disabled      2>nul >nul
:: UDK Custom Service
sc stop UdkUserSvc_12345                  2>nul >nul
sc config UdkUserSvc_12345 start=disabled 2>nul >nul
sc stop UdkUserSvc                        2>nul >nul
sc config UdkUserSvc start=disabled       2>nul >nul
sc stop UdkUserSvc_9f69d                  2>nul >nul
sc config UdkUserSvc_9f69d start=disabled 2>nul >nul
:: Downloaded map manager
sc stop MapsBroker                        2>nul >nul
sc config MapsBroker start=disabled       2>nul >nul
:: Служба маршрутизатора AllJoyn
sc stop AJRouter                          2>nul >nul
sc config AJRouter start=disabled         2>nul >nul
:: Microsoft Windows SMS Router Service
sc stop SmsRouter                         2>nul >nul
sc config SmsRouter start=disabled        2>nul >nul
:: Store demo service
sc stop RetailDemo                        2>nul >nul
sc config RetailDemo start=disabled       2>nul >nul
:: Diagnostic Execution Service
sc stop diagsvc                           2>nul >nul
sc config diagsvc start=disabled          2>nul >nul
:: SuperFetch
net stop superfetch                       2>nul >nul
sc config sysmain start=disabled          2>nul >nul

:: Enabling required services..
:: DHCP Client
sc config Dhcp start=auto              2>nul >nul
:: DNS Client
sc config Dnscache start=auto          2>nul >nul
:: Network Connections
sc config Netman start=auto            2>nul >nul
:: Network Location Awareness
sc config NlaSvc start=auto            2>nul >nul
:: Remote Procedure Call (RPC)
sc config RpcSs start=auto             2>nul >nul
:: Server
sc config LanmanServer start=auto      2>nul >nul
:: TCP/IP Netbios helper
sc config lmhosts start=auto           2>nul >nul
:: Workstation
sc config LanmanWorkstation start=auto 2>nul >nul
:: Function Discovery Resource Publication
sc config FDResPub start=auto          2>nul >nul
:: UPnP Device Host services
sc config upnphost start=auto          2>nul >nul
:: Wired Auto Config
sc config dot3svc start=auto           2>nul >nul
:: WLAN Auto Config
sc config Wlansvc start=auto           2>nul >nul
:: COM+ Event System
sc config EventSystem start=auto       2>nul >nul
:: Computer Browser
sc config Browser start=auto           2>nul >nul
:: Wireless Zero Configuration
sc config WZCSVC start=auto            2>nul >nul

:: Disabling unnecessary tasks..
:: RAM diagnostics
schtasks /change /tn "Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents" /disable 2>nul >nul
schtasks /change /tn "Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic"       /disable 2>nul >nul
:: Data collection
schtasks /change /tn "Microsoft\Windows\Maintenance\WinSAT"                                           /disable 2>nul >nul
schtasks /change /tn "Microsoft\Windows\Autochk\Proxy"                                                /disable 2>nul >nul
schtasks /change /tn "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"     /disable 2>nul >nul
schtasks /change /tn "Microsoft\Windows\Application Experience\ProgramDataUpdater"                    /disable 2>nul >nul
schtasks /change /tn "Microsoft\Windows\Application Experience\StartupAppTask"                        /disable 2>nul >nul
schtasks /change /tn "Microsoft\Windows\PI\Sqm-Tasks"                                                 /disable 2>nul >nul
schtasks /change /tn "Microsoft\Windows\NetTrace\GatherNetworkInfo"                                   /disable 2>nul >nul
schtasks /change /tn "Microsoft\Windows\Customer Experience Improvement Program\Consolidator"         /disable 2>nul >nul
schtasks /change /tn "Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"       /disable 2>nul >nul
schtasks /change /tn "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"              /disable 2>nul >nul
schtasks /change /tn "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticResolver"      /disable 2>nul >nul
schtasks /change /tn "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /disable 2>nul >nul
:: Office Data Collection
schtasks /change /tn "Microsoft\Office\Office ClickToRun Service Monitor"             /disable 2>nul >nul
schtasks /change /tn "Microsoft\Office\OfficeTelemetry\AgentFallBack2016"             /disable 2>nul >nul
schtasks /change /tn "Microsoft\Office\OfficeTelemetry\AgentFallBack2016"             /disable 2>nul >nul
schtasks /change /tn "Microsoft\Office\OfficeTelemetry\OfficeTelemetryAgentLogOn2016" /disable 2>nul >nul
schtasks /change /tn "Microsoft\Office\OfficeTelemetryAgentFallBack2016"              /disable 2>nul >nul
schtasks /change /tn "Microsoft\Office\OfficeTelemetryAgentLogOn2016"                 /disable 2>nul >nul
schtasks /change /tn "Microsoft\Office\OfficeTelemetryAgentFallBack"                  /disable 2>nul >nul
schtasks /change /tn "Microsoft\Office\OfficeTelemetryAgentLogOn"                     /disable 2>nul >nul
schtasks /change /tn "Microsoft\Office\Office 15 Subscription Heartbeat"              /disable 2>nul >nul

:: Other
:: ReadyBoost OFF
REG DELETE "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\MemoryManagement\PrefetchParameters" /v EnableSuperfetch /f 2>nul >nul
:: QoS (Quality of Service)
REG DELETE "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v NonBestEffortLimit                                         /f 2>nul >nul

cls
echo.
set /p choice=Reboot pc? Y or N 
if /i "%choice%"=="y" (
echo Rebooting in 10 seconds. Press any key to cancel.
timeout -t 4 |findstr "\<0\>" && shutdown -r -t 0 -f || echo cancelled
) else (
exit
)

pause