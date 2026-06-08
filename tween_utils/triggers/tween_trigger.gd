class_name TweenTrigger
extends Node

@export var tween_anim: TweenAnim:
	get:
		if tween_anim: return tween_anim
		return get_parent()
	set(value): tween_anim = value

@export var trigger_source: Node:
	get:
		if trigger_source: return trigger_source
		return tween_anim.source.node
	set(value): trigger_source = value
	
@export var trigger_immediately := false

func _ready() -> void:
	if trigger_immediately:
		do_trigger.call_deferred()

func do_trigger() -> void:
	tween_anim.cancel_tween()
	tween_anim.start_tween()
