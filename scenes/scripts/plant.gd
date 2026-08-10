extends StaticBody2D

var grow_speed: float
var max_age: int
var age: float

func setup(plant_seed: Enum.Seed, pos: Vector2) -> void:
	var plant_data = Data.PLANT_DATA[plant_seed]
	$Sprite.texture = plant_data['texture']
	$Sprite.hframes = plant_data["h_frames"]
	grow_speed = plant_data["grow_speed"]
	max_age = plant_data["max_age"]
	position = pos

func grow(is_watered) -> void:
	if is_watered:
		age += grow_speed
		age = min(age, max_age)
		$Sprite.frame = age
