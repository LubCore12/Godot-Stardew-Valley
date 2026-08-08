extends Node2D

@onready var grass_layer = $Layers/GrassLayer
@onready var water_layer = $Layers/WaterLayer
@onready var soil_layer = $Layers/SoilLayer
@onready var water_soil_layer = $Layers/WaterSoilLayer

func _on_player_tool_use(tool: int, pos: Vector2) -> void:
	var tile_pos = Vector2i(round(pos.x) / Data.TILE_SIZE, round(pos.y) / Data.TILE_SIZE)
	
	match tool:
		Enum.Tool.AXE:
			for tree in get_tree().get_nodes_in_group("Trees"):
				if tree.position.distance_to(pos) < 20:
					print("axe")
		Enum.Tool.HOE:
			if grass_layer.get_cell_tile_data(tile_pos):
				var grass_tile = grass_layer.get_cell_tile_data(tile_pos) as TileData
				if grass_tile.get_custom_data("CanPlace"):
					soil_layer.set_cells_terrain_connect([tile_pos], 0, 0)
		Enum.Tool.WATER:
			if soil_layer.get_cell_tile_data(tile_pos):
				water_soil_layer.set_cells_terrain_connect([tile_pos], 0, 0)
		Enum.Tool.FISH:
			if water_layer.get_cell_tile_data(tile_pos):
				print("fish")
