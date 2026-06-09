class_name SoundManager
extends Node

signal sound_finished(name: String)
signal master_muted_changed()

class SoundData:
	var asp: AudioStreamPlayer
	var looping := false

@export var sound_dir := "res://audio/"
@export var supported_extensions: Array[String] = [".wav"]

var _sound_data: Dictionary[String, SoundData] = {}

func _ready() -> void:
	_load_sounds_from_dir(sound_dir)

func get_sound_data(name: String) -> SoundData:
	return _sound_data[name]

func _on_asp_finished(name: String) -> void:
	var sd := get_sound_data(name)
	if sd.looping:
		play(name)

	sound_finished.emit(name)

func play(name: String) -> void:
	var sd := get_sound_data(name)
	sd.asp.play()

func is_playing(name: String) -> bool:
	var sd := get_sound_data(name)
	return sd.asp.playing

func stop(name: String) -> void:
	var sd := get_sound_data(name)
	sd.asp.stop()

func set_looping(name: String, looping: bool) -> void:
	var sd := get_sound_data(name)
	sd.looping = looping

func set_volume(name: String, volume: float) -> void:
	var sd := get_sound_data(name)
	sd.asp.volume_linear = volume

func is_master_muted() -> bool:
	var bus_index = AudioServer.get_bus_index("Master")
	return AudioServer.is_bus_mute(bus_index)

func set_master_mute(muted: bool) -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_index, muted)
	master_muted_changed.emit()

func _maybe_get_sound_base_name(name: String) -> String:
	for ext in supported_extensions:
		if name.ends_with(ext):
			return name.trim_suffix(ext)
	return ""

func _load_sounds_from_dir(dir: String) -> void:
	if not dir:
		print("SoundManager: skipping dir loading")
		return

	var files := ResourceLoader.list_directory(dir)
	for file in files:
		var base_name := _maybe_get_sound_base_name(file)
		if not base_name:
			print("SoundManager: skip loading file: %s" % file)
			continue
			
		print("SoundManager: load file: %s" % file)
		var asp := AudioStreamPlayer.new()
		asp.name = base_name
		asp.stream = load("%s%s" % [sound_dir, file])
		asp.finished.connect(_on_asp_finished.bind(base_name))
		add_child(asp)

		_sound_data[base_name] = SoundData.new()
		_sound_data[base_name].asp = asp
