Use the official Ubuntu 20.04 images
FROM ubuntu:20.04
 
# Update the package lists
RUN apt update
 
# Remove existing PHP installations
RUN apt-get purge $(dpkg -l | grep php| awk '{print $2}' | tr "\n" " ")
 
# Add PHP repository and update package lists
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN apt update 
RUN apt-get install -y php8.0 
RUN apt-get install -y php8.0-pgsql 
RUN apt-get install -y libapache2-mod-php8.0 
RUN apt-get install -y php8.0-curl 
RUN apt-get install -y php8.0-gd 
RUN apt-get install -y php8.0-intl 
RUN apt-get install -y php8.0-mysql 
RUN apt-get install -y php8.0-xml 
RUN apt-get install -y php8.0-xmlrpc 
RUN apt-get install -y php8.0-ldap 
RUN apt-get install -y php8.0-zip 
RUN apt-get install -y php8.0-soap 
RUN apt-get install -y php8.0-mbstring
 
# Restart Apache
RUN service apache2 restart
 
COPY . /var/www/html/moodle

 
# Create Moodle data directory and set permissions
RUN mkdir /var/moodledata
RUN chown -R www-data /var/moodledata
RUN chmod -R 777 /var/moodledata
RUN chmod -R 777 /var/www/html/moodle
 
 
# Update PHP configuration
RUN echo "max_input_vars = 5000" >> /etc/php/8.0/apache2/php.ini
 
RUN service apache2 restart
 
 
# Expose ports
EXPOSE 80
 
# Start Apache in the foreground
CMD ["apache2ctl", "-D", "FOREGROUND"]
