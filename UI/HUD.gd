extends Control

@export var indicator_margin = Vector2(25, 15)
@export var indicator_index = 25
@onready var Indicator = load("res://UI/Indicator.tscn")
var indicator_scale = Vector2(1,1)


func _ready():
	update_score()
	update_time()
	update_lives()



func update_score():
	$Score.text = "Score: " + str(Global.score)

func update_time():
	$Time.text = "Time: " + str(Global.time)

func update_lives():
	var indicator_pos = Vector2(indicator_margin.x, Global.VP.y - indicator_margin.y)
	for i in $Indicator_Container.get_children():
		i.queue_free()
	for i in range(Global.lives):
		var indicator = Indicator.instantiate()
		indicator.position = Vector2(indicator_pos.x + i*indicator_index, indicator_pos.y)
		$Indicator_Container.add_child(indicator)
		breathe()

func breathe():
	indicator_scale = indicator_scale_target if indicator_scale == indicator_scale_start else indicator_scale_start
	indicator_mod = indicator_mod_target if indicator_mod == indicator_mod_start else indicator_mod_start
	if tween: 
		tween.kill()
	tween = get_tree().create_tween().set_parallel(true)
	for i in $Indicator_Container.get_children():
		tween.tween_property(i.get_node("Highlight"), "scale", indicator_scale, 0.5)
		tween.tween_property(i.get_node("Highlight"), "modulate:a", indicator_mod, 0.5)
	tween.set_parallel(false)
	tween.tween_callback(breathe)

func _on_Timer_timeout():
	Global.update_time(-1)
