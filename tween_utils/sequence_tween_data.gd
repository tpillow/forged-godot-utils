class_name SequenceTweenData
extends TweenData

@export var tween_datas: Array[TweenData] = []

func apply_tween(anim: TweenAnim) -> void:
	for td in tween_datas:
		td.apply_tween(anim)
