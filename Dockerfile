FROM mcr.microsoft.com/dotnet/framework/runtime

LABEL maintainer="cremator"

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN $j = Invoke-RestMethod -Uri "https://services.sonarr.tv/v1/download/master"; \
    Invoke-WebRequest $j.windows.manual.url -OutFile c:\sonarr.zip ; \
    Expand-Archive c:\sonarr.zip -DestinationPath C:\ ; \
    Remove-Item -Path c:\sonarr.zip -Force; \
	Start-Process "C:\NzbDrone\ServiceInstall.exe" -Wait; \	
	Start-Sleep -s 10; \
	Stop-Service -name "NzbDrone" -Force -ErrorAction SilentlyContinue; \
	Start-Sleep -s 10; \
	Remove-Item "C:/ProgramData/NzbDrone" -Force -Recurse

EXPOSE 8989

VOLUME [ "C:/ProgramData/NzbDrone", "C:/tv" ]

CMD "Get-Content C:\ProgramData\NzbDrone\logs\sonarr.txt -Wait"
