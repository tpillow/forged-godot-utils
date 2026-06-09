class_name SetPropTweenStep
extends TweenStep

@export var prop_path := ""
@export var value: Variant

func apply_tween() -> void:
	tween_anim.tween.tween_callback(func():
		tween_anim.source.node.set(prop_path, value)
		completed.emit())
