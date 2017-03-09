FROM php:7.1-fpm

RUN	apt-get update && \
	apt-get install -y wget nano mariadb-client-10.0 openssh-client git && \
	apt-get install -y --no-install-recommends nfs-kernel-server nfs-common netbase && \
	apt-get clean

ENV	TERM="xterm"

RUN	apt-get update && \
	apt-get install -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libmcrypt-dev \
		libpng12-dev \
		libxml2-dev \
		xml-core \
		mcrypt \
		libbz2-dev \
		libmcrypt-dev \
		bzip2 \
		libtidy-dev \
		libcurl4-openssl-dev \
		libssl-dev \
		libpq-dev \
		libxslt-dev \
		libsqlite3-dev \
		libc-client2007e-dev \
		libkrb5-dev \
		zlib1g-dev \
		libicu-dev \
		g++ \
		&& \
	apt-get clean && \
	pecl install apcu-5.1.7 && \
	docker-php-ext-enable apcu && \
	docker-php-ext-install \
		iconv \
		mcrypt \
		soap \
		bcmath \
		mbstring \
		bz2 \
		calendar \
		gettext \
		opcache \
		wddx \
		mysqli \
		pgsql \
		pdo_mysql \
		pdo_pgsql \
		pdo_sqlite \
		phar \
		tidy \
		exif \
		sysvmsg \
		sysvsem \
		sysvshm \
		sockets \
		zip \
		xsl \
		&& \
	docker-php-ext-configure intl && \
	docker-php-ext-configure imap --with-imap-ssl --with-kerberos && \
	docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
	docker-php-ext-install gd imap intl

RUN	mkdir -p /home/www-data && \
	chown www-data:www-data -R /home/www-data

ENV	PHP_CONF="/usr/local/etc/php/conf.d"
ENV	PHP_FPM_CONF="/usr/local/etc/php-fpm.d/www.conf"
ENV	PHP_EXTRA_CONFIGURE_ARGS="--enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data"

ADD	Config/php.ini/php.ini "$PHP_CONF/php.ini"

RUN	mkdir -p /var/log/php-fpm && \
	ln -sf /dev/stderr /var/log/php-fpm/error.log && \
	ln -sf /dev/stdout /var/log/php-fpm/access.log && \
	sed -i -e '/^listen/c listen = 9000' \
		-e '/^error_log/c error_log  = /var/log/php-fpm/error.log' \
		-e '/^access.log/c access.log  = /var/log/php-fpm/access.log' \
		-e '/^listen.allowed_clients/c;listen.allowed_clients =' \
		-e '/^pm.max_children/c pm.max_children = 30' \
		-e '/^pm.start_servers/c pm.start_servers = 5' \
		-e '/^pm.min_spare_servers/c pm.min_spare_servers = 5' \
		-e '/^pm.max_spare_servers/c pm.max_spare_servers = 30' \
		-e '/^user/c user = www-data' \
		-e '/^group/cgroup = www-data' $PHP_FPM_CONF && \
	rmdir /var/www/html

RUN	echo "export LS_OPTIONS='--color=auto'\n \
	alias ls='ls \$LS_OPTIONS'\n alias ll='ls \$LS_OPTIONS -l'\n \
	alias l='ls \$LS_OPTIONS -lA'\n alias rm='rm -i'\n alias cp='cp -i'\n alias mv='mv -i'" >> /root/.bashrc

ADD	Config/php.ini/opcache.ini /tmp/opcache.ini
RUN	cat /tmp/opcache.ini >> "${PHP_CONF}/docker-php-ext-opcache.ini"

EXPOSE	9000

ADD	Scripts/entrypoint.sh /entrypoint.sh

ENTRYPOINT	["/entrypoint.sh"]

WORKDIR	/var/www

CMD	["/usr/local/sbin/php-fpm", "-F"]
