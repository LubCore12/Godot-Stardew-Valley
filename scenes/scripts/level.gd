extends Node2D

@onready var grass_layer = $Objects/Layers/GrassLayer
@onready var water_layer = $Objects/Layers/WaterLayer
@onready var soil_layer = $Objects/Layers/SoilLayer
@onready var water_soil_layer = $Objects/Layers/WaterSoilLayer
@onready var slime_scene = preload("res://scenes/slime.tscn")
@onready var highlight = Sprite2D.new()

func _ready() -> void:
	highlight.texture = load("res://graphics/machines/projectile.png")
	$Objects.add_child(highlight)

func _process(delta: float) -> void:
	highlight.position = $Objects/Player.get_grid_pos() * 16 + Vector2i(8, 8)

func _on_player_tool_use(tool: int, pos: Vector2, tile_pos: Vector2i) -> void:
	match tool:
		Enum.Tool.AXE:
			for tree in get_tree().get_nodes_in_group("Trees"):
				if tree.position.distance_to(pos) < 20:
					print("axe")
		Enum.Tool.HOE:
			if grass_layer.get_cell_tile_data(tile_pos) and not soil_layer.get_cell_tile_data(tile_pos):
				var grass_tile = grass_layer.get_cell_tile_data(tile_pos) as TileData
				if grass_tile.get_custom_data("CanPlace"):
					soil_layer.set_cells_terrain_connect([tile_pos], 0, 0)
		Enum.Tool.WATER:
			if soil_layer.get_cell_tile_data(tile_pos) and not water_soil_layer.get_cell_tile_data(tile_pos):
				water_soil_layer.set_cells_terrain_connect([tile_pos], 0, 0)
		Enum.Tool.FISH:
			if water_layer.get_cell_tile_data(tile_pos):
				print("fish")
		Enum.Tool.SEED:
			if soil_layer.get_cell_tile_data(tile_pos):
				print("plant")
		Enum.Tool.SWORD:
			for slime in get_tree().get_nodes_in_group("Slimes"):
				if $Objects/Player.position.distance_to(slime.position) < 25:
					slime.discard_health(2.0)
					
					var tween = create_tween()
					slime = slime.get_node("Sprite")
					tween.tween_property(slime.material, "shader_parameter/flash_factor", 1.0, 0.2)
					tween.tween_property(slime.material, "shader_parameter/flash_factor", 0.0, 0.2)

func _on_slime_timer_timeout() -> void:
	var slime = slime_scene.instantiate()
	slime.setup($Objects/Player)
	slime.position = Vector2(randf_range(-100, 100), randf_range(-100, 100))
	$Objects/Slimes.add_child(slime)

func _on_player_damage(player: CharacterBody2D) -> void:
	$CanvasLayer/PlayerUI/TopLeftUI/HealthBar.value = player.health
