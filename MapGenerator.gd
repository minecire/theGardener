extends TileMap

const CHUNK_SIZE = 40;

var chunks = [];

var offset = Vector2(0, 1);

var noise = OpenSimplexNoise.new()
var rng = RandomNumberGenerator.new()

func _ready():
	for tile in tile_set.get_tiles_ids().size():
		tile_set.tile_set_texture_offset(tile, offset)
	set_as_toplevel(true);
	rng.randomize()
	noise.seed = 17
	noise.octaves = 4
	noise.period = 100.0
	noise.persistence = 0.8
	loadGame()
	genBox(0,0,1);

func setPos(x, y, chunkX, chunkY, type):
	var chunk
	for i in chunks:
		if int(i.coords.x) == chunkX and int(i.coords.y) == chunkY:
			chunk = i
	chunk.data[x][y] = type
	gen(chunkX, chunkY)

func genBox(x, y, s):
	for i in chunks:
		if(int(i.coords.x) < -s+x or int(i.coords.x) > s+x or int(i.coords.y) < -s+y or int(i.coords.y) > s+y):
			remove(i.coords.x, i.coords.y)
	for i in range(-s+x, s+1+x):
		for j in range(-s+y, s+1+y):
			gen(i, j)
#	saveGame()

func gen(x, y):
	var chunkData = []
	var exists = false
	for i in chunks:
		if int(i.coords.x) == x and int(i.coords.y) == y:
			chunkData = i.data
			exists = true
			break
	if !exists:
		for i in range(-floor(CHUNK_SIZE/2)+x*CHUNK_SIZE,floor(CHUNK_SIZE/2)+x*CHUNK_SIZE):
			var chunkLine = [];
			for j in range(-floor(CHUNK_SIZE/2)+y*CHUNK_SIZE, floor(CHUNK_SIZE/2)+y*CHUNK_SIZE):
				var type
				if noise.get_noise_2d(i, j) > -0.04:
					if rng.randf_range(0.0, 10.0) > 9:
						type = 0
					else:
						type = 1
				elif noise.get_noise_2d(i,j) > -0.07:
					type = 4
				elif (i+j) % 2 == 0:
					type = 2
				else:
					type = 3
				chunkLine.append(type);
				self.set_cell(i,j, type);
			chunkData.append(chunkLine);
		chunks.append({"coords":{"x":x, "y":y}, "data":chunkData})
	else:
		for i in range(-floor(CHUNK_SIZE/2)+x*CHUNK_SIZE,floor(CHUNK_SIZE/2)+x*CHUNK_SIZE):
			for j in range(-floor(CHUNK_SIZE/2)+y*CHUNK_SIZE, floor(CHUNK_SIZE/2)+y*CHUNK_SIZE):
				self.set_cell(i,j, chunkData[i-x*CHUNK_SIZE+floor(CHUNK_SIZE/2)][j-y*CHUNK_SIZE+floor(CHUNK_SIZE/2)])
				
func remove(x, y):
	for i in range(-floor(CHUNK_SIZE/2)+x*CHUNK_SIZE,floor(CHUNK_SIZE/2)+x*CHUNK_SIZE):
			for j in range(-floor(CHUNK_SIZE/2)+y*CHUNK_SIZE, floor(CHUNK_SIZE/2)+y*CHUNK_SIZE):
				self.set_cell(i,j, -1)
func saveGame():
	var saveFile = File.new();
	Directory.new().remove("WorldData.save");
	saveFile.open("WorldData.save", File.WRITE)
	for i in chunks:
		saveFile.store_line(to_json(i))
	saveFile.store_line("")
	saveFile.close()

func loadGame():
	var loadFile = File.new()
	loadFile.open("WorldData.save", File.READ)
	var line = loadFile.get_line()
	chunks = []
	while line != "":
		var data = parse_json(line)
		chunks.append(data)
		line = loadFile.get_line()
	loadFile.close()
