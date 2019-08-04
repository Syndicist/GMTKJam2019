extends Area2D

export(bool) var iframe = false;

func _on_Hitbox_area_entered(area):
	if(iframe && area.get_collision_layer_bit(3)):
		get_parent().get_node("Movement_States/Dash").attack();
	elif(!iframe && area.get_collision_layer_bit(4)):
		get_parent().emit_signal("hp_changed",-area.damage);
		get_parent().change_light(-area.damage);
		get_parent().move_states[get_parent().move_state].exit(get_parent().get_node("Movement_States/Hurt"));