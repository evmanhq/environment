FROM centos

ADD nginx.repo yarn.repo /etc/yum.repos.d/

RUN curl -sLf 'https://dl.cloudsmith.io/public/mjelen/mjelen/cfg/install/config.rpm.txt?os=el&dist=7' > /etc/yum.repos.d/mjelen-mjelen.repo

RUN yum update -y && yum install -y epel-release \
    && yum install -y ruby nginx \
       gcc gcc-c++ bzip2 file ImageMagick ruby git nodejs yarn \
       ImageMagick-devel openssl-devel libyaml-devel libffi-devel \
       readline-devel zlib-devel gdbm-devel ncurses-devel curl-devel \
       postgresql-devel mysql-devel sqlite-devel libidn-devel \
    && yum clean -y all && rm -rf /var/cache/yum

RUN gem install --no-document bundler foreman

RUN useradd -d /ruby -m -u 1001 -g 0 ruby

USER ruby

WORKDIR /ruby

RUN mkdir -p ./nginx/temp ./app/{log,public,tmp} && chmod -R 777 .

ADD --chown=ruby:root nginx.conf ./
ADD --chown=ruby:root assets.sh entrypoint.sh application.sh Procfile ./app/

WORKDIR /ruby/app

ENV HOME="/ruby"
ENV PATH=$PATH:$HOME
ENV RAILS_ENV="production"
ENV NODE_ENV="production"

CMD ./entrypoint.sh

EXPOSE 8080
