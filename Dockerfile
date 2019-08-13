FROM debian:stretch 

RUN apt-get update && \
    apt-get install -y build-essential libncurses5-dev libpcap-dev checkinstall


RUN apt-get install -y git
RUN git clone https://github.com/6RiverSystems/nethogs.git && \
    cd nethogs

RUN make && \
    checkinstall -D make install


