FROM registry.gitlab.com/evman/stuart

RUN adduser --uid 1001 --gid 0 evman

RUN curl -sL https://rpm.nodesource.com/setup_7.x | bash - && \
    curl https://dl.yarnpkg.com/rpm/yarn.repo -o /etc/yum.repos.d/yarn.repo && \
    curl -o /etc/yum.repos.d/bintray-mjelen-centos.repo  https://bintray.com/mjelen/centos/rpm && \
    yum -y install gcc gcc-c++ bzip2 openssl-devel libyaml-devel libffi-devel \
        readline-devel zlib-devel gdbm-devel ncurses-devel curl-devel postgresql-devel \
        file ImageMagick-devel ImageMagick ruby git nodejs yarn && \
    yum -y clean all && gem install bundler

ENV RAILS_ENV="production"
ENV NODE_ENV="production"

ENV STUART_CHILD="/home/evman/evman.sh"
ENV STUART_TARGET="http://localhost:3000/"

USER evman

WORKDIR /home/evman

RUN mkdir /home/evman/{log,tmp,public}

EXPOSE 8080