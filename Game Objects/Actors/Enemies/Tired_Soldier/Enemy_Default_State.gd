extends "res://Game Objects/Actors/Enemies/Enemy_State.gd"

var halt = false;
var tspd = 0;

func enter():
	host.state = 'default';

func handleAnimation():
	if(!host.on_floor()):
		host.animate(host.get_node("animator"),"fall", false);
	elif(host.hspd != 0):
		host.animate(host.get_node("animator"),"walk", false);
	else:
		host.animate(host.get_node("animator"),"idle", false);

func handleInput(event):
	if(host.canSeePlayer()):
		exit('chase');

func execute(delta):
	if(1 <= host.decision && host.decision <= 40 && host.actionTimer.time_left <= 0.1):
		halt = false;
		if(host.Direction != -1):
			turn_around();
		go();
	elif(41 <= host.decision && host.decision <= 80 && host.actionTimer.time_left <= 0.1):
		halt = false;
		if(host.Direction != 1):
			turn_around();
		go();
	elif(host.actionTimer.time_left <= 0.1):
		halt = true;
		go();
	
	move();
	
	#TODO: create timer so they dont immediately turn towards the wall again.
	if(host.get_node("Casts").get_node("flip_cast").is_colliding()):
		turn_around();

func go():
	if(!halt):
		host.actionTimer.wait_time = host.wait;
		host.actionTimer.start();
		tspd = rand_range(host.mspd/10, host.mspd);
	else:
		host.actionTimer.wait_time = host.wait+1;
		host.actionTimer.start();
		tspd = 0;
	pass

func move():
	if(!halt):
		host.hspd = tspd * host.Direction;
		host.get_node("animator").playback_speed = abs(host.hspd/host.mspd);
	else:
		host.hspd = 0;
		host.get_node("animator").playback_speed = 1;
	pass

func exit(state):
	halt = false;
	tspd = 0;
	.exit(state)
	pass;