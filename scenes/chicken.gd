extends CharacterBody2D

## @onready var _animated_sprite = $AnimatedSprite2D

##func _process(_delta):
##  _animated_sprite.play("idle")
##	if Input.is_action_pressed("ui_right"):
##		_animated_sprite.play("run")
##	else:
##		_animated_sprite.stop()

func _ready():
	$AnimatedSprite2D.play("idle")
	pass
