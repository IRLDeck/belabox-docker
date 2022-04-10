FROM debian
LABEL maintainer="tomekkleszcz"

# Install necessary packages
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y git tclsh pkg-config cmake libssl-dev build-essential zlib1g-dev

# Build patched version of srt by @rationalsa
ENV LD_LIBRARY_PATH /usr/local/lib
WORKDIR /
RUN git clone https://github.com/BELABOX/srt.git
WORKDIR /srt/
RUN ./configure
RUN make install

WORKDIR /
RUN git clone https://github.com/IRLDeck/srt-live-server.git
WORKDIR /srt-live-server/
RUN make

COPY sls.conf /srt-live-server/

EXPOSE 8080
EXPOSE 8181

CMD /srt-live-server/bin/sls -c /srt-live-server/sls.conf