extends "res://Game Objects/Actors/Enemies/Enemy_State.gd"

func enter():
	host.state = 'hurt';
	$Damage_Timer.start();

func handleAnimation():
	host.animate(host.get_node("animator"),"hurt", false);

func handleInput(event):
	pass;

func execute(delta):
	if(abs(host.hspd) > 0):
		if(abs(host.hspd) < 2):
			host.hspd = 0;
		host.hspd -= 2 * sign(host.hspd);
	if(abs(host.vspd) > 0):
		if(abs(host.vspd) < 3):
			host.vspd = 0;
		host.vspd -= 3 * sign(host.vspd);

func exit(state):
	.exit(state)

func _on_Damage_Timer_timeout():
	exit('default');
	host.activate_fric();
	host.activate_grav();