extends KinematicBody2D


var dir = Vector2(0,0)


const UP = Vector2(-sqrt(2.0)/2.0, -1/2.0)
const DOWN = Vector2(sqrt(2.0)/2.0, 1/2.0)
const LEFT = Vector2(-sqrt(2.0)/2.0, 1/2.0)
const RIGHT = Vector2(sqrt(2.0)/2.0, -1/2.0)

const SPEED = 75

func _ready():
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("ui_up"):
		dir = UP*SPEED
	elif Input.is_action_pressed("ui_down"):
		dir = DOWN*SPEED
	elif Input.is_action_pressed("ui_right"):
		dir = RIGHT*SPEED
	elif Input.is_action_pressed("ui_left"):
		dir = LEFT*SPEED
	else:
		dir = Vector2(0,0)
	
	move_and_slide(dir)
		
	pass
