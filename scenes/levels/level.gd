extends Node2D

@onready var grass_layer = $Layers/GrassLayer
@onready var soil_layer = $Layers/SoilLayer
@onready var water_soil_layer = $Layers/WaterSoilLayer

func _on_player_tool_use(tool: int, pos: Vector2i) -> void:
	match tool:
		Enum.Tool.HOE:
			if grass_layer.get_cell_tile_data(pos):
				var grass_tile = grass_layer.get_cell_tile_data(pos) as TileData
				if grass_tile.get_custom_data("CanPlace"):
					soil_layer.set_cells_terrain_connect([pos], 0, 0)
		Enum.Tool.WATER:
			if soil_layer.get_cell_tile_data(pos):
				water_soil_layer.set_cells_terrain_connect([pos], 0, 0)
