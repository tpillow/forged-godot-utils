class_name TweenAnim
extends Node

enum TriggerType {
	NONE,
	TREE_ENTER,
	CONTROL_MOUSE_ENTER,
	CONTROL_MOUSE_EXIT,
	SIGNAL,
	PROP_IS_FALSE,
	PROP_IS_TRUE,
}

@export var source: TweenSource:
	get:
		if source: return source
		return get_parent()
	set(value): source = value

@export var tween_data: TweenData

@export var trigger_type: TriggerType = TriggerType.NONE
@export var trigger_on_ready := false
@export var trigger_signal_name := ""
@export var trigger_prop_source: Node:
	get:
		if trigger_prop_source: return trigger_prop_source
		return source.node
	set(value): trigger_prop_source = value
@export var trigger_prop_name := ""


var tween: Tween
var _last_prop_value: Variant

func _ready() -> void:
	_setup_trigger()

func _setup_trigger() -> void:
	match trigger_type:
		TriggerType.NONE: pass
		TriggerType.TREE_ENTER:
			source.node.tree_entered.connect(do_trigger)
		TriggerType.CONTROL_MOUSE_ENTER:
			(source.node as Control).mouse_entered.connect(do_trigger)
		TriggerType.CONTROL_MOUSE_EXIT:
			(source.node as Control).mouse_exited.connect(do_trigger)
		TriggerType.SIGNAL:
			source.node.get(trigger_signal_name).connect(do_trigger)
		TriggerType.PROP_IS_FALSE, TriggerType.PROP_IS_TRUE:
			_last_prop_value = trigger_prop_source.get(trigger_prop_name)
		_: assert(false)

	if trigger_on_ready:
		do_trigger.call_deferred()

func _process(delta: float) -> void:
	if trigger_type not in [TriggerType.PROP_IS_FALSE, TriggerType.PROP_IS_TRUE]: return
	var cur_prop_value = trigger_prop_source.get(trigger_prop_name)
	if cur_prop_value == _last_prop_value: return
	_last_prop_value = cur_prop_value
	match trigger_type:
		TriggerType.PROP_IS_FALSE:
			if not _last_prop_value: do_trigger()
		TriggerType.PROP_IS_TRUE:
			if _last_prop_value: do_trigger()

func cancel_tween() -> void:
	if tween: tween.kill()
	tween = null

func start_tween() -> void:
	tween = source.node.create_tween()
	tween_data.apply_tween(self)

func do_trigger() -> void:
	cancel_tween()
	start_tween()
