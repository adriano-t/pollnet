PollNet v0.1
=====================
Http multiplayer game library for GMStudio2

Do the following steps in order.

## 1) PHP Configuration
Open config.php and edit the following fields
```php
$dbusername = "tizsoft"; // your username
$password = ""; // your mysql password
$host = "localhost";
$database = "my_tizsoft"; // database name

$update_interval = 3; //update interval in seconds
```
## 2) PHP Installation

* Upload all the php files on a directory of your website (e.g. `http://your_website.com/your_directory/`)
* Open the url to `install.php` (e.g. `http://your_website.com/your_directory/install.php`)
* done
  
## 3a) Import the extension in GMStudio2
* Create a new project
* Drag and drop the extension file (`pollnet_extension.yymp`) into GMStudio2

## 3b) Or open an example project
`./chatexample/` directory
`./hangman/` directory


## 4) GMStudio2 Configuration
* Open the `pn_config` script inside GMStudio2
* and change the following line, to your website pollnet directory url
`global.pn_website = "http://my-awesome-website.com/pollnet/";`

License
--------

    MIT LICENSE
