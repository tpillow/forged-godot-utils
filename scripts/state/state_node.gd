# A minimalistic utility class that implements state machine-like logic.
# Any StateNode is implicitly in the same "state machine" as the rest of its
# siblings that are also StateNodes. There is no state manager; instead only
# 1 state is active at any given time, and that instance can be used to
# transition between states.
# The topmost StateNode under any given parent is implicitly the first active
# state. All other StateNode siblings will be inactive initially.
# The first active state WILL NOT receive on_entering_state / on_entered_state
# calls. However, it will receive a _onFirstActiveState call if the method exists.
class_name StateNode
extends Node

##### Signals #####

# This state has now changed to the active state
# This will always be called after on_entering_state
signal entered_state

# This state is still active, but we are going to to_state
signal exiting_state(to_state: StateNode)

##### Stubs #####

# This state is about to be the active state, but not yet
# This can define arguments to take on transition into this state
# Does not need to be defined (default: no parameters, no behavior)
# func on_entering_state(...) -> void


# This state is the first active state and the ready function has been called
func _on_first_active_state() -> void:
	pass


# Connected to the entered_state signal
func on_entered_state() -> void:
	pass


# Connected to the exiting_state signal
func on_exiting_state(to_state: StateNode) -> void:
	pass


##### Public State Helpers #####


# Get a state node under the same parent with the given name
func get_state_by_name(name: String) -> StateNode:
	return get_parent().find_child(name, false) as StateNode


# Get a state node under the same parent with the given type
func get_state_by_type(type: Variant) -> StateNode:
	for child in get_parent().get_children():
		if is_instance_of(child, type):
			assert(
				is_instance_of(child, StateNode),
				"get_state_by_type was provided a type that does not inherit StateNode"
			)
			return child
	return null


# Transition to to_state, passing along setup_args to the on_entering_state function
# If to_state is the current state, the state is exited and re-entered
func goto_state(to_state: StateNode, setup_args: Array[Variant] = []) -> void:
	exiting_state.emit(to_state)
	if to_state.has_method("on_entering_state"):
		to_state.callv("on_entering_state", setup_args)
	else:
		assert(
			setup_args.size() == 0,
			"provided setup_args to a state without an on_entering_state method"
		)

	_deactivate_state()

	to_state._activate_state()
	to_state.entered_state.emit()


# Same as goto_state, but looks up to_state by name (searches siblings)
func goto_state_by_name(name: String, setup_args: Array[Variant] = []) -> void:
	var state_node := get_state_by_name(name)
	assert(state_node, "goto_state_by_name did not find node %s" % name)
	goto_state(state_node, setup_args)


# Same as goto_state, but looks up to_state by type (searches siblings)
func goto_state_by_type(type: Variant, setup_args: Array[Variant] = []) -> void:
	var state_node := get_state_by_type(type)
	assert(
		state_node, "goto_state_by_type did not find node with type %s" % type
	)
	goto_state(state_node, setup_args)


# Returns true if this state is the currently-active state compared to siblings
func is_active_state() -> bool:
	return is_node_ready() and process_mode != Node.PROCESS_MODE_DISABLED


##### Static Helpers #####


# Returns the currently active StateNode under the given parent
# May return null if no StateNode is found
static func find_active_state(
	parent: Node, ignore_safety_check: bool = false
) -> StateNode:
	var found := false
	for child in parent.get_children():
		if child is StateNode:
			found = true
			if (child as StateNode).is_active_state():
				return child
	assert(
		ignore_safety_check or not found,
		"find_active_state saw a StateNode but found no active ones"
	)
	return null


##### Private Helpers #####


func _ready() -> void:
	# All states begin as inactive
	_deactivate_state()
	entered_state.connect(on_entered_state)
	exiting_state.connect(on_exiting_state)

	if not find_active_state(get_parent(), true):
		# This is the first ready state compared to its siblings
		_activate_state()
		_on_first_active_state()


func _activate_state() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT


func _deactivate_state() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
