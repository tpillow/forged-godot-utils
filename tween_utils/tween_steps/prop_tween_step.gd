class_name PropTweenStep
extends TweenStep

@export var prop_path := ""
@export var easing: Tween.EaseType = Tween.EASE_OUT
@export var trans: Tween.TransitionType = Tween.TRANS_EXPO
@export var end_value: Variant
@export var end_value_set_initial_prop := ""
@export var end_value_initial_prop_offset: Variant
@export var duration := 1.0

func apply_tween() -> void:
	var real_end_value = end_value
	var cache_value = tween_anim.source.intial_node_prop_cache.get(end_value_set_initial_prop)
	if cache_value != null:
		real_end_value = cache_value
		if end_value_initial_prop_offset != null:
			real_end_value += end_value_initial_prop_offset

	tween_anim.tween.set_ease(easing).set_trans(trans)
	tween_anim.tween.tween_property(tween_anim.source.node, prop_path, real_end_value, duration)
