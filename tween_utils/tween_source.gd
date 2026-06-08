class_name TweenSource
extends Node

@export var node: Node:
	get:
		if node: return node
		return get_parent()
	set(value): node = value

func cancel_all_tweeners() -> void:
	for anim in get_children():
		anim.cancel_tween()

func get_tween_anim(name: String) -> TweenAnim:
	return find_child(name, false, false)

func start_tween_anim(name: String) -> void:
	get_tween_anim(name).start_tween()
