extends "./State.gd"

onready var ledge_cast = host.get_node("ledge_cast_right");

var wasnt_wall = false;
var is_wall = false;


func enter():
	host.move_state = 'idle';
	.enter();

func handleAnimation():
	.handleAnimation();
	if(!dash.attack && host.on_floor()):
		host.animate(host.get_node("anim"),"idle", false);
	else:
		host.animate(host.get_node("anim"),"fall", false);

func handleInput():
	.handleInput();
	
	if(get_dash_just_pressed()):
		if(host.stamina > 0):
			exit(dash);
		return;
	
	if(host.Direction == 1):
		ledge_cast = host.get_node("ledge_cast_right");
	if(host.Direction == -1):
		ledge_cast = host.get_node("ledge_cast_left");
	
	if(!ledge_cast.is_colliding()):
		wasnt_wall = true;
	if(wasnt_wall && ledge_cast.is_colliding()):
		is_wall = true;
	else:
		is_wall = false;
	#print(String(wasnt_wall) + " " + String(is_wall) + " " + String($Ledgebox.get_overlapping_bodies().size()));
	if(wasnt_wall && is_wall):
		ledge_grab.ledge_cast = ledge_cast;
		exit(ledge_grab);
		return;

var decceleration = 20;

func execute(delta):
	.execute(delta);
	var input_direction = get_input_direction();
	update_look_direction_and_scale(input_direction);
	if(host.hspd != 0 && host.fric_activated):
		if(abs(host.hspd) <= decceleration):
			host.hspd = 0;
		else:
			host.hspd -= decceleration * sign(host.hspd);

func exit(state):
	wasnt_wall = false;
	is_wall = false;
	.exit(state);

