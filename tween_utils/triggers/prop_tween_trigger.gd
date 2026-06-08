class_name PropTweenTrigger
extends TweenTrigger

@export var prop_name: String
@export var value: Variant

var _last_value: Variant

func _ready() -> void:
	super()
	_last_value = trigger_source.get(prop_name)
	
func _process(delta: float) -> void:
	var cur_value = trigger_source.get(prop_name)
	if cur_value == _last_value: return
	if cur_value == value:
		do_trigger()
	_last_value = cur_value
