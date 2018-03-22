/// @description this function is called when the match starts

//if it's the host, ask to submit a sentence
if(global.pn_hosting)
{
	instance_create_depth(500,60,depth,obj_choose_sentence);
}
//if it's a player stop waiting, the game is started
else
{
	with(obj_wait) 
		instance_destroy();
		
	instance_create_depth(500,60,depth,obj_player);
		
}