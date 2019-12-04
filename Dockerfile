FROM mcr.microsoft.com/dotnet/framework/runtime

LABEL maintainer="cremator"

ENV SONARR_BRANCH="master"
ENV SONARR_JSON="https://services.sonarr.tv/v1/download/"

RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \
    $ProgressPreference = 'Continue'; \
	$j = Invoke-RestMethod -Uri "https://services.sonarr.tv/v1/download/master"; \
    Invoke-WebRequest $j.windows.manual.url -OutFile c:\sonarr.zip ; \
    Expand-Archive c:\sonarr.zip -DestinationPath C:\ ; \
    Remove-Item -Path c:\sonarr.zip -Force; \
	Start-Process "C:\NzbDrone\ServiceInstall.exe" -Wait; \
	New-Item -ItemType 'Junction' -Path 'C:\Config' -Value 'C:\ProgramData\NzbDrone'

EXPOSE 7878

VOLUME [ "C:/config" ]

CMD ["powershell", "Start-Service -name "NzbDrone"]
