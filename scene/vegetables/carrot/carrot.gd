extends Area2D

@onready var sprite = $Carrot
@export var growing_image:Texture

var is_growing = false
var growing_time = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_growing:
		if growing_time > 20:
			is_growing = true
			sprite.texture = growing_image
		else:
			growing_time += delta
		
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and is_growing:
		body.emit_signal("ready_to_take","carrot")


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and is_growing:
		body.emit_signal("exclude_to_take","carrot")
func save():
	var save_dict = {
		"filename":get_scene_file_path(),
		"pos_x": global_position.x,
		"pos_y": global_position.y,
		"is_growing":is_growing,
		"growing_time":growing_time
	}
	return save_dict
