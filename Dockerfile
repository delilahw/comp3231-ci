FROM debian as base

RUN apt-get update && \
      apt-get install -y wget build-essential bmake libncurses5

RUN wget -nv http://www.cse.unsw.edu.au/~cs3231/os161-files/os161-utils_2.0.8-3.deb && \
      dpkg -i os161-utils_2.0.8-3.deb && \
      rm os161-utils_2.0.8-3.deb

ENV CS_PATH="/root/cs3231"
ENV ASST_DIR='asst3-src'
ENV ASST_PATH="$CS_PATH/$ASST_DIR"
ENV ASST_NAME='ASST3'

WORKDIR "$ASST_PATH"
COPY . .

CMD ["bash", "scripts/ci.sh"]
