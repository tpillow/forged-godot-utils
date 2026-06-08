class_name DelayTweenStep
extends TweenStep

signal completed()

@export var duration := 0.0

func apply_tween() -> void:
	tween_anim.tween.tween_interval(duration)
	tween_anim.tween.tween_callback(completed.emit)
