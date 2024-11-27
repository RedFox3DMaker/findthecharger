extends Node

func init():
	"""
	hide the charger parts in the furnitures
	"""
	# reset the player position
	get_node("/root/Main/Player").global_transform.origin = Vector3.ZERO
		
	# hide the charger parts
	var furnitures = get_tree().get_nodes_in_group("furnitures")
	furnitures.shuffle()
	print("charger parts are hidden in:")
	for idx in range(2):
		var furniture = furnitures[idx]
		prints("-", furniture.name)
		furniture.has_charger_part = true
		
	# start the scene
	get_node("/root/Main/Player").stop = false
