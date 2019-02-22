FROM lizhenliang/tomcat 
MAINTAINER www.ctnrs.com
ENV PATH $PATH:/usr/local/tomcat/bin
ADD target/*.war /usr/local/tomcat/webapps/ROOT.war 
