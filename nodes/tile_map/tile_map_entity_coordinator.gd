# Entities must have a "tile_coord" Vector2i property 
class_name TileMapEntityCoordinator
extends Node2D

class _EntityCell extends Object:
	var entities: Array[Node2D] = []

const TILE_COORD_NULL: Vector2i = Vector2i.MIN

@export var tile_size: Vector2 = Vector2(8, 8)
@export var entities_are_children: bool = true
@export var max_entities_per_cell: int = 1

var _entity_cells: Dictionary[Vector2i, _EntityCell] = {}

func _ready() -> void:
	if entities_are_children:
		for child in get_children():
			if child.tile_coord == TILE_COORD_NULL:
				child.tile_coord = global_to_tile_coord(child.global_position)
			_add_entity_cell_only(child)

func add_entity(entity: Node2D, tile_coord: Vector2i = TILE_COORD_NULL) -> void:
	_add_entity_cell_only(entity, tile_coord)
	
	if entities_are_children:
		assert(entity not in get_children())
		add_child(entity)
		
func move_entity(entity: Node2D, tile_coord: Vector2i) -> void:
	_remove_from_cell(entity, entity.tile_coord)
	_add_to_cell(entity, tile_coord)
	
func remove_entity(entity: Node2D) -> void:
	_remove_from_cell(entity, entity.tile_coord)

	if entities_are_children:
		assert(entity in get_children())
		remove_child(entity)
		
func tile_coord_to_global(tile_coord: Vector2i, centered: bool = true) -> Vector2:
	var offset := tile_size / 2.0 if centered else Vector2.ZERO
	return Vector2(tile_coord) * tile_size + offset + global_position

func global_to_tile_coord(coord: Vector2) -> Vector2i:
	return Vector2i((coord - global_position) / tile_size)

func get_entities_at(tile_coord: Vector2i) -> Array[Node2D]:
	if tile_coord not in _entity_cells:
		return []
	return _entity_cells[tile_coord].entities

func num_entities_at(tile_coord: Vector2i) -> int:
	return get_entities_at(tile_coord).size()
		
func _add_entity_cell_only(entity: Node2D, tile_coord: Vector2i = TILE_COORD_NULL) -> void:
	assert("tile_coord" in entity,
		"TileMapEntityCoordinator entities must have 'tile_coord' Vector2i property")

	if tile_coord == TILE_COORD_NULL:
		tile_coord = entity.tile_coord
	else:
		entity.tile_coord = tile_coord

	_add_to_cell(entity, tile_coord)
		
func _add_to_cell(entity: Node2D, tile_coord: Vector2i) -> void:
	if tile_coord not in _entity_cells:
		_entity_cells[tile_coord] = _EntityCell.new()
	var cell := _entity_cells[tile_coord]
	assert(entity not in cell.entities, "entity already added")
	assert(cell.entities.size() < max_entities_per_cell,
		"cannot add entity: cell maximum reached")
	cell.entities.append(entity)
	entity.tile_coord = tile_coord
	
func _remove_from_cell(entity: Node2D, tile_coord: Vector2i) -> void:
	assert(tile_coord in _entity_cells)
	var cell := _entity_cells[tile_coord]
	assert(entity in cell.entities)
	cell.entities.erase(entity)
	if cell.entities.size() <= 0:
		_entity_cells.erase(tile_coord)
