extends Node2D

@onready var grass_layer = $Objects/Layers/GrassLayer
@onready var hill_layer = $Objects/Layers/HillLayer
@onready var water_layer = $Objects/Layers/WaterLayer
@onready var soil_layer = $Objects/Layers/SoilLayer
@onready var water_soil_layer = $Objects/Layers/WaterSoilLayer
@onready var slime_scene = preload("res://scenes/slime.tscn")
@onready var plant_scene = preload("res://scenes/plant.tscn")
@onready var highlight = $Objects/Highlight
@onready var player = $Objects/Player
@onready var slimes = $Objects/Slimes
@onready var plants = $Objects/Plants
@onready var UI = $CanvasLayer/PlayerUI

func _process(_delta: float) -> void:
	var grid_pos = player.get_grid_pos()
	var current_tool = player.current_tool
	var grass_tile = grass_layer.get_cell_tile_data(grid_pos) as TileData
	var soil_tile = soil_layer.get_cell_tile_data(grid_pos) as TileData
	var water_soil_tile = water_soil_layer.get_cell_tile_data(grid_pos) as TileData
	var hill_tile = hill_layer.get_cell_tile_data(grid_pos) as TileData
	
	highlight.hide()
	highlight.position = grid_pos * Data.TILE_SIZE + Data.TILE_HALF_VECTOR
	
	match current_tool:
		Enum.Tool.HOE:
			if grass_tile and not hill_tile \
			   and grass_tile.get_custom_data("CanPlace") and \
			   current_tool in [Enum.Tool.HOE, Enum.Tool.WATER, Enum.Tool.SEED]:
				highlight.show()
		Enum.Tool.WATER:
			if soil_tile and not water_soil_tile:
				highlight.show()
		Enum.Tool.SEED:
			var can_show = true
			for plant in plants.get_children():
				if soil_tile and Vector2i(plant.position) == grid_pos * Data.TILE_SIZE + Data.TILE_HALF_VECTOR:
					can_show = false
			highlight.visible = can_show

func _on_player_tool_use(tool: Enum.Tool, plant_seed: Enum.Seed, pos: Vector2, tile_pos: Vector2i) -> void:
	match tool:
		Enum.Tool.AXE:
			for tree in get_tree().get_nodes_in_group("Trees"):
				if tree.position.distance_to(pos) < 20:
					print("axe")
		Enum.Tool.HOE:
			var grass_tile = grass_layer.get_cell_tile_data(tile_pos) as TileData
			var soil_tile = soil_layer.get_cell_tile_data(tile_pos) as TileData
			var hill_tile = hill_layer.get_cell_tile_data(tile_pos) as TileData
			
			if grass_tile and not soil_tile and not hill_tile:
				if grass_tile.get_custom_data("CanPlace"):
					soil_layer.set_cells_terrain_connect([tile_pos], 0, 0)
		Enum.Tool.WATER:
			var soil_tile = soil_layer.get_cell_tile_data(tile_pos) as TileData
			var water_soil_tile = water_soil_layer.get_cell_tile_data(tile_pos) as TileData
			
			if soil_tile and not water_soil_tile:
				water_soil_layer.set_cells_terrain_connect([tile_pos], 0, 0)
		Enum.Tool.FISH:
			if water_layer.get_cell_tile_data(tile_pos):
				print("fish")
		Enum.Tool.SEED:
			if soil_layer.get_cell_tile_data(tile_pos):
				var plant = plant_scene.instantiate()
				plant.setup(plant_seed, tile_pos * Data.TILE_SIZE + Data.TILE_HALF_VECTOR)
				plants.add_child(plant)
				print("plant")
		Enum.Tool.SWORD:
			for slime in get_tree().get_nodes_in_group("Slimes"):
				if player.position.distance_to(slime.position) < 25:
					slime.discard_health(2.0)
					
					var tween = create_tween()
					slime = slime.get_node("Sprite")
					tween.tween_property(slime.material, "shader_parameter/flash_factor", 1.0, 0.2)
					tween.tween_property(slime.material, "shader_parameter/flash_factor", 0.0, 0.2)

func _on_slime_timer_timeout() -> void:
	var slime = slime_scene.instantiate()
	slime.setup(player)
	slime.position = Vector2(randf_range(-100, 100), randf_range(-100, 100))
	slimes.add_child(slime)

func _on_player_damage(damage: float) -> void:
	UI.damage(damage)
