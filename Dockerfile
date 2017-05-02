FROM php:5.4.45-apache

################################################################################
# Paramétrage de Apache
################################################################################

# Activation des modules Apache
RUN \
    a2enmod rewrite

################################################################################
# Installation des dépendances relatives au projet experf
################################################################################

RUN \
    apt-get -qq update --fix-missing && \
    apt-get -qq install -y build-essential \
        wget \
        libxrender-dev \
        libicu-dev \
        zip \
        unzip \
        vim \
        curl \
        xvfb \
        wkhtmltopdf \
        libpng-dev

RUN \
    docker-php-ext-install mysqli pdo pdo_mysql mbstring intl gd

WORKDIR /var/www/html

################################################################################
# Installation de composer
################################################################################

RUN \
    wget https://raw.githubusercontent.com/composer/getcomposer.org/a309e1d89ded6919935a842faeaed8e888fbfe37/web/installer -O - -q | php -- --quiet

################################################################################
# Suppression des fichiers temporaires.
################################################################################

RUN \
    apt-get -qq clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

################################################################################
# Autorisations sur les répertoires caches et log.
################################################################################

RUN \
    mkdir -p /var/www/html/app/cache && \
    mkdir -p /var/www/html/app/logs && \
    chown -R www-data:www-data /var/www/html/app/cache && \
    chown -R www-data:www-data /var/www/html/app/logs

################################################################################
# Autorisations sur le répertoire composer
################################################################################

RUN \
    mkdir -p /.composer && \
    chown -R www-data:www-data /.composer

################################################################################
# Configuration de wkhtmltopdf
################################################################################

COPY wkhtmltopdf.sh /usr/bin/

RUN chmod +x /usr/bin/wkhtmltopdf.sh

################################################################################
# Installation de git
################################################################################

RUN \
    apt-get -qq update --fix-missing && \
    apt-get -qq install git
