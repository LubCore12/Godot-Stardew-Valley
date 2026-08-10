extends StaticBody2D

var is_cutted := false

@onready var stump_texture = preload("res://graphics/plants/stump.png")

@export_group("Tree stats")
@export var tree_cut_limit: int

func cut() -> void:
	if tree_cut_limit > 0:
		tree_cut_limit -= 1
		var tween = create_tween()
		tween.tween_property($Sprite.material, "shader_parameter/flash_factor", 1.0, 0.2)
		tween.tween_property($Sprite.material, "shader_parameter/flash_factor", 0.0, 0.2)
	else:
		is_cutted = true
		$Sprite.texture = stump_texture
		$Sprite.hframes = 1
		$Shape.set_deferred("disabled", true)
		
