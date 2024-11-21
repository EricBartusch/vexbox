extends Control

var showHideTimer = 0
var showing = false
var hiding = false

func _process(delta: float) -> void:
	if showing:
		showHideTimer -= delta
		global_position.x += delta * 3000
		if showHideTimer <= 0:
			showing = false
	if hiding:
		showHideTimer -= delta
		global_position.x -= delta * 3000
		if showHideTimer <= 0:
			visible = false
			get_parent().get_node("Dimmer").visible = false
			hiding = false
			get_tree().paused = false

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_discord_button_pressed() -> void:
	OS.shell_open("https://discord.gg/C879hd7nJs")

func _on_close_options_button_pressed() -> void:
	hiding = true
	showHideTimer = 0.5


func show_options():
	visible = true
	get_parent().get_node("Dimmer").visible = true
	get_tree().paused = true
	showing = true
	showHideTimer = 0.5

func _on_fullscreen_checkbox_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_export_save_to_clipboard_button_pressed() -> void:
	DisplayServer.clipboard_set(get_parent().save())
	


func _on_load_save_from_clipboard_button_pressed() -> void:
	var line = DisplayServer.clipboard_get()
	var main = get_parent()
	var json = JSON.new()
	var parse_result = json.parse(line)
	
	var data = json.data
	for key in data.keys():
			main.set(key, data[key])
	
	main.unlockedBoxes = (main.unlockedRows * (main.unlockedRows + 1)) / 2
	main.get_node("NumWinsText").text = ": " + str(main.wins)
	main.get_node("WinstreakText").text = "Winstreak: " + str(main.winstreak)
	main.get_node("BestWinstreakText").text = "Best Winstreak: " + str(main.bestWinstreak)
	main.get_node("WinsToNextText").text = "Reach " + str(main.winsToNext) + " wins for a NEW ROW."
	
	main.saveGame()


func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		var sfx_index = AudioServer.get_bus_index("SFX")
		AudioServer.set_bus_volume_db(sfx_index, $SFXSlider.value)


func _on_music_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		var sfx_index = AudioServer.get_bus_index("Music")
		AudioServer.set_bus_volume_db(sfx_index, $MusicSlider.value)
