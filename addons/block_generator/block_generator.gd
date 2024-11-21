@tool
extends EditorPlugin

var MENU_NAME = "Generate Blocks"

var BLOCKS_JSON: String = "res://Assets/Blocks/blocks.json"

func load_json(file_path: String) -> Dictionary:
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	if !file.file_exists(file_path):
		print(file_path + " does not exist")
		return {}

	var json_string = file.get_as_text()  # Read the file content as a string
	file.close()

	var json = JSON.new()
	var result = json.parse(json_string)

	if result != OK:
		print("Failed to parse JSON.")
		return {}

	return json.get_data()
	
func generate_blocks():
	var block_json = load_json(BLOCKS_JSON)
	
	var dir = DirAccess.open("res://Assets/Blocks/CompletedBlocks")
	
	for base_block_name in block_json["blocks"]["base_blocks"]:
		var save_dir: String = base_block_name.to_pascal_case() + "/"
		dir.make_dir(save_dir)
		for block_data in block_json["blocks"]["block_types"]:
			var block: Node2D = load("res://Assets/Blocks/Bases/" + base_block_name + ".tscn").instantiate()
			var block_name = base_block_name + "_" + block_data["name"]
			block.name = block_name.to_pascal_case()
			
			if "clip" in block_data:
				var clipping_node: ClippingComponent = block.find_child("ClippingComponent")
				clipping_node.clipping_mask = block_data["clip"]
				
			if "modifier" in block_data:
				var modifier_folder: String = block_data["modifier"].to_pascal_case() + "Modifier"
				var modifier: PackedScene = load("res://Assets/Blocks/Components/" + modifier_folder + "/" + block_data["modifier"] + "_modifier.tscn")
				var init_modifier = modifier.instantiate()
				block.add_child(init_modifier)
				block.move_child(init_modifier, -2)
				init_modifier.owner = block
				if "modifier_data" in block_data:
					init_modifier.modifier_data = block_data["modifier_data"]
					
			if "unbreakable" in block_data:
				var breakable_node: BreakableComponent = block.find_child("BreakableComponent")
				if breakable_node:
					breakable_node.unbreakable = block_data["unbreakable"]
				else:
					continue
					
			if "facade" in block_data:
				if block_data["facade"]:
					var sprite: Sprite2D = block.find_child("Sprite2D")
					sprite.z_index = 100
					var collision: CollisionShape2D = block.find_child("CollisionShape2D")
					if collision:
						collision.free()
					var breakable_node: BreakableComponent = block.find_child("BreakableComponent")
					if breakable_node:
						breakable_node.free()
			
			var scene = PackedScene.new()
			scene.pack(block)
			ResourceSaver.save(scene, "res://Assets/Blocks/CompletedBlocks/" + save_dir + block_name + ".tscn")
	
	print("Blocks Generated!")

func _enter_tree():
	add_tool_menu_item(MENU_NAME, generate_blocks)

func _exit_tree():
	remove_tool_menu_item(MENU_NAME)
