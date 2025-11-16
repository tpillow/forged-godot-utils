# Entities must have a "tile_coord" Vector2i property 
class_name TileMapEntityCoordinator
extends Node2D

class _EntityCell extends Object:
	var entities: Array[Node2D] = []

const TILE_COORD_NULL: Vector2i = Vector2i.MIN

# Tile size used to control coordinate conversions; based on this node's global position
@export var tile_size: Vector2 = Vector2(8, 8)
# Whether or not entities added/removed should be children of this node or not
@export var entities_are_children: bool = true
# Maximum number of entities per grid cell
@export var max_entities_per_cell: int = 1
# If true, entities must have a "tile_coord_changed(old, new)" signal, and when
# triggered, this coordinator will move the entity
@export var listen_to_entities: bool = true

var _entity_cells: Dictionary[Vector2i, _EntityCell] = {}
var _entity_tile_coord_changed_callbacks: Dictionary[Node2D, Callable] = {}

func _ready() -> void:
	if entities_are_children:
		for child in get_children():
			if child.tile_coord == TILE_COORD_NULL:
				child.tile_coord = global_to_tile_coord(child.global_position)
			_add_entity_cell_only(child)
			_attach_entity_listener(child)

func add_entity(entity: Node2D, tile_coord: Vector2i = TILE_COORD_NULL) -> void:
	_add_entity_cell_only(entity, tile_coord)
	
	if entities_are_children:
		assert(entity not in get_children())
		add_child(entity)
		
	_attach_entity_listener(entity)
		
func move_entity(entity: Node2D, tile_coord: Vector2i, from_coord: Vector2i = TILE_COORD_NULL) -> void:
	var old_coord: Vector2i = entity.tile_coord if from_coord == TILE_COORD_NULL else from_coord
	_remove_from_cell(entity, old_coord)
	_add_to_cell(entity, tile_coord)
	
func remove_entity(entity: Node2D) -> void:
	_remove_from_cell(entity, entity.tile_coord)

	if entities_are_children:
		assert(entity in get_children())
		remove_child(entity)
		
	_detach_entity_listener(entity)
		
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
		
func _attach_entity_listener(entity: Node2D) -> void:
	if not listen_to_entities:
		return
	assert(entity not in _entity_tile_coord_changed_callbacks)
	var callback := func(old_coord: Vector2i, new_coord: Vector2i) -> void:
		move_entity(entity, new_coord, old_coord)
	_entity_tile_coord_changed_callbacks[entity] = callback
	entity.tile_coord_changed.connect(callback)
	
func _detach_entity_listener(entity: Node2D) -> void:
	if not listen_to_entities:
		return
	assert(entity in _entity_tile_coord_changed_callbacks)
	entity.tile_coord_changed.disconnect(_entity_tile_coord_changed_callbacks[entity])
	_entity_tile_coord_changed_callbacks.erase(entity)
		
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
	if not listen_to_entities:
		entity.tile_coord = tile_coord
	
func _remove_from_cell(entity: Node2D, tile_coord: Vector2i) -> void:
	assert(tile_coord in _entity_cells)
	var cell := _entity_cells[tile_coord]
	assert(entity in cell.entities)
	cell.entities.erase(entity)
	if cell.entities.size() <= 0:
		_entity_cells.erase(tile_coord)
