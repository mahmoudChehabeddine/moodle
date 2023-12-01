# Use the official Ubuntu 20.04 image
FROM ubuntu:20.04
 
# Update the package lists
RUN apt update
 
# Remove existing PHP installations
RUN apt-get purge $(dpkg -l | grep php| awk '{print $2}' | tr "\n" " ")
 
# Add PHP repository and update package lists
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN apt update
 
# Install PHP 8.0, PostgreSQL 13, and Apache with required modules
 
RUN apt-get install -y php
RUN apt-get install -y php-pgsql 
RUN apt-get install -y libapache2-mod-php
RUN apt-get install -y php-curl 
RUN apt-get install -y php-gd 
RUN apt-get install -y php-intl 
RUN apt-get install -y php-mysql 
RUN apt-get install -y php-xml 
RUN apt-get install -y php-xmlrpc 
RUN apt-get install -y php-ldap 
RUN apt-get install -y php-zip 
RUN apt-get install -y php-soap 
RUN apt-get install -y php-mbstring
 
# Restart Apache
RUN service apache2 restart

COPY . /var/www/html/moodle
 
# Copy Moodle files to Apache directory
#RUN cp -R /opt/moodle /var/www/html/
 
# Create Moodle data directory and set permissions
RUN mkdir /var/moodledata
RUN chown -R www-data /var/moodledata
RUN chmod -R 777 /var/moodledata
RUN chmod -R 777 /var/www/html/moodle
 

# Update PHP configuration
RUN echo "max_input_vars = 5000" >> /etc/php/8.1/apache2/php.ini
 
RUN service apache2 restart
 
 
# Expose ports
 
EXPOSE 80
 
# Start Apache in the foreground
 
CMD ["apache2ctl", "-D", "FOREGROUND"]
