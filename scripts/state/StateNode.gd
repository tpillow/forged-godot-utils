# A minimalistic utility class that implements state machine-like logic.
# Any StateNode is implicitly in the same "state machine" as the rest of its
# siblings that are also StateNodes. There is no state manager; instead only
# 1 state is active at any given time, and that instance can be used to
# transition between states.
# The topmost StateNode under any given parent is implicitly the first active
# state. All other StateNode siblings will be inactive initially.
# The first active state WILL NOT receive onEnteringState / onEnteredState
# calls. However, it will receive a onFirstStateReady call if the method exists.
class_name StateNode
extends Node

##### Signals #####

# This state has now changed to the active state
# This will always be called after onEnteringState
signal enteredState()

# This state is still active, but we are going to toState
signal exitingState(toState: StateNode)

##### Stubs #####

# This state is about to be the active state, but not yet
# This can define arguments to take on transition into this state
# Does not need to be defined (default: no parameters, no behavior)
# func onEnteringState(...) -> void

# This state is the first active state and the ready function has been called
func _onFirstActiveState() -> void:
	pass

# Connected to the enteredState signal
func onEnteredState() -> void:
	pass

# Connected to the exitingState signal
func onExitingState(toState: StateNode) -> void:
	pass

##### Public State Helpers #####

# Get a state node under the same parent with the given name
func getStateByName(name: String) -> StateNode:
	return get_parent().find_child(name, false) as StateNode
	
# Get a state node under the same parent with the given type
func getStateByType(type: Variant) -> StateNode:
	for child in get_parent().get_children():
		if is_instance_of(child, type):
			assert(is_instance_of(child, StateNode),
				"gotoStateByType was provided a type that does not inherit StateNode")
			return child
	return null

# Transition to toState, passing along setupArgs to the onEnteringState function
# If toState is the current state, this is a no-op
func gotoState(toState: StateNode, setupArgs: Array[Variant] = []) -> void:
	#if toState == self:
		#push_warning("calling gotoState from the same state: %s" % toState)

	exitingState.emit(toState)
	if toState.has_method("onEnteringState"):
		toState.callv("onEnteringState", setupArgs)
	else:
		assert(setupArgs.size() == 0,
			"provided setupArgs to a state without a onEnteringState method")

	_deactivateState()

	toState._activateState()
	toState.enteredState.emit()

# Same as gotoState, but looks up toState by name (searches siblings)
func gotoStateByName(name: String, setupArgs: Array[Variant] = []) -> void:
	var stateNode := getStateByName(name)
	assert(stateNode, "gototStateByName did not find node %s" % name)
	gotoState(stateNode, setupArgs)

# Same as gotoState, but looks up toState by type (searches siblings)
func gotoStateByType(type: Variant, setupArgs: Array[Variant] = []) -> void:
	var stateNode := getStateByType(type)
	assert(stateNode, "gotoStateByType did not find a node %s" % type)
	gotoState(stateNode, setupArgs)

# Returns true if this state is the currently-active state compared to siblings
func isActiveState() -> bool:
	return is_node_ready() and process_mode != Node.PROCESS_MODE_DISABLED

##### Static Helpers #####

# Returns the currently active StateNode under the given parent
# May return null if no StateNode is found
static func findActiveState(parent: Node, ignoreSafetyCheck: bool = false) -> StateNode:
	var foundStateNode := false
	for child in parent.get_children():
		if child is StateNode:
			foundStateNode = true
			if (child as StateNode).isActiveState():
				return child
	assert(ignoreSafetyCheck or not foundStateNode,
		"findActiveState saw a StateNode but found no active ones")
	return null

##### Private Helpers #####

func _ready() -> void:
	# All states begin as inactive
	_deactivateState()
	enteredState.connect(onEnteredState)
	exitingState.connect(onExitingState)
	
	if not findActiveState(get_parent(), true):
		# This is the first ready state compared to its siblings
		_activateState()
		_onFirstActiveState()

func _activateState() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT

func _deactivateState() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
