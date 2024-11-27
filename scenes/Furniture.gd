extends Node3D

# signals
signal found_item

# data members
var has_charger_part = false
var searchable = false

func _ready():
	if self.get_child_count() == 3:
		var bounding_box = null
		# compute the bounding box of the 3d model
		for child_mesh in get_child(2).get_children():
			var cur_bouding_box = child_mesh.get_aabb()
			if bounding_box == null:
				bounding_box = cur_bouding_box
			else:
				bounding_box = bounding_box.merge(cur_bouding_box)
		
		var computed_center_y = bounding_box.get_center().y
		$FurnitureBody.position.y = computed_center_y
		
		# compute the extent to apply to the collider and area
		var computed_extents = bounding_box.size / 2
		#prints("extent of", self.name, ":", computed_extents)
		$FurnitureBody/CollisionShape3D.shape.set_size(computed_extents)
		var computed_extents_area = Vector3(computed_extents.x, 0, computed_extents.z)
		$FurnitureArea/FurnitureAreaCollisionShape.shape.set_size(computed_extents_area + 0.1 * Vector3.ONE)
		
		# enable collider 
		$FurnitureBody/CollisionShape3D.disabled = false
		

func _process(_delta):
	if Input.is_action_pressed("search") and self.searchable:
		# update found items
		if self.has_charger_part:
			self.has_charger_part = false
			print(self.name, " has charger part")
			emit_signal("found_item")
			print("found item !")
			get_node("/root/Main/UserInterface/FoundPart").play()
			get_node("/root/Main/UserInterface/SoundEffectTimer").start()
		else:
			get_node("/root/Main/UserInterface/Rummaging").play()
			get_node("/root/Main/UserInterface/SoundEffectTimer").start()
	

func _on_FurnitureArea_area_entered(area):
	print(area.name, " entered in area ", self.name)
	self.searchable = true


func _on_FurnitureArea_area_exited(area):
	print(area.name, " exited of area ", self.name)
	self.searchable = false
