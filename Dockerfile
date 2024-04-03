# Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

# 使用 openeuler:22.03-lts 作为基础镜像
FROM xxxxxxxxxxx/openeuler:22.03-lts

ENV PATH="/opt/bitnami/redis/bin:${PATH}"  

COPY bitnami /opt/bitnami 
COPY redis-6.2.9 /tmp/redis-6.2.9
COPY run.sh  /run.sh
COPY entrypoint.sh /entrypoint.sh

RUN set -xue \
    && ulimit -n 65523 \
    && sed -i 's@repo.openeuler.org@mirrors.huaweicloud.com/openeuler@g' /etc/yum.repos.d/openEuler.repo \
    && yum update -y \
    && yum install gcc gcc-c++ make glibc-devel glibc-headers zlib zlib-devel perl perl-CPAN -y \
    && mkdir -pv /bitnami/redis/data \
    && cd /tmp/redis-6.2.9 \
    && make -j4 \
    && make install \
    && cp -rf src/redis* /opt/bitnami/redis/bin/ \
    && rm -rf /tmp/redis-6.2.9 \
    && yum clean all

# 暴露 REDIS 服务端口
EXPOSE 6379

CMD ["/opt/bitnami/redis/bin/redis-server","/opt/bitnami/redis/etc/redis.conf"]
