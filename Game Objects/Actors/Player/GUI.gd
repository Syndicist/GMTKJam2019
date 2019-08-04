extends Control

signal hit_zero;

var current_light = 0.0;

func _on_Player_hp_changed(hp):
	$HealthBar.value += hp;
	if($HealthBar.value > 100):
		$HealthBar.value = 100;
	if($HealthBar.value <= 0):
		emit_signal("hit_zero");

func _on_Player_light_changed(light):
	current_light += light/10;
	if(current_light < 255):
		$LightIndicator/LightIndicator.modulate.a = current_light/255.0;
	if(current_light > 100 && $LightIndicator/LightIndicator.scale.x < 3):
		$LightIndicator/LightIndicator.scale = Vector2(current_light,current_light)/100;

func _on_Player_stamina_changed(stam):
	$StamBar.value = stam;
