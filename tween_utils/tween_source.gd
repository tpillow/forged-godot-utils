class_name TweenSource
extends Node

@export var node: Node:
	get:
		if node: return node
		return get_parent()
	set(value): node = value

var intial_node_prop_cache := {}

func _ready() -> void:
	if node.is_node_ready():
		_set_initial_state()
	else:
		node.ready.connect(_set_initial_state, CONNECT_ONE_SHOT)

func _maybe_add_cache_prop(name: String) -> void:
	var value = node.get(name)
	if value == null: return
	intial_node_prop_cache[name] = value

func _set_initial_state() -> void:
	_maybe_add_cache_prop("position")
	_maybe_add_cache_prop("global_position")
	_maybe_add_cache_prop("rotation")
	_maybe_add_cache_prop("scale")

func cancel_all_tweeners() -> void:
	for anim in get_children():
		anim.cancel_tween()

func get_tween_anim(name: String) -> TweenAnim:
	return find_child(name, false, false)

func start_tween_anim(name: String) -> void:
	get_tween_anim(name).start_tween()
