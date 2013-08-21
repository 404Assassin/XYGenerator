@md "Adobe AIR\Versions\1.0"
@xcopy /q /y "Adobe AIR.dll" "Adobe AIR\Versions\1.0\."
@md "Adobe AIR\Versions\1.0\Resources"
@xcopy /q /y "Adobe AIR.vch" "Adobe AIR\Versions\1.0\Resources\."
@xcopy /q /y adobecp.dll "Adobe AIR\Versions\1.0\Resources\."
@xcopy /q /y adobecp.vch "Adobe AIR\Versions\1.0\Resources\."
@xcopy /q /y AdobeCP15.dll "Adobe AIR\Versions\1.0\Resources\."
@xcopy /q /y CaptiveAppEntry.exe "Adobe AIR\Versions\1.0\Resources\."
@xcopy /q /y NPSWF32.dll "Adobe AIR\Versions\1.0\Resources\."
@xcopy /q /y WebKit.dll "Adobe AIR\Versions\1.0\Resources\."
@md css
@xcopy /q /y flashSiteStyles.css css\.
@md fonts
@xcopy /q /y fontENTrebuchetMS.swf fonts\.
@md META-INF
@xcopy /q /y signatures.xml META-INF\.
@md META-INF\AIR
@xcopy /q /y application.xml META-INF\AIR\.
@xcopy /q /y hash META-INF\AIR\.