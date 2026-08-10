extends Control

@onready var play_button = $PlayButton
@onready var game_scene = "res://scenes/level.tscn"

func _ready() -> void:
	play_button.connect("pressed", start_game)
	
func start_game() -> void:
	get_tree().change_scene_to_file(game_scene)
