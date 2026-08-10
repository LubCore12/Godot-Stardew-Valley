extends Node

const PLAYER_SKINS = {
	Enum.Style.BASIC: preload("res://graphics/characters/main/main_basic.png"),
	Enum.Style.BASEBALL: preload("res://graphics/characters/main/main_blue.png"),
	Enum.Style.COWBOY: preload("res://graphics/characters/main/main_cowboy.png"),
	Enum.Style.ENGLISH: preload("res://graphics/characters/main/main_grey.png"),
	Enum.Style.STRAW: preload("res://graphics/characters/main/main_straw.png"),
	Enum.Style.BEANIE: preload("res://graphics/characters/main/main_red.png")}
const TILE_SIZE = 16
const HALF_TILE_SIZE = round(TILE_SIZE / 2.0)
const TILE_VECTOR = Vector2i(TILE_SIZE, TILE_SIZE)
const TILE_HALF_VECTOR = Vector2i(round(TILE_SIZE / 2.0), round(TILE_SIZE / 2.0))
const PLANT_DATA = {
	Enum.Seed.TOMATO: {
		'texture': preload("res://graphics/plants/tomato.png"),
		'icon_texture': preload("res://graphics/icons/tomato.png"),
		'name':'Tomato',
		'h_frames': 4,
		'max_age': 3,
		'grow_speed': 0.6,
		'death_max': 3,
		'reward': Enum.Item.TOMATO},
	Enum.Seed.CORN: {
		'texture': preload("res://graphics/plants/corn.png"),
		'icon_texture': preload("res://graphics/icons/corn.png"),
		'name':'Corn',
		'h_frames': 4,
		'max_age': 3,
		'grow_speed': 1.0,
		'death_max': 2,
		'reward': Enum.Item.CORN},
	Enum.Seed.PUMPKIN: {
		'texture': preload("res://graphics/plants/pumpkin.png"),
		'icon_texture': preload("res://graphics/icons/pumpkin.png"),
		'name':'Pumpkin',
		'h_frames': 4,
		'max_age': 3,
		'grow_speed': 0.3,
		'death_max': 3,
		'reward': Enum.Item.PUMPKIN},
	Enum.Seed.WHEAT: {
		'texture': preload("res://graphics/plants/wheat.png"),
		'icon_texture': preload("res://graphics/icons/wheat.png"),
		'name':'Wheat',
		'h_frames': 4,
		'max_age': 3,
		'grow_speed': 1.0,
		'death_max': 3,
		'reward': Enum.Item.WHEAT}}
const MACHINE_UPGRADE_COST = {
	Enum.Machine.SPRINKLER: {
		'name': 'Sprinkler',
		'cost' :{Enum.Item.TOMATO: 30, Enum.Item.WHEAT: 20},
		'icon': preload("res://graphics/icons/sprinkler.png"),
		'color': Color.SEA_GREEN},
	Enum.Machine.FISHER: {
		'name': 'Fisher',
		'cost' :{Enum.Item.WOOD: 25, Enum.Item.FISH: 15},
		'icon': preload("res://graphics/icons/fisher.png"),
		'color': Color.SLATE_GRAY},
	Enum.Machine.SCARECROW: {
		'name': 'Scarecrow',
		'cost' : {Enum.Item.PUMPKIN: 15, Enum.Item.CORN: 15},
		'icon': preload("res://graphics/icons/scarecrow.png"),
		'color': Color.BURLYWOOD}}
const HOUSE_COST = {
	1: {Enum.Item.WOOD: 30, Enum.Item.APPLE: 20},
	2: {Enum.Item.WOOD: 40, Enum.Item.APPLE: 30}}
const STYLE_UPGRADES = {
	Enum.Style.COWBOY: {
		'name': 'Cowboy',
		'cost':{Enum.Item.WOOD: 8, Enum.Item.CORN: 6},
		'icon': preload("res://graphics/icons/cowboy.png"),
		'color': Color.SANDY_BROWN},
	Enum.Style.ENGLISH: {
		'name': 'Oldie',
		'cost':{Enum.Item.CORN: 8, Enum.Item.WHEAT: 6},
		'icon': preload("res://graphics/icons/english.png"),
		'color': Color.LIGHT_GRAY},
	Enum.Style.BASEBALL: {
		'name': 'Baseball',
		'cost':{Enum.Item.TOMATO: 8, Enum.Item.APPLE: 6},
		'icon': preload("res://graphics/icons/blue.png"),
		'color': Color.SKY_BLUE},
	Enum.Style.BEANIE: {
		'name': 'Beanie',
		'cost':{Enum.Item.PUMPKIN: 8, Enum.Item.WHEAT: 6},
		'icon': preload("res://graphics/icons/beanie.png"),
		'color': Color.INDIAN_RED},
	Enum.Style.STRAW: {
		'name': 'Straw',
		'cost':{Enum.Item.FISH: 8, Enum.Item.WOOD: 6},
		'icon': preload("res://graphics/icons/straw.png"),
		'color': Color.BURLYWOOD}}
const TOOL_STATE_ANIMATIONS = {
	Enum.Tool.HOE: 'Hoe',
	Enum.Tool.AXE: 'Axe',
	Enum.Tool.WATER: 'Water',
	Enum.Tool.SWORD: 'Sword',
	Enum.Tool.FISH: 'Fish',
	Enum.Tool.SEED: 'Seed'}
const TOOL_STATE_TEXTURES = {
	Enum.Tool.HOE: preload("res://graphics/icons/hoe.png"),
	Enum.Tool.AXE: preload("res://graphics/icons/axe.png"),
	Enum.Tool.WATER: preload("res://graphics/icons/water.png"),
	Enum.Tool.SWORD: preload("res://graphics/icons/sword.png"),
	Enum.Tool.FISH: preload("res://graphics/icons/fish.png"),
	Enum.Tool.SEED: preload("res://graphics/icons/beanie.png"),
}

const starting_tool = Enum.Tool.AXE
const starting_seed = Enum.Seed.TOMATO
