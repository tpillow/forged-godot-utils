class_name SignalTweenTrigger
extends TweenTrigger

@export var signal_name: String

func _ready() -> void:
	super()
	trigger_source.get(signal_name).connect(do_trigger)
