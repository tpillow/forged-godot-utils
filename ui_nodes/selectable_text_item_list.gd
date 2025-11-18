@tool
class_name SelectableTextItemList
extends VBoxContainer

signal option_selected(index: int)

@export var options: Array[String] = []:
	get: return options
	set(value):
		options = value
		_refresh_options()
@export var selected_index: int = 0:
	get: return selected_index
	set(value):
		if options.size() <= 0:
			return
		selected_index = clampi(value, 0, options.size() - 1)
		_refresh_selection()
@export var selected_item_prefix := "[color=green]> ":
	get: return selected_item_prefix
	set(value):
		selected_item_prefix = value
		_refresh_selection()
@export var selected_item_suffix := " <[/color]":
	get: return selected_item_suffix
	set(value):
		selected_item_suffix = value
		_refresh_selection()
@export var unselected_item_prefix := "":
	get: return unselected_item_prefix
	set(value):
		unselected_item_prefix = value
		_refresh_selection()
@export var unselected_item_suffix := "":
	get: return unselected_item_suffix
	set(value):
		unselected_item_suffix = value
		_refresh_selection()
@export var item_horizontal_alignment := HORIZONTAL_ALIGNMENT_LEFT:
	get: return item_horizontal_alignment
	set(value):
		item_horizontal_alignment = value
		_refresh_options()
@export var allow_wrap_around := true:
	get: return allow_wrap_around
	set(value):
		allow_wrap_around = value
		_refresh_selection()

func _ready() -> void:
	_refresh_options()
	
func _unhandled_input(event: InputEvent) -> void:
	if options.size() <= 0:
		return

	if event is InputEventKey:
		if event.is_action_pressed("ui_accept"):
			option_selected.emit(selected_index)
		elif event.is_action_pressed("ui_up"):
			if allow_wrap_around and selected_index == 0:
				selected_index = options.size() - 1
			else:
				selected_index -= 1
		elif event.is_action_pressed("ui_down"):
			if allow_wrap_around and selected_index == options.size() - 1:
				selected_index = 0
			else:
				selected_index += 1

func _refresh_options() -> void:
	if not is_node_ready():
		return

	NodeUtil.remove_all_children(self, true)
	if options.size() <= 0:
		return
	
	for option_text in options:
		var label := RichTextLabel.new()
		label.bbcode_enabled = true
		label.text = option_text
		label.fit_content = true
		label.horizontal_alignment = item_horizontal_alignment
		label.set_meta("option_text", option_text)
		add_child(label)
	
	# Re-clamps the selected index; will trigger _refresh_selection
	selected_index = selected_index

func _refresh_selection() -> void:
	if not is_node_ready():
		return

	assert(get_child_count() == options.size())
	for i in range(get_child_count()):
		var label: RichTextLabel = get_child(i)
		var prefix := selected_item_prefix if i == selected_index else unselected_item_prefix
		var suffix := selected_item_suffix if i == selected_index else unselected_item_suffix
		label.text = prefix + label.get_meta("option_text") + suffix
