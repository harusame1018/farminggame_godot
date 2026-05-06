extends Area2D

var self_name = "apple"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.emit_signal("ready_to_take","apple")


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.emit_signal("exclude_to_take","apple")

func save():
	var save_dict = {
		"filename":get_scene_file_path(),
		"pos_x": global_position.x,
		"pos_y": global_position.y
	}
	return save_dict
