FROM php:5.6.28-apache

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
        zip \
        unzip \
        vim \
        curl \
        xvfb \
        wkhtmltopdf

WORKDIR /var/www/html

################################################################################
# Installation de composer
################################################################################

RUN \
    wget https://raw.githubusercontent.com/composer/getcomposer.org/1b137f8bf6db3e79a38a5bc45324414a6b1f9df2/web/installer -O - -q | php -- --quiet

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
    mkdir -p /var/www/.composer && \
    chown -R www-data:www-data /var/www/.composer

################################################################################
# Configuration de wkhtmltopdf
################################################################################

COPY wkhtmltopdf.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/wkhtmltopdf.sh
