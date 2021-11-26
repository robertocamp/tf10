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
   - standard create
   - mysql free tier
   - db instance identifier: wordpress_demo1 (use for all name/creds etc just for the demo --this instance won't have real data)
2. ec2: ubuntu20
  - i-0857b321c764c1a06
  - `ssh -i "JULY23-CONSOLE.pem" ubuntu@ec2-3-144-177-188.us-east-2.compute.amazonaws.com`
  - `sudo apt update -y`
  - `sudo apt install apache2 libapache2-mod-php php-mysql -y`
  - *additional installation packages which might not be strictly necessary:*
  - `sudo apt update`
  - `sudo apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip`
  - restart apache2:  `sudo systemctl restart apache2`
3.  host firewall configuration
  - `sudo ufw app list`
  - `sudo ufw allow in "Apache"`
  - `sudo ufw status`  

4. Adjusting Apache’s Configuration to Allow for .htaccess Overrides and Rewrites:
  - `sudo nano /etc/apache2/sites-available/wordpress.conf`
  -
    ```
    <Directory /var/www/wordpress/>
        AllowOverride All
      </Directory>
    ```
  -  enable mod_rewrite so that we can utilize the WordPress permalink feature:
  - `sudo a2enmod rewrite`
  - `systemctl restart apache2`

5. download WordPress and setup files:
  - `curl -O https://wordpress.org/latest.tar.gz`
  - `tar xzvf latest.tar.gz`
  - add a dummy .htaccess file so that this will be available for WordPress to use later:
  - `touch wordpress/.htaccess`
  - copy over the sample configuration file to the filename that WordPress reads:
  - `cp wordpress/wp-config-sample.php wordpress/wp-config.php`
  - create the upgrade directory, so that WordPress won’t run into permissions issues when trying to do this on its own following an update to its software:
  -  `mkdir wordpress/wp-content/upgrade`
  - copy the entire contents of the directory into our document root. 
  - We are using a dot at the end of our source directory to indicate that everything within the directory should be copied, including hidden files (like the .htaccess file we created):
  - sudo mkdir /var/www/wordpress && cp -a wordpress/. /var/www/wordpress

6. WordPress file permissions
  - An important step that we need to accomplish is setting up reasonable file permissions and ownership.
  - We’ll start by giving ownership of all the files to the www-data user and group.
  - This is the user that the Apache web server runs as
  - Apache will need to be able to read and write WordPress files in order to serve the website and perform automatic updates.
  - `sudo chown -R www-data:www-data /var/www/wordpress`
  - Next we’ll run two find commands to set the correct permissions on the WordPress directories and files:
  - `sudo find /var/www/wordpress/ -type d -exec chmod 750 {}`
  - `sudo find /var/www/wordpress/ -type f -exec chmod 640 {}`


7. WordPress Configuration file: modifications
  1. keys
  2. db name settings
  3. RDS endpoint
  - `curl -s https://api.wordpress.org/secret-key/1.1/salt/`
  - copy these keys to a safe location ; you will use them in the confguration file for WordPress
  - `sudo nano /var/www/wordpress/wp-config.php`
  - add the keys created with the 'salt' command ;
  - then modify these directives in the file with the value you are usign for db name etc: wordpressdemo1

  ```
  define( 'DB_NAME', 'wordpressdemo1' );
  define( 'DB_USER', 'wordpressdemo1' );
  define( 'DB_PASSWORD', 'wordpressdemo1' );
  ```


  5. cd /var/www

  ## Links
  https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-20-04
  https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-20-04
  https://www.linode.com/docs/guides/how-to-install-wordpress-ubuntu-2004/
  https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-on-ubuntu-20-04-with-a-lamp-stack

