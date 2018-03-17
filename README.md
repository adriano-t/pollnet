PollNet
=====================
Http multiplayer game library for GMStudio2


## Configuration
Open config.php and edit the following fields
```php
$dbusername = "tizsoft"; // your username
$password = ""; // your mysql password
$host = "localhost";
$database = "my_tizsoft"; // database name

$update_interval = 3; //update interval in seconds
```
## Installation

* Upload all the php files on a directory of your website (e.g. http://yourwebsite.com/your/directory/)
* Open the url to install.php (e.g. http://yourwebsite.com/your/directory/install.php)
* done
  
## Import the extension in GMStudio2
* Create a new project
* Drag and drop extension.yymp  


## Import the extension in GMStudio2
* Open the pn_config script inside GMStudio2
* and change the following line, to your website url
`global.pn_website = "http://tizsoft.altervista.org/pollnet/";`


## Or open the example project
`./example/` directory

License
--------

    MIT LICENSE
