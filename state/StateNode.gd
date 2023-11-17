# A minimalistic utility class that implements state machine-like logic.
# Any StateNode is implicitly in the same "state machine" as the rest of its
# siblings that are also StateNodes. There is no state manager; instead only
# 1 state is active at any given time, and that instance can be used to
# transition between states.
# The topmost StateNode under any given parent is implicitly the active state
# to which onEnteredStateInitially will be called on ready. All other StateNode
# siblings will be inactive initially.
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

# Return true if able to transition to this state
# This can define arguments to take that must match the args of onEnteringState
# Does not need to be defined (default: return true)
# func canGotoState(...) -> bool

# Called if this state is the first ready state compared to its siblings
# Because you will not get an onEnteringState / onEnteredState call
func onEnteredStateInitially() -> void:
	pass

# Connected to the enteredState signal
func onEnteredState() -> void:
	pass

# Connected to the exitingState signal
func onExitingState(toState: StateNode) -> void:
	pass

##### Public State Helpers #####

# Transition to toState, passing along setupArgs to the onEnteringState and
# canGotoState functions; canGotoState must return true if it exists
func gotoState(toState: StateNode, setupArgs: Array[Variant] = []) -> void:
	assert(toState._canGotoState(setupArgs),
		"trying to go to state when canGotoState returned false")
	
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
	gotoState(get_parent().find_child(name, false) as StateNode, setupArgs)

# Same as gotoState, but looks up toState by type (searches siblings)
func gotoStateByType(type: Variant, setupArgs: Array[Variant] = []) -> void:
	for child in get_parent().get_children():
		if is_instance_of(child, type):
			assert(is_instance_of(child, StateNode),
				"gotoStateByType was provided a type that does not inherit StateNode")
			gotoState(child as StateNode, setupArgs)
			return
	push_error("gotoStateByType did not find a sibling with type %s" % type)

# If toState.canGotoState returns true, call gotoState
# Returns true if the transition is made
func gotoStateIfAble(toState: StateNode, setupArgs: Array[Variant] = []) -> bool:
	if not toState._canGotoState(setupArgs):
		return false
	gotoState(toState, setupArgs)
	return true

# Same as gotoStateIfAble, but looks up toState by name (searches siblings)
func gotoStateByNameIfAble(name: String, setupArgs: Array[Variant] = []) -> bool:
	return gotoStateIfAble(get_parent().find_child(name, false), setupArgs)

# Same as gotoStateIfAble, but looks up toState by type (searches siblings)
func gotoStateByTypeIfAble(type: Variant, setupArgs: Array[Variant] = []) -> bool:
	for child in get_parent().get_children():
		if is_instance_of(child, type):
			assert(is_instance_of(child, StateNode),
				"gotoStateByTypeIfAble was provided a type that does not inherit StateNode")
			return gotoStateIfAble(child as StateNode, setupArgs)
	push_error("gotoStateByTypeIfAble did not find a sibling with type %s" % type)
	return false

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
		onEnteredStateInitially()

# Returns canGotoState(setupArgs) if it is implemented; otherwise true
func _canGotoState(setupArgs: Array[Variant]) -> bool:
	if has_method("canGotoState"):
		return callv("canGotoState", setupArgs)
	return true

func _activateState() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT

func _deactivateState() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
