tool
extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var offset = Vector2(0, 1);

# Called when the node enters the scene tree for the first time.
func _ready():
	for tile in tile_set.get_tiles_ids().size():
		tile_set.tile_set_texture_offset(tile, offset)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
