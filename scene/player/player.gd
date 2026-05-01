extends CharacterBody2D

var item_scenes = {
	"apple": preload("res://scene/item_view/apple.tscn"),
	"carrot": preload("res://scene/item_view/carrot.tscn")
}

@export var carrot_item_scene:PackedScene
signal ready_to_take
signal exclude_to_take

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var inventory = []
var cantake_vegetables = []
func _ready() -> void:
	ready_to_take.connect(cantake)
	exclude_to_take.connect(exclude_take)
	
	inventory.resize(50)
	inventory.fill("empty")
func _physics_process(delta: float) -> void:

	if Input.is_action_just_pressed("interact"):
		print(cantake_vegetables)
		var bodies = $Area2D.get_overlapping_areas()
		for body in bodies:
			print(body.name)
			if body.name in cantake_vegetables:
				for i in range(inventory.size()):
					if inventory[i] == "empty":
						inventory[i] = body.name
						body.queue_free()
						print(inventory)
						break
				break

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
		if cantakeobj.name == obj:
			cantakeobj.queue_free()
			print(cantake_vegetables)
			return
