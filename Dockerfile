# COMP3231 OS Helpers and CI Stuff.
# Copyright (C) 2021 David Wu and Eric Holmstrom.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.


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
