extends "./State.gd"

func enter():
	host.move_state = 'hurt';
	.enter();

func handleAnimation():
	.handleAnimation();
	host.animate(host.get_node("anim"),"hurt", false);

var decceleration = 20;

func execute(delta):
	.execute(delta);
	var input_direction = get_input_direction();
	host.hspd = -200 * host.Direction;

func exit(state):
	.exit(state);