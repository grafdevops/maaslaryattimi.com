# Our Web Server Image :)
FROM grafclouds/centos7-web-server

# Other Required Files
COPY _devops/httpd.conf /etc/httpd/conf/httpd.conf
COPY _devops/run.sh /run.sh
 
RUN ["chmod", "+x", "/run.sh"]

#Copy Codes and Fix Permissions
RUN mkdir /source
COPY . /source 
RUN rsync -avzhHP --exclude '.git' --exclude '_devops' --exclude '.idea' --exclude 'Dockerfile' --exclude 'Jenkinsfile' --exclude '.htaccess' --exclude '.gitignore' /source/ /var/www/
RUN chown -R apache:apache /var/www/

#Cleanup
RUN yum clean all

#Docker Requirements
EXPOSE 80
ENTRYPOINT ["/run.sh"]
