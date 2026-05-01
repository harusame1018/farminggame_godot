extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	if !$seed.text.is_empty():
		Global.seed = int($seed.text)
		call_deferred("go_game")
	else:
		Global.seed = int(randi())
		call_deferred("go_game")
func go_game():
	get_tree().change_scene_to_file("res://scene/game/game.tscn")
