class_name TweenTrigger
extends Node

enum OnReadyTriggerMode {
	NONE,
	TRIGGER,
	TRIGGER_FORCE_COMPLETE,
}

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
	
@export var on_ready_trigger_mode := OnReadyTriggerMode.NONE

func _ready() -> void:
	match on_ready_trigger_mode:
		OnReadyTriggerMode.NONE: pass
		OnReadyTriggerMode.TRIGGER:
			do_trigger.call_deferred()
		OnReadyTriggerMode.TRIGGER_FORCE_COMPLETE:
			trigger_and_force_complete.call_deferred()
		_: assert(false)

func do_trigger() -> void:
	tween_anim.cancel_tween()
	tween_anim.start_tween()

func trigger_and_force_complete() -> void:
	do_trigger()
	tween_anim.force_complete_tween()
