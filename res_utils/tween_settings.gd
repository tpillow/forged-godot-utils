class_name TweenSettings
extends Resource

@export var ease: Tween.EaseType = Tween.EASE_OUT
@export var trans: Tween.TransitionType = Tween.TRANS_LINEAR
@export var duration: float = 1.0
	
static func new_with(ease: Tween.EaseType, trans: Tween.TransitionType, duration: float) -> TweenSettings:
	var ret := TweenSettings.new()
	ret.ease = ease
	ret.trans = trans
	ret.duration = duration
	return ret

func setup_for_tween(tween: Tween) -> void:
	tween.set_ease(ease).set_trans(trans)
