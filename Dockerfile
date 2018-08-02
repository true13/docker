FROM ubuntu:16.04
VOLUME /usr/sharedData
ENV DEBIAN_FRONTEND noninteractive

### SERVER SETTING ###
RUN sed -i 's/archive.ubuntu.com/ftp.daumkakao.com/g' /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y net-tools
# SSH #
RUN apt-get install -y openssh-server
# xinetd #
RUN apt-get install -y xinetd
RUN apt-get install -y netcat
RUN apt-get install -y wget
# gdb #
RUN apt-get -y install gcc-4.9 g++-4.9
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.9
RUN apt-get -y install build-essential
RUN apt-get -y install libc6-dbg gdb valgrind
# apm #
RUN echo "mysql-server-5.6 mysql-server/root_password password toor" | debconf-set-selections
RUN echo "mysql-server-5.6 mysql-server/root_password_again password toor" | debconf-set-selections
RUN apt-get install -y mysql-client mysql-server
RUN apt-get install -y php libapache2-mod-php php-mysql
RUN apt-get install -y apache2

### USER CREATE ###
RUN useradd slave -m -s /bin/bash
RUN echo "slave:slave" |chpasswd slave
RUN echo "root:root" |chpasswd

### HOME DIR SETTING ###
RUN chown -R root:slave /home/slave

### APM SETTING ###
RUN echo \\n\\nServerName localhost >> /etc/apache2/apache2.conf
RUN service apache2 restart
RUN mkdir /var/run/sshd

### XINETD SETTING ###
RUN mkdir /var/run/hi
RUN wget https://raw.github.com/hellochoki/xinetd_1/master/hi_
RUN chmod 777 hi_
RUN mv ./hi_ /var/run/hi/.

RUN cd /etc/xinetd.d
RUN wget https://raw.github.com/hellochoki/xinetd_1/master/hi
RUN mv ./hi /etc/xinetd.d/.

RUN cd /etc
RUN echo "hi 7778/tcp" >> /etc/services

RUN cd /etc/init.d
RUN /etc/init.d/xinetd restart

### ETC SETTING ###
EXPOSE 22 
EXPOSE 80
EXPOSE 7778
ADD ./start.sh /start.sh
ENTRYPOINT service apache2 restart && service mysql restart && service ssh restart
ENTRYPOINT service ssh restart && bash
ENTRYPOINT /start.sh
