extends Node2D

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
	]
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
func _process(delta: float) -> void:
	pass
func _enter_tree() -> void:
	seed(Global.seed)
	init_game()
func init_game():
	for y in range(32):
		grid.append([])
		for x in range(32):
			grid[y].append(1)
	print(grid)
	var number_of_pond = int(randi_range(1,ponds.size()))
	print(number_of_pond)
	for i in range(number_of_pond):
		var pond_pos = Vector2i(clamp(randi_range(0,grid.size()),0,grid.size() - (ponds[i][0].size() + 1)),clamp(randi_range(0,grid[0].size()),0,grid[0].size() - (ponds[i].size() + 1)))
		print(pond_pos)
		for ponds_y in range(ponds[i].size()):
			for ponds_x in range(ponds[i][ponds_y].size()):
				var gy = pond_pos.y + ponds_y
				var gx = pond_pos.x + ponds_x
				grid[gy][gx] = ponds[i][ponds_y][ponds_x]
	for map_y in range(grid.size()):
		for map_x in range(grid[map_y].size()):
			print(map_y,",",map_x)
			var cell_pos = Vector2i(map_x,map_y)
			match grid[map_y][map_x]:
				0:
					$ground.set_cell(cell_pos,1,Vector2i(1,0))
				1:
					$ground.set_cell(cell_pos,1,Vector2i(0,0))
			print(cell_pos)
	print(grid)
