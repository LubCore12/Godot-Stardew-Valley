extends StaticBody2D

func setup(plant_seed: Enum.Seed, pos: Vector2) -> void:
	print(plant_seed)
	position = pos
	print("planted")

func grow() -> void:
	$Sprite.frame = 0
