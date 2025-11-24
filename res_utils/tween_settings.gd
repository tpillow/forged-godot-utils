class_name TweenSettings
extends Resource

@export var ease: Tween.EaseType = Tween.EASE_IN_OUT
@export var trans: Tween.TransitionType = Tween.TRANS_LINEAR
@export var duration: float = 1.0

func setup_for_tween(tween: Tween) -> void:
	tween.set_ease(ease).set_trans(trans)
