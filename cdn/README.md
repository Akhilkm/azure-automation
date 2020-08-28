# Azure CDN configuration for React application

#### Note: Configuring this rules requires the Azure CDN Verizon Premium tier

## Get customer origin in CDN and update rule.xml

![alt text](https://raw.githubusercontent.com/Akhilkm/azure-automation/master/cdn/customer-origin.png?raw=true)


## Configuring Azure CDN HTTP-HTTPS redirection

* From the Azure Portal Select the CDN profile
* Click on Manage to open the configuration page
* From the HTTP Large menu, select Rules Engine
* Update the Name / Description i.e. HTTP to HTTPS redirect
* Change the Always dropdown menu to Request Scheme
* Click the Features+ button and select URL Redirect
* Within the pattern text field enter **"(.*)"**
* In the Destination text field enter **"https://%{host}/$1"**
* Click Add

Rule can take up to 4 hours to become active.

## Configuring redirection to home page

* From the Azure Portal Select the CDN profile
* Click on Manage to open the configuration page
* From the HTTP Large menu, select Rules Engine
* Update the Name / Description i.e. home page redirect
* Keep the Always dropdown menu 
* Click the Features+ button and select URL Redirect
* Within the pattern text field enter **"[^?.]*(\?.*)?$"**
* In the Destination text field enter **"index.html"**
* Click Add

Rule can take up to 4 hours to become active.
