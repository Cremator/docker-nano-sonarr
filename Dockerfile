FROM mcr.microsoft.com/powershell:nanoserver

LABEL maintainer="cremator"

ENV SONARR_BRANCH="master"
ENV SONARR_JSON="https://services.sonarr.tv/v1/download/"

RUN pwsh -Command \
    $ErrorActionPreference = 'Stop'; \
    $ProgressPreference = 'Continue'; \
	$j = Invoke-RestMethod -Uri $SONARR_JSON$SONARR_BRANCH; \
    Invoke-WebRequest $j.windows.manual.url -OutFile c:\sonarr.zip ; \
    Expand-Archive c:\sonarr.zip -DestinationPath C:\ ; \
    Remove-Item -Path c:\sonarr.zip -Force; \
	Start-Process "C:\NzbDrone\ServiceInstall.exe"; \
	New-Junction C:\Config C:\ProgramData\NzbDrone

EXPOSE 7878

VOLUME [ "C:/config" ]

CMD ["pwsh", "Start-Service -name "NzbDrone"]
