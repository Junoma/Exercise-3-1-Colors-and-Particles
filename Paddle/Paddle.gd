extends CharacterBody2D

var target = Vector2.ZERO
@export var speed = 10.0
var width = 0
var decay = 0.02

func _ready():
	width = $CollisionShape2D.get_shape().size.x
	target = Vector2(Global.VP.x / 2, Global.VP.y - width)

func _physics_process(_delta):
	target.x = clamp(target.x, 0, Global.VP.x - 2*width)
	position = target
	if $Highlight.modulate.a > 0:
		$Highlight.modulate.a -= decay

func _input(event):
	if event is InputEventMouseMotion:
		target.x += event.relative.x

func hit():
	$Highlight.modulate.a = 1.0
	$Confetti.emitting = true
	
	
	
