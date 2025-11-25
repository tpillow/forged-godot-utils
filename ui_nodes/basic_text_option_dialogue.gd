@tool
class_name BasicTextOptionDialogue
extends PanelContainer

signal option_selected(index: int)

@export var header := "Header":
	get: return header
	set(value):
		header = value
		_refresh()
@export var content := "This is content!":
	get: return content
	set(value):
		content = value
		_refresh()
@export var options: Array[String] = ["Option A", "Option B"]:
	get: return options
	set(value):
		options = value
		_refresh()
@export var footer := "Footer":
	get: return footer
	set(value):
		footer = value
		_refresh()
@export var reveal_char_duration := -1.0

@onready var header_label: RichTextLabel = %HeaderLabel
@onready var content_label: RichTextLabel = %ContentLabel
@onready var options_list: SelectableTextItemList = %OptionsList
@onready var footer_label: RichTextLabel = %FooterLabel

var _reveal_char_tween: Tween
var _done_revealing: bool:
	get: return not _reveal_char_tween or not _reveal_char_tween.is_running()

static var show_dialogue_scene_manager: SceneManager = null
static var show_dialogue_scene_transition: SceneTransition = SceneTransitionInstant.new()
static var show_dialogue_min_size := Vector2(600, 300)
static var show_dialogue_default_footer := ""
static var show_dialogue_reveal_char_duration := 0.75

static func instantiate_new() -> BasicTextOptionDialogue:
	return preload("res://forged_godot_utils/ui_nodes/basic_text_option_dialogue.tscn").instantiate()

static func instantiate_new_basic_menu(
		header: String,
		sub_header: String,
		options: Array[String],
		footer: String) -> BasicTextOptionDialogue:
	var dialogue := preload("res://forged_godot_utils/ui_nodes/basic_menu_screen.tscn").instantiate()
	dialogue.header = header
	dialogue.content = sub_header
	dialogue.options = options
	dialogue.footer = footer
	return dialogue

static func show_dialogue(
		header: String,
		content: String,
		options: Array[String] = [],
		footer: String = show_dialogue_default_footer) -> int:
	var dialogue := instantiate_new()
	dialogue.header = header
	dialogue.content = content
	dialogue.options = options
	dialogue.footer = footer
	dialogue.custom_minimum_size = show_dialogue_min_size
	dialogue.reveal_char_duration = show_dialogue_reveal_char_duration
	
	var container := CenterContainer.new()
	container.set_anchors_preset(Control.PRESET_FULL_RECT)
	container.add_child(dialogue)
	
	show_dialogue_scene_manager.push_ui(container, show_dialogue_scene_transition)
	var selected_option: int = await dialogue.option_selected
	show_dialogue_scene_manager.pop(show_dialogue_scene_transition)
	return selected_option

func _ready() -> void:
	options_list.option_selected_by_mouse.connect(func(index):
		_do_select())
	_refresh()
	_ready_content()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("ui_accept"):
			_do_select()

func _do_select() -> void:
	if not _done_revealing:
		_force_complete_reveal()
		return
	option_selected.emit(
		options_list.selected_index if options.size() > 0 else -1)

func _refresh() -> void:
	if not is_node_ready():
		return

	header_label.text = header
	content_label.text = content
	options_list.options = options
	footer_label.text = footer
	
	header_label.visible = header != ""
	options_list.visible = options.size() > 0
	footer_label.visible = footer != ""

func _ready_content() -> void:
	if Engine.is_editor_hint() or reveal_char_duration <= 0:
		return
	
	footer_label.modulate = Color.TRANSPARENT
	options_list.modulate = Color.TRANSPARENT
	content_label.visible_ratio = 0.0
	_reveal_char_tween = create_tween()
	_reveal_char_tween.tween_property(content_label, "visible_ratio", 1.0, reveal_char_duration)
	_reveal_char_tween.tween_callback(_force_complete_reveal)

func _force_complete_reveal() -> void:
	_reveal_char_tween.kill()
	content_label.visible_ratio = 1.0
	footer_label.modulate = Color.WHITE
	options_list.modulate = Color.WHITE
	assert(_done_revealing)
