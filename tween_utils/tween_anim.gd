class_name TweenAnim
extends Node

@export var source: TweenSource:
	get:
		if source: return source
		return get_parent()
	set(value): source = value

@export var force_complete_time_step := 0.1

var tween: Tween

func cancel_tween() -> void:
	if tween: tween.kill()
	tween = null

func start_tween() -> void:
	tween = source.node.create_tween()
	
	for ts in NodeUtil.find_all_children_of_type(self, TweenStep, false):
		ts.apply_tween()

func force_complete_tween() -> void:
	if not tween: return

	while tween.custom_step(force_complete_time_step):
		pass
