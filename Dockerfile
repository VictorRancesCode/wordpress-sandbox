FROM wordpress:4.5.2-apache

RUN pecl install xdebug-beta \
    && docker-php-ext-enable xdebug \
	&& echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_connect_back=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.default_enable=0" >> /usr/local/etc/php/conf.d/xdebug.ini \
	&& echo "xdebug.coverage_enable=0" >> /usr/local/etc/php/conf.d/xdebug.ini

RUN a2enmod rewrite

ENV APACHE_RUN_USER wordpress
ENV APACHE_RUN_GROUP wordpress

RUN adduser --uid 1000 --disabled-password wordpress

RUN chown -R "$APACHE_RUN_USER:$APACHE_RUN_GROUP" /var/lock/apache2 /var/run/apache2

RUN sed -i '/Listen 80/c\Listen 8080' /etc/apache2/apache2.conf \
	&& sed -i '/User www-data/c\User wordpress' /etc/apache2/apache2.conf \
	&& sed -i '/Group www-data/c\Group wordpress' /etc/apache2/apache2.conf

EXPOSE 8080
