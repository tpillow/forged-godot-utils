class_name TweenStep
extends Node

@export var tween_anim: TweenAnim:
	get:
		if tween_anim: return tween_anim
		return get_parent()
	set(value): tween_anim = value

func apply_tween() -> void:
	assert(false, "abstract")
