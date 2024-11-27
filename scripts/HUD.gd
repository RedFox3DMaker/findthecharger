extends Control

var remaining_time = 20
var found_items = 0

func init_game():
	# start the timer
	$GameTimer.start()
	
	# musics
	$TitleMusic.stop()
	$MainMusic.play()
	$Failure.stop()
	$FoundPart.stop()
	$Rummaging.stop()
	
	# init timer
	update_TimerLabel(20)
		
	# init found items
	update_FoundItemsLabel(0)
	
	get_node("/root/Main/Room").init()


func stop_game(victory: bool):
	# stop the timer
	$GameTimer.stop()
	
	# musics
	$MainMusic.stop()
	
	# stop the player
	get_node("/root/Main/Player").stop = true
	
	# show the end screen
	if victory:
		$EndScreen/EndLabel.text = "Success !!"
	else:
		$EndScreen/EndLabel.text = "Game Over"
		$Failure.play()
	$EndScreen.show()


func update_TimerLabel(value: int):
	remaining_time = value
	$TimerView/TimerLabel.text = "00:%02d" % remaining_time
	
	# if the time is below five color text in red
	if remaining_time <= 5:
		$TimerView/TimerLabel.add_theme_color_override("font_color", Color( 1, 0.5, 0.5, 1 ))
	else:
		$TimerView/TimerLabel.add_theme_color_override("font_color", Color(1, 1, 1, 1))
		
func update_FoundItemsLabel(value: int):
	found_items = value
	$FoundItems/FoundItemsLabel.text = "Items %d/2" % found_items


func _on_GameTimer_timeout():
	# compute the remaining time 
	update_TimerLabel(remaining_time - 1)

	# when the time has reached zero it is over
	if remaining_time == 0:
		stop_game(false)

func _on_PlayButton_pressed():
	# hide the title screen
	$TitleScreen.hide()
	
	init_game()


func _on_Furniture_found_item():
	update_FoundItemsLabel(found_items + 1)
	
	# victory !!
	if found_items == 2:
		stop_game(true)


func _on_Room_ready():
	get_tree().call_group("furnitures", "connect", "found_item", self, "_on_Furniture_found_item")


func _on_RetryButton_pressed():
	# hide the end screen
	$EndScreen.hide()
	init_game()


func _on_HomeButton_pressed():
	$EndScreen.hide()
	$TitleScreen.show()
	$TitleMusic.play()


func _on_SoundEffectTimer_timeout():
	if $FoundPart.playing:
		$FoundPart.stop()
		
	if $Rummaging.playing:
		$Rummaging.stop()
		
	if $Failure.playing:
		$Failure.stop()
