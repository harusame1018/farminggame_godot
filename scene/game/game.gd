extends Node2D

var load_count = 0
var grid = []
var ponds = {
	0: [
		[1,1,1,1,1,1],
		[1,1,0,0,1,1],
		[1,0,0,0,0,1],
		[0,0,0,0,0,0],
		[1,1,0,0,0,1]
	],
	1: [
		[1,0,0,0,1,1],
		[0,0,0,0,0,0],
		[1,0,0,0,0,0],
		[1,1,0,0,1,1],
		[1,1,1,1,1,1]
	],
	2: [
		[0,0,1,1,0,1],
		[0,0,0,0,0,0],
		[1,1,0,0,0,1],
		[0,1,1,1,1,1]
	],
	3: [
		[0,1,0,1,0,0],
		[0,0,0,0,0,0],
		[1,1,0,0,0,1],
		[0,1,1,0,1,0]
	]
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
func _process(delta: float) -> void:
	pass
func _enter_tree() -> void:
	init_game()
func init_game():
	seed(Global.seed)
	print(Global.seed)
	grid = []
	for y in range(128):
		grid.append([])
		for x in range(128):
			grid[y].append(1)
	for tree in range(60):
		var tree_pos = Vector2i(randi_range(0,grid[0].size() - 1),randi_range(0,grid.size() - 1))
		print(tree_pos)
		grid[tree_pos.y][tree_pos.x] = 2
	var number_of_pond = int(randi_range(1,grid[0].size() / ponds[0].size()))
	print(number_of_pond)
	for i in range(number_of_pond):
		var j = randi_range(1,ponds.size() - 1)
		print(j)
		var pond_pos = Vector2i(clamp(randi_range(0,grid.size()),0,grid.size() - (ponds[j][0].size() + 1)),clamp(randi_range(0,grid[0].size()),0,grid[0].size() - (ponds[j].size() + 1)))
		for ponds_y in range(ponds[j].size()):
			for ponds_x in range(ponds[j][ponds_y].size()):
				var gy = pond_pos.y + ponds_y
				var gx = pond_pos.x + ponds_x
				if gy <= grid.size() and gx <= grid[0].size() and ponds_y <= ponds[j].size() and ponds_x <= ponds[j][ponds_y].size():
					grid[gy][gx] = ponds[j][ponds_y][ponds_x]
	for map_y in range(grid.size()):
		for map_x in range(grid[map_y].size()):
			var cell_pos = Vector2i(map_x,map_y)
			match grid[map_y][map_x]:
				0:
					$ground.set_cell(cell_pos,1,Vector2i(1,0))
				1:
					$ground.set_cell(cell_pos,1,Vector2i(0,0))
				2:
					$ground.set_cell(cell_pos,1,Vector2i(0,0))
					$tree.set_cell(cell_pos,0,Vector2i(0,0))
func save_game():
	var save_file = FileAccess.open("user://savegame.save",FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("persist")
	for node in save_nodes:
		if node.scene_file_path.is_empty():
			continue
		if !node.has_method("save"):
			continue
		var node_data = node.call("save")
		var json_string = JSON.stringify(node_data)
		save_file.store_line(json_string)



func load_game():
	load_count = 0
	if not FileAccess.file_exists("user://savegame.save"):
		return
	var save_nodes = get_tree().get_nodes_in_group("persist")
	for i in save_nodes:
		i.queue_free()
	var save_file = FileAccess.open("user://savegame.save",FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		var json = JSON.new()
		
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			continue
		var node_data = json.data
		print(typeof(node_data))
		var new_objects = load(node_data["filename"]).instantiate()
		add_child(new_objects)
		new_objects.global_position = Vector2(node_data["pos_x"],node_data["pos_y"])
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_objects.set(i,node_data[i])
		if "is_growing" in node_data and "growing_time" in node_data:
			new_objects.is_growing = node_data["is_growing"]
			new_objects.growing_time = node_data["growing_time"]
		if "seed" in node_data:
			Global.seed = int(node_data["seed"])
			seed(int(node_data["seed"]))
			if load_count == 0:
				init_game()
				load_count += 1
			continue
		
		
