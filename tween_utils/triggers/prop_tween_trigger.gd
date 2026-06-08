class_name PropTweenTrigger
extends TweenTrigger

@export var prop_name: String
@export var value: Variant
@export var on_ready_eval_prop_trigger_mode := TweenTrigger.OnReadyTriggerMode.NONE

var _last_value: Variant

func _ready() -> void:
	super()
	_last_value = trigger_source.get(prop_name)

    match on_ready_eval_prop_trigger_mode:
        TweenTrigger.OnReadyTriggerMode.NONE: pass
		TweenTrigger.OnReadyTriggerMode.TRIGGER:
			assert(on_ready_trigger_mode == TweenTrigger.OnReadyTriggerMode.NONE, "base TweenTrigger already has ready set")
			if _last_value != value: break
			do_trigger.call_deferred()
		TweenTrigger.OnReadyTriggerMode.TRIGGER_FORCE_COMPLETE:
			assert(false, "unimplemented!")
            assert(on_ready_trigger_mode == TweenTrigger.OnReadyTriggerMode.NONE, "base TweenTrigger already has ready set")
			if _last_value != value: break
			trigger_and_force_complete.call_deferred()
        _: assert(false)
	
func _process(delta: float) -> void:
	var cur_value = trigger_source.get(prop_name)
	if cur_value == _last_value: return
	if cur_value == value:
		do_trigger()
	_last_value = cur_value
