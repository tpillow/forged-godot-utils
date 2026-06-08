class_name SequenceTweenStep
extends TweenStep

func apply_tween() -> void:
	for ts in NodeUtil.find_all_children_of_type(self, TweenStep, false):
		ts.apply_tween()
    tween_anim.tween.tween_callback(completed.emit)
