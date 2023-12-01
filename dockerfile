# Use the official Ubuntu 20.04 image
FROM ubuntu:20.04
 
# Install necessary packages
RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y apache2
RUN apt-get install -y git 
RUN apt-get install -y software-properties-common
RUN apt-get install -y postgresql
RUN apt-get install -y postgresql-contrib
RUN rm -rf /var/lib/apt/lists/*
 
# Add PHP repository
RUN add-apt-repository ppa:ondrej/php && apt-get update
 
# Install PHP 7.4 and required extensions
RUN apt-get install -y php7.4
RUN apt-get install -y php7.4-pgsql 
RUN apt-get install -y libapache2-mod-php7.4
RUN apt-get install -y graphviz
RUN apt-get install -y aspell
RUN apt-get install -y ghostscript
RUN apt-get install -y clamav
RUN apt-get install -y php7.4-pspell
RUN apt-get install -y php7.4-curl
RUN apt-get install -y php7.4-gd
RUN apt-get install -y php7.4-intl 
RUN apt-get install -y php7.4-mysql
RUN apt-get install -y php7.4-xml
RUN apt-get install -y php7.4-xmlrpc
RUN apt-get install -y php7.4-ldap
RUN apt-get install -y php7.4-zip
RUN apt-get install -y php7.4-soap
RUN apt-get install -y php7.4-mbstring 
RUN rm -rf /var/lib/apt/lists/*
 
# Enable Apache modules
RUN a2enmod rewrite
 
# Copy everything to /var/www/html/moodle
COPY . /var/www/html/moodle
 
# Create moodledata directory
RUN mkdir /var/moodledata && chown -R www-data /var/moodledata && chmod -R 777 /var/moodledata
 
# Fix deprecated string syntax
RUN find /var/www/html/moodle -type f -name '*.php' -exec sed -i 's/\${\([^}]*\)}/{$\1}/g' {} +

 RUN chmod -R 777 /var/www/html/moodle

# Restart Apache
RUN service apache2 restart
 
# Expose ports
EXPOSE 80
 
# Start Apache in the foreground
CMD ["apache2ctl", "-D", "FOREGROUND"]
