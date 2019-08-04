extends "./State.gd"

var climb = false;
var hstop = false;
var stickVar = 5;
var ledge_cast;
var played = false;

func enter():
	host.move_state = 'ledge_grab';
	host.grav_activated = false;
	host.hspd = 0;
	host.vspd = 0;
	pass

func handleAnimation():
	.handleAnimation();
	#if(!played):
	host.animate(host.get_node("anim"),"ledge_grab", false);

func handleInput():
	if(get_dash_just_pressed()):
		exit(dash);
		return;
	pass

func execute(delta):
	#Snap to ledge side
	if(host.is_on_wall()):
		hstop = true;
	if(!host.test_move(host.transform, Vector2(1 * host.Direction,0)) && !hstop):
		host.position.x += stickVar * host.Direction;
		stickVar -= 1;
	else:
		hstop = true;
	pass

func exit(state):
	host.grav_activated = true;
	hstop = false;
	played = false;
	stickVar = 5;
	climb = false;
	.exit(state);
	pass

func done_ledge_grab():
	played = true;