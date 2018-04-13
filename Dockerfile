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

RUN useradd -m -u 1001 -g 0 ruby

USER ruby

RUN mkdir -p /home/ruby/nginx/temp /home/ruby/app/{log,public,tmp}

ADD --chown=ruby:root assets.sh entrypoint.sh application.sh \
    nginx.conf Procfile /home/ruby/

WORKDIR /home/ruby/app

ENV PATH $PATH:/home/ruby
ENV RAILS_ENV="production"
ENV NODE_ENV="production"

CMD /home/ruby/entrypoint.sh

EXPOSE 8080
