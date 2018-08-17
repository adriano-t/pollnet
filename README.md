# PollNet v0.1
Http multiplayer game library for GMStudio2.
Pollnet is designed to create lobbies/chats, or turn based games and it's not suitable for realtime games.

## Table of contents

- [Installation](#installation) 
- [Usage](#usage)

	
## Installation

Do the following steps in order.

### 1) PHP Configuration
Open config.php and edit the following fields
```php
$dbusername = "tizsoft"; // your username
$password = ""; // your mysql password
$host = "localhost";
$database = "my_tizsoft"; // database name

$update_interval = 3; //update interval in seconds
```
### 2) PHP Installation

* Upload all the php files on a directory of your website (e.g. `http://your_website.com/your_directory/`)
* Open the url to `install.php` (e.g. `http://your_website.com/your_directory/install.php`)
* done
  
### 3a) Import the extension in GMStudio2
* Create a new project
* Drag and drop the extension file (`pollnet_extension.yymp`) into GMStudio2

### 3b) Or open an example project
`./chatexample/` directory
`./hangman/` directory


### 4) GMStudio2 Configuration
* Open the `pn_config` script inside GMStudio2
* and change the following line, to your website pollnet directory url
`global.pn_website = "http://my-awesome-website.com/pollnet/";`

## Usage

Instantiate `obj_pollnet` before calling any function

### Functions
* `pn_host` : create a new lobby
* `pn_game_start` : called by the host to start the game (use it when you reached the desired number of players in the lobby), since this moment, new players can't join the game
* `pn_join` : join an existing lobby
* `pn_request_games_list` : get all the online lobbies (created by other players)
* `pn_quit` : leave a lobby
* `pn_send` : send a message to one or all players (set the second parameter to `all`)
	example: `pn_send("health", all, 80)

### Events
All the scripts under `events` group are called when something happens

For example:

* `pn_on_host` is called when `pn_host` has success and you created a new lobby.
* `pn_on_join` is called when `pn_join` has success and you joined the lobby.

### Tips
* Create an object that lists all the available games online and allows to join
* Create a button to host a new game
* use `pn_send` to send messages with an id of your choice
* with `pn_send` you can send a `string` a `number` or an `array`
* inside the script `pn_on_receive` use a switch statement to handle the messages
* don't send too much data, this library uses HTTP connection / mysql database, to avoid performance issues.


# License

    MIT LICENSE
