FROM amake/wine:latest as inno
MAINTAINER Aaron Madlon-Kay <aaron@madlon-kay.com>

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends procps xvfb \
    && rm -rf /var/lib/apt/lists/*

# get at least error information from wine
ENV WINEDEBUG -all,err+all

# Run virtual X buffer on this port
ENV DISPLAY :99

COPY opt /opt
RUN chmod +x /opt/bin/*
ENV PATH $PATH:/opt/bin

USER xclient

# Install Inno Setup binaries
RUN curl -SL "http://files.jrsoftware.org/is/6/innosetup-6.0.5.exe" -o is.exe \
    && /opt/bin/wine-x11-run wine is.exe /SP- /VERYSILENT /ALLUSERS /SUPPRESSMSGBOXES \
    && rm is.exe

# Install unofficial languages
RUN cd "/home/xclient/.wine/drive_c/Program Files/Inno Setup 6/Languages" \
    && curl -L "https://api.github.com/repos/jrsoftware/issrc/tarball/is-6_0_5" \
    | tar xz --strip-components=4 --wildcards "*/Files/Languages/Unofficial/*.isl"

FROM debian:buster-slim


RUN apt-get update \
    && apt-get install -y --no-install-recommends procps gosu nano curl \
    && rm -rf /var/lib/apt/lists/*


# Install some tools required for creating the image
# Install wine and related packages
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    wine \
    wine32 \
    osslsigncode \
    && rm -rf /var/lib/apt/lists/*

COPY opt /opt
RUN chmod +x /opt/bin/*
ENV PATH $PATH:/opt/bin

COPY --from=inno /home/xclient/.wine /home/xclient/.wine
RUN chmod -R a+rwX /home/xclient
RUN mkdir /work

WORKDIR /work
ENTRYPOINT ["useriscc"]
