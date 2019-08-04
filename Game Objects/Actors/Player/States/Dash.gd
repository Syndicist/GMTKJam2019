extends "./State.gd"

onready var ledge_cast = host.get_node("ledge_cast_right");

var wasnt_wall = false;
var is_wall = false;
var animate = false;
var look_for_ledge = false;
var attack = false;
var hit = false;

func enter():
	host.move_state = 'dash';
	host.grav_activated = false;
	boost();
	.enter();

func handleAnimation():
	.handleAnimation();
	if(animate):
		host.animate(host.get_node("anim"),"dash", true);
		animate = false;

func handleInput():
	.handleInput();
	if(get_dash_just_pressed()):
		boost();
		return;
	
	if(look_for_ledge):
		if(host.Direction == 1):
			ledge_cast = host.get_node("ledge_cast_right");
		if(host.Direction == -1):
			ledge_cast = host.get_node("ledge_cast_left");
		
		if(ledge_cast.is_colliding()):
			ledge_grab.ledge_cast = ledge_cast;
			exit(ledge_grab);
			return;

func exit(state):
	host.get_node("Sprites").rotation_degrees = 0;
	wasnt_wall = false;
	is_wall = false;
	animate = false;
	look_for_ledge = false;
	$dashTimer.stop();
	$ledgeTimer.stop();
	host.grav_activated = true;
	.exit(state);

func boost():
	host.change_stamina(-20);
	var input_direction = get_input_direction();
	update_look_direction_and_scale(input_direction);
	
	if(input_direction == -1):
		host.get_node("Sprites").rotation_degrees = host.deg + 180;
	else:
		host.get_node("Sprites").rotation_degrees = host.deg;
	animate = true;

func _on_dashTimer_timeout():
	exit(idle);

func _on_iTimer_timeout():
	host.get_node("Hitbox").iframe = false;

func attack():
	attack = true;
	host.animate(host.get_node("anim"),"attack", true);

func _on_ledgeTimer_timeout():
	look_for_ledge = true;

func on_hit(area):
	if(area.hittable):
		if(abs(area.host.hitpoints) >= 1.5 * area.host.max_hp):
			host.emit_signal("hp_changed", 20);
			host.change_stamina(20);
			host.change_light(abs(area.host.hitpoints) - .5 * area.host.max_hp);
		elif(area.host.hitpoints <= 0):
			host.change_stamina(10);
			host.change_light(1);
		if(area.one_hit):
			host.change_light(20);
		if(area.host.tag == "Dummy"):
			host.change_stamina(20);
			host.change_light(200);
		host.get_node("Camera2D").shake(.1, 15, 8);
		hit = true;