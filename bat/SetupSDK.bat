:user_configuration
set AUTO_INSTALL_IOS=yes
:: Path to Android SDK
set ANDROID_SDK=C:\Program Files (x86)\FlashDevelop\Tools\android
::set ANDROID_SDK=C:\Users\Evan\AppData\Local\Android\android-sdk

:validation
:: Path to Flex SDK
set FLEX_SDK=C:\Users\bomoon\AppData\Local\FlashDevelop\Apps\flexairsdk\4.6.0+17.0.0
if not exist "%FLEX_SDK%\bin" goto flexsdk2
goto foundflexsdk

:flexsdk2
set FLEX_SDK=C:\Users\Evan\AppData\Local\FlashDevelop\Apps\flexairsdk\4.6.0+17.0.0
if not exist "%FLEX_SDK%\bin" goto flexsdk3
goto foundflexsdk

:flexsdk3
set FLEX_SDK=C:\Users\cheng\AppData\Local\FlashDevelop\Apps\flexairsdk\4.6.0+17.0.0
if not exist "%FLEX_SDK%\bin" goto flexsdk4
goto foundflexsdk

:flexsdk4
:: IGNACIO PUT YOUR PATH HERE
set FLEX_SDK=C:\Users\John\Desktop\FlashDevelop-4.7.2\Apps\flexairsdk\4.6.0+17.0.0
if not exist "%FLEX_SDK%\bin" goto flexsdknotfound
goto foundflexsdk


:foundflexsdk

::if not exist "%ANDROID_SDK%\platform-tools" goto androidsdk
goto succeed

:flexsdknotfound
echo.
echo ERROR: incorrect path to Flex SDK in 'bat\SetupSDK.bat'
echo.
echo Looking for: %FLEX_SDK%\bin
echo.
if %PAUSE_ERRORS%==1 pause
exit

:androidsdk
echo.
echo ERROR: incorrect path to Android SDK in 'bat\SetupSDK.bat'
echo.
echo Looking for: %ANDROID_SDK%\platform-tools
echo.
if %PAUSE_ERRORS%==1 pause
exit

:succeed
set PATH=%FLEX_SDK%\bin;%PATH%
set PATH=%PATH%;%ANDROID_SDK%\platform-tools

