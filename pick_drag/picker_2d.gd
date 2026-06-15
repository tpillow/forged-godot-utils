class_name Picker2D
extends Area2D

signal focus_node_changed(node: Node2D)
signal focus_node_pressed(node: Node2D, button: MouseButton)

signal focus_node_start_drag(node: Node2D)
signal focus_node_stop_drag(node: Node2D)

@export var follow_mouse := true
@export var match_draggable_group_to_drag := true
@export var draggable_group_name: String
@export var set_dragging_global_pos := true

var supports_dragging: bool:
	get: return not match_draggable_group_to_drag or draggable_group_name != ""

var _focus_node: Node2D = null
var focus_node: Node2D:
	get: return _focus_node
var _is_dragging: bool = false
var is_dragging: bool:
	get: return _is_dragging

func _ready() -> void:
	var cs := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 1.0
	cs.shape = shape
	add_child(cs)
	
	area_entered.connect(_on_node_enter)
	area_exited.connect(_on_node_exit)
	body_entered.connect(_on_node_enter)
	body_exited.connect(_on_node_exit)
	
	_update_focus_node()

func _process(delta: float) -> void:
	if follow_mouse:
		global_position = get_global_mouse_position()
	
	if is_dragging and set_dragging_global_pos:
		focus_node.global_position = global_position

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if is_dragging:
			if event.button_index != MOUSE_BUTTON_LEFT: return
			if event.is_pressed(): return
			
			_is_dragging = false
			focus_node_stop_drag.emit(focus_node)
			_update_focus_node()
		else:
			if not focus_node: return
			if not event.is_pressed(): return
			
			if supports_dragging and (not match_draggable_group_to_drag or focus_node.is_in_group(draggable_group_name)):
				_is_dragging = true
				focus_node_start_drag.emit(focus_node)
			else:
				focus_node_pressed.emit(focus_node, event.button_index)

func _on_node_enter(node: Node2D) -> void:
	_update_focus_node()

func _on_node_exit(node: Node2D) -> void:
	_update_focus_node()

func _update_focus_node() -> void:
	if is_dragging: return
	
	var best: Node2D = null
	for child in get_overlapping_areas() + get_overlapping_bodies():
		if not best:
			best = child
			continue
		if best.get_index() >= child.get_index(): continue
		best = child
	
	if best != _focus_node:
		_focus_node = best
		focus_node_changed.emit(_focus_node)
