extends "res://Game Objects/Actors/Enemies/Enemy_State.gd"

func enter():
	host.state = 'chase';
	pass;

func handleAnimation():
	if(!host.on_floor()):
		host.animate(host.get_node("animator"),"fall", false);
	elif(host.hspd != 0):
		host.animate(host.get_node("animator"),"ready_move", false);
	else:
		host.animate(host.get_node("animator"),"ready", false);
	pass;

func handleInput(event):
	#if(host.global_position.distance_to(player.global_position) <= host.attack_range):
	#	host.hspd = 0;
	#	host.velocity.x = 0;
	#	exit('attack');
	if(!host.canSeePlayer()):
		exit('default');
	pass;

func execute(delta):
	if(host.player.global_position.x > host.global_position.x):
		if(host.Direction != 1):
			turn_around();
	elif(host.player.global_position.x < host.global_position.x):
		if(host.Direction != -1):
			turn_around();
	
	host.hspd = host.mspd * host.Direction;
	pass