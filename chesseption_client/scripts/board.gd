class_name Board extends Node2D

@onready var a1 = $tiles/a1
@onready var a2 = $tiles/a2
@onready var a3 = $tiles/a3
@onready var a4 = $tiles/a4
@onready var a5 = $tiles/a5
@onready var a6 = $tiles/a6
@onready var a7 = $tiles/a7
@onready var a8 = $tiles/a8
@onready var b1 = $tiles/b1
@onready var b2 = $tiles/b2
@onready var b3 = $tiles/b3
@onready var b4 = $tiles/b4
@onready var b5 = $tiles/b5
@onready var b6 = $tiles/b6
@onready var b7 = $tiles/b7
@onready var b8 = $tiles/b8
@onready var c1 = $tiles/c1
@onready var c2 = $tiles/c2
@onready var c3 = $tiles/c3
@onready var c4 = $tiles/c4
@onready var c5 = $tiles/c5
@onready var c6 = $tiles/c6
@onready var c7 = $tiles/c7
@onready var c8 = $tiles/c8
@onready var d1 = $tiles/d1
@onready var d2 = $tiles/d2
@onready var d3 = $tiles/d3
@onready var d4 = $tiles/d4
@onready var d5 = $tiles/d5
@onready var d6 = $tiles/d6
@onready var d7 = $tiles/d7
@onready var d8 = $tiles/d8
@onready var e1 = $tiles/e1
@onready var e2 = $tiles/e2
@onready var e3 = $tiles/e3
@onready var e4 = $tiles/e4
@onready var e5 = $tiles/e5
@onready var e6 = $tiles/e6
@onready var e7 = $tiles/e7
@onready var e8 = $tiles/e8
@onready var f1 = $tiles/f1
@onready var f2 = $tiles/f2
@onready var f3 = $tiles/f3
@onready var f4 = $tiles/f4
@onready var f5 = $tiles/f5
@onready var f6 = $tiles/f6
@onready var f7 = $tiles/f7
@onready var f8 = $tiles/f8
@onready var g1 = $tiles/g1
@onready var g2 = $tiles/g2
@onready var g3 = $tiles/g3
@onready var g4 = $tiles/g4
@onready var g5 = $tiles/g5
@onready var g6 = $tiles/g6
@onready var g7 = $tiles/g7
@onready var g8 = $tiles/g8
@onready var h1 = $tiles/h1
@onready var h2 = $tiles/h2
@onready var h3 = $tiles/h3
@onready var h4 = $tiles/h4
@onready var h5 = $tiles/h5
@onready var h6 = $tiles/h6
@onready var h7 = $tiles/h7
@onready var h8 = $tiles/h8
@onready var removed_pieces = $Removed_pieces

@onready var white_piece_position: Tile = a4
@onready var black_piece_position: Tile = h5
@onready var red_piece_position: Tile = e1
@onready var blue_piece_position: Tile = d8
@onready var diamond_position: Tile = a1

@onready var tiles = $tiles
func free_all_occupied_tiles() -> void:
	for tile in tiles.get_children():
		tile.tile_is_occupied = false


func find_tile_by_name(tile_name: String) -> Tile:
	for tile in tiles.get_children():
		if tile_name == tile.name:
			return tile
	return null
