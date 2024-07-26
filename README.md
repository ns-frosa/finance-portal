# Finance-portal app 

This container has a web application that can be used to demonstrate private application access and browser access using our ZTNA solution. 

## The application supports: 
  - File uploads
  - File downloads
  - It contain files that match the common DLP classifiers

## Installation 

To install the application follow this process: 

1) Clone Github repository:
``` git clone https://github.com/ns-frosa/finance-portal.git ```
2) If you're using docker-compose:
```docker-compose up -d```
3) If you're using just Docker cli:
```
docker build finance-portal . 
docker run -d -p 8080:8080 finance-portal
```

The application will be publisher on port 8080 but you can change it in the docker-compose.yml file or in the docker run command. 
