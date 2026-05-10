extends CharacterBody2D

var item_scenes = {
	"apple": preload("res://scene/item_view/apple.tscn"),
	"carrot": preload("res://scene/item_view/carrot.tscn"),
	"tree": preload("res://scene/item_view/tree.tscn")
}

var inventory_scenes = {
	"carrot": preload("res://scene/inventory/carrot.tscn"),
	"empty": preload("res://scene/inventory/empty.tscn"),
}

@export var carrot_item_scene:PackedScene
@onready var inventory_node = $Control/inventory/inventory
signal ready_to_take
signal exclude_to_take

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var isopen_inventory = false
var inventory = []
var cantake_vegetables = []

func _enter_tree() -> void:
	await get_tree().create_timer(0.1).timeout
	for i in range(inventory.size()):
		if inventory[i] == "empty":
			continue
		else:
			if inventory[i] in inventory_scenes:
				var inventory_scene_instantiate = inventory_scenes[inventory[i]].instantiate()
				inventory_node.add_child(inventory_scene_instantiate)
			else:
				var empty_instantiate = inventory_scenes["empty"].instantiate()
				inventory_node.add_child(empty_instantiate)

func _ready() -> void:
	ready_to_take.connect(cantake)
	exclude_to_take.connect(exclude_take)
	$save_load/save.pressed.connect($"/root/game".save_game)
	$save_load/load.pressed.connect($"/root/game".load_game)
	
	inventory.resize(50)
	inventory.fill("empty")
func _physics_process(delta: float) -> void:

	if Input.is_action_just_pressed("interact"):
		print(cantake_vegetables)
		var bodies = $Area2D.get_overlapping_areas()
		for body in bodies:
			print(body.self_name)
			if body.is_in_group("vegetables"):
				for i in range(inventory.size()):
					if inventory[i] == "empty":
						inventory[i] = body.self_name
						if body.self_name in inventory_scenes:
							var inventory_scene_instantiate = inventory_scenes[body.self_name].instantiate()
							inventory_node.add_child(inventory_scene_instantiate)
						else:
							var empty_instantiate = inventory_scenes["empty"].instantiate()
							inventory_node.add_child(empty_instantiate)
						body.queue_free()
						print(inventory)
						exclude_cantake_vegetables(body.self_name)
						break
				break
	if Input.is_action_just_pressed("openinventory"):
		if isopen_inventory:
			$Control/inventory.hide()
			isopen_inventory = false
		else:
			$Control/inventory.show()
			isopen_inventory = true
	var direction := Input.get_axis("move_left", "move_right")
	var updown_direction := Input.get_axis("move_up","move_down")
	if direction or updown_direction:
		velocity.x = direction * SPEED
		velocity.y = updown_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func exclude_take(objects):
	cantake_vegetables.erase(objects)
	exclude_cantake_vegetables(objects)

func cantake(objects):
	cantake_vegetables.append(objects)
	add_cantake_vegetables(objects)

func add_cantake_vegetables(obj):
	var item_instantiate = item_scenes[obj].instantiate()
	$Control/cantake.add_child(item_instantiate)
	item_instantiate.name = obj
	print(cantake_vegetables)
func exclude_cantake_vegetables(obj):
	for cantakeobj in $Control/cantake.get_children():
		print(cantakeobj.name)
		if obj in cantakeobj.name:
			cantakeobj.queue_free()
			print(cantake_vegetables)
			return

func save():
	var save_dict = {
		"filename":get_scene_file_path(),
		"pos_x":global_position.x,
		"pos_y":global_position.y,
		"seed":Global.seed,
		"inventory":inventory
	}
	return save_dict
	
