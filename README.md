# tf10

## Git stuff
echo "# tf10" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:robertocamp/tf10.git
git push -u origin main

## WordPress creation via console
1. RDS: mysql
  1. standard create
  2. mysql free tier
  3. db instance identifier: wordpress_demo1 (use for all name/creds etc just for the demo --this instance won't have real data)
2. ec2: ubuntu20
  1. i-0857b321c764c1a06
  2. `ssh -i "JULY23-CONSOLE.pem" ubuntu@ec2-3-144-177-188.us-east-2.compute.amazonaws.com`
  3. `sudo apt update -y`
  4. `sudo apt install apache2 libapache2-mod-php php-mysql -y`
    1. additional installation packages which might not be strictly necessary:
    2. `sudo apt update`
    3. `sudo apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip`
  5. restart apache2:  `sudo systemctl restart apache2`
  6. host firewall configuration
    1. `sudo ufw app list`
    2. `sudo ufw allow in "Apache"`
    3. `sudo ufw status`


  7. Adjusting Apache’s Configuration to Allow for .htaccess Overrides and Rewrites:
    1. `sudo nano /etc/apache2/sites-available/wordpress.conf`
    2. 
    ```
    <Directory /var/www/wordpress/>
        AllowOverride All
      </Directory>
    ```
    3. enable mod_rewrite so that we can utilize the WordPress permalink feature:
    4. `sudo a2enmod rewrite`
    5. `systemctl restart apache2`
  8. download WordPress and setup files:
    1.  `curl -O https://wordpress.org/latest.tar.gz`
    2. `tar xzvf latest.tar.gz`
    3. add a dummy .htaccess file so that this will be available for WordPress to use later:
    4. `touch wordpress/.htaccess`
    5.  copy over the sample configuration file to the filename that WordPress reads:
    6. `cp wordpress/wp-config-sample.php wordpress/wp-config.php`
    7.  create the upgrade directory, so that WordPress won’t run into permissions issues when trying to do this on its own following an update to its software:
    8. `mkdir wordpress/wp-content/upgrade`
    9. copy the entire contents of the directory into our document root. We are using a dot at the end of our source directory to indicate that everything within the directory should be copied, including hidden files (like the .htaccess file we created):
    10. sudo mkdir /var/www/wordpress && cp -a wordpress/. /var/www/wordpress
  9. WordPress file permissions
    1. An important step that we need to accomplish is setting up reasonable file permissions and ownership.
       - We’ll start by giving ownership of all the files to the www-data user and group.
       - This is the user that the Apache web server runs as
       - Apache will need to be able to read and write WordPress files in order to serve the website and perform automatic updates.
       - `sudo chown -R www-data:www-data /var/www/wordpress`









  5. cd /var/www

  ## Links
  https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-20-04
  https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-20-04
  https://www.linode.com/docs/guides/how-to-install-wordpress-ubuntu-2004/
  https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-on-ubuntu-20-04-with-a-lamp-stack

