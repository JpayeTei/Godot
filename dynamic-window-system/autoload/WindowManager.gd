extends Node
#An empty dictionary that will map string IDs (like "pause_menu") to 
#PackedScene resources (the actual .tscn files for those windows).
var window_scenes: Dictionary = {}  
#Another dictionary that maps the same string IDs to instances of BaseWindow that are 
#currently in the scene tree.
var open_windows: Dictionary = {}


#A public method to add a new window type to the manager’s knowledge.
#Parameters:
#
	#id: Unique name for the window (e.g. "tower_upgrade").
#
	#scene: The preloaded PackedScene resource (use preload("res://...") when calling).

func register_window(id: String, scene: PackedScene) -> void: #scene ma chai scene ko location halinxa
	window_scenes[id] = scene #example of window id could be a "tower_upgrade" window

#The main function I’ll use everywhere. It either shows an already‑open window or creates 
#a new one and then shows it.
#Returns the BaseWindow instance for convenience (so I can do extra setup, 
#like setting a dynamic title).
func open_window(id: String) -> BaseWindow: #id ko bhitra chai eg "hero_picker" jasto id janxa
#remember function overlaoding is being used
	
	#Checks if a window with this ID is already in the open_windows dictionary 
	#(meaning it’s been created and not closed).
	if open_windows.has(id):
		var win = open_windows[id]
		win.open_window()
		return win
	if not window_scenes.has(id):
		push_error("WindowManager: Unknown window ID: " + id)

	var win_instance = window_scenes[id].instantiate()
	win_instance.window_id = id
	if not win_instance:
		push_error("WindowManager: Scene for '" + id + "' is not a BaseWindow")
		return null
	#If we don’t have this ID registered, we can’t create it. This is an error condition.
	if not window_scenes.has(id):
		push_error("WindowManager: Unknown window ID: " + id)
		return null
	#Creates an actual node from the stored PackedScene. This is the new window.
	#var win_instance = window_scenes[id].instantiate()
	#win_instance.window_id = id #Sets the window_id variable on the new window. (Remember @export var window_id in BaseWindow2
	
	#Tries to find a node named “UI” directly under the root of the scene tree. 
	#We intend to use it as a container for all UI windows.
	var ui_layer = get_tree().root.get_node_or_null("UI")

#If “UI” node doesn’t exist yet, we create it.
	if not ui_layer:
		#Creates a new CanvasLayer and names it “UI”. CanvasLayer is specifically designed for UI 
		#that sits above the 3D world and is unaffected by camera movement.
		ui_layer = CanvasLayer.new(); ui_layer.name = "UI"
		get_tree().root.call_deferred("add_child", ui_layer)#Adds this new CanvasLayer as a direct child of the root 
		#Viewport. This makes it persistent across all scenes.
	ui_layer.call_deferred("add_child", win_instance)#Adds the new window instance as a child of the UI layer, so it
	# appears in the game and is rendered.
	
	
	win_instance.window_closed.connect(_on_window_closed.bind(id))#Connects the window’s 
	#window_closed signal to our internal _on_window_closed method, but with a twist: 
	#bind(id) passes the id as an argument to the method.
	
	open_windows[id] = win_instance#Adds the new instance to the tracking dictionary.
	win_instance.open_window()#Now that everything is set up, we make the window visible (calls show() and emits window_opened).
	return win_instance


#Public method to close a window programmatically (e.g., after a purchase).
func close_window(id: String) -> void:
#Checks if it’s open, and if so, tells that instance to close itself. 
#The instance’s close_window() will call hide() and emit window_closed, which will then 
#trigger _on_window_closed to clean up the dictionary.
	if open_windows.has(id): open_windows[id].close_window()

# Internal callback that’s triggered when any window emits window_closed.
func _on_window_closed(id: String) -> void:
	if open_windows.has(id): open_windows.erase(id)

#Utility function to check if a window is currently open (and visible).
# It checks both the dictionary and the visible property.
func is_window_open(id: String) -> bool:
	return open_windows.has(id) and open_windows[id].visible
