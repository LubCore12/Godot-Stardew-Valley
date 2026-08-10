extends StaticBody2D

var grow_speed: float

func setup(plant_seed: Enum.Seed, pos: Vector2) -> void:
	var plant_data = Data.PLANT_DATA[plant_seed]
	$Sprite.texture = load(plant_data['texture'])
	$Sprite.hframes = plant_data["h_frames"]
	position = pos

func grow() -> void:
	$Sprite.frame = 0
