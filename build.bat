flutter build web --dart-define=BROWSER_IMAGE_DECODING_ENABLED=false --release --base-href "/Line-Converter/" --web-renderer canvaskit
del "docs\*.*" /F /Q
XCOPY build\web\*.* docs\ /E /H /C /Y