class_name PropTweenStep
extends TweenStep

@export var prop_path := ""
@export var easing: Tween.EaseType = Tween.EASE_OUT
@export var trans: Tween.TransitionType = Tween.TRANS_EXPO
@export var duration := 1.0

@export var end_value: Variant
@export var end_value_is_relative := false

func apply_tween() -> void:
	tween_anim.tween.set_ease(easing).set_trans(trans)
	var prop_tween := tween_anim.tween.tween_property(tween_anim.source.node, prop_path, end_value, duration)
	if end_value_is_relative:
		prop_tween.as_relative()
	tween_anim.tween.tween_callback(completed.emit)
