extends KinematicBody2D

onready var mapGen = $TileMap

var dir = Vector2(0,0)

var currentChunk = Vector2(0, 0);

const UP = -1
const DOWN = 1
const LEFT = -sqrt(2.0)
const RIGHT = sqrt(2.0)

const CDOWN = Vector2(1/2.0, sqrt(2.0)/2.0)
const CLEFT = Vector2(-1/2.0, sqrt(2.0)/2.0)

const SCALE_FACTOR = 12.0

var SCALE

const SPEED = 85

func _ready():
	set_process(true)

func _process(delta):
	SCALE = SCALE_FACTOR*mapGen.CHUNK_SIZE
	if Input.is_action_pressed("ui_up"):
		dir.y = UP*SPEED
	elif Input.is_action_pressed("ui_down"):
		dir.y = DOWN*SPEED
	else:
		dir.y = 0;
	if Input.is_action_pressed("ui_right"):
		dir.x = RIGHT*SPEED
	elif Input.is_action_pressed("ui_left"):
		dir.x = LEFT*SPEED
	else:
		dir.x = 0
	
	move_and_slide(dir)
	var pos = self.global_position
	pos.y += 12
	if(round(pos.dot(CDOWN)/SCALE) != currentChunk.x || round(pos.dot(CLEFT)/SCALE) != currentChunk.y):
		currentChunk.x = round(pos.dot(CDOWN)/SCALE)
		currentChunk.y = round(pos.dot(CLEFT)/SCALE)
		mapGen.genBox(currentChunk.x, currentChunk.y, 1)
		
	if Input.is_key_pressed(32):
		mapGen.setPos(floor(pmod(pos.dot(CDOWN)-SCALE/2.0, SCALE)/SCALE_FACTOR),
					  floor(pmod(pos.dot(CLEFT)-SCALE/2.0, SCALE)/SCALE_FACTOR),
					  currentChunk.x, currentChunk.y, 5)
	pass
func pmod(n, mod):
	return fmod(fmod(n, mod)+mod, mod)
