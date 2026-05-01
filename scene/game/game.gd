extends Node2D

var grid = []
var ponds = {
	1: [
		[1,0,0,0,1,1],
		[0,0,0,0,0,0],
		[1,0,0,0,0,0],
		[1,1,0,0,1,1],
		[1,1,1,1,1,1]
	]
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for y in range(16):
		grid.append([])
		for x in range(16):
			grid[y].append(1) # 0〜9
			randomize()
	print(grid)
	
	var pond_pos = Vector2i(clamp(randi_range(0,grid.size()),0,grid.size() - (ponds[1][0].size() + 1)),clamp(randi_range(0,grid[0].size()),0,grid[0].size() - (ponds[1].size() + 1)))
	print(pond_pos)
	for pond_y in range(pond_pos.y, grid.size()):
		for pond_x in range(pond_pos.x,grid[0].size()):
			print("pond_x:", pond_x,",pond_y:",pond_y)
			for ponds_y in range(ponds[1].size()):
				for ponds_x in range(ponds[1][ponds_y].size()):
					var gy = pond_pos.y + ponds_y
					var gx = pond_pos.x + ponds_x
					grid[gy][gx] = ponds[1][ponds_y][ponds_x]
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

func _process(delta: float) -> void:
	pass
