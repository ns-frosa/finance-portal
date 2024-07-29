# Use the official PHP image with Apache
FROM php:7.4-apache

# Set working directory
WORKDIR /var/www/html

# Install cron
RUN apt-get update && apt-get install -y cron

# Copy the application files to the container
COPY app/ /var/www/html/

# Ensure the uploads directory exists and set permissions
RUN mkdir -p /var/www/html/uploads && \
    chown -R www-data:www-data /var/www/html/uploads && \
    chmod -R 755 /var/www/html/uploads

# Ensure /tmp directory has correct permissions
RUN chmod -R 1777 /tmp

# Set ServerName to localhost to suppress the warning
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Create the script to clean the uploads directory
RUN echo '#!/bin/bash\nrm -rf /var/www/html/uploads/*' > /usr/local/bin/clean_uploads.sh && chmod +x /usr/local/bin/clean_uploads.sh

# Add the cron job
RUN echo "0 * * * * /usr/local/bin/clean_uploads.sh" > /etc/cron.d/clean_uploads

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/clean_uploads

# Apply cron job
RUN crontab /etc/cron.d/clean_uploads

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Expose port 8080
EXPOSE 8080

# Update the default Apache site to listen on port 8080
RUN sed -i 's/80/8080/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Start Apache and cron in the foreground
CMD service apache2 start && cron && tail -f /var/log/cron.log
