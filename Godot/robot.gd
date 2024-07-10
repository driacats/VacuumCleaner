extends CharacterBody3D

var speed = 6
var acceleration = 10

# Connection parameters
const PORT = 9080
var tcp_server = TCPServer.new()
var ws = WebSocketPeer.new()

var motion = false
var old_objects = []
var collisions = []

var end_communication = true

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

func _ready():
	if tcp_server.listen(PORT) != OK:
		print("Unable to start the server.")
		set_process(false)
		

func _physics_process(delta):
	while tcp_server.is_connection_available():
		var conn = tcp_server.take_connection()
		assert(conn != null)
		ws.accept_stream(conn)

	ws.poll()

	if ws.get_ready_state() == WebSocketPeer.STATE_OPEN:
		while ws.get_available_packet_count():
			var msg = ws.get_packet().get_string_from_ascii()
			var action = JSON.parse_string(msg)
			perform(action)
			
	if nav.is_navigation_finished():
		if not end_communication:
			var msg = {"type": "inform", "code": "gained"}
			ws.send_text(JSON.stringify(msg))
			end_communication = true
		return
	
	var direction = Vector3()
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * speed, acceleration * delta)
	
	move_and_slide()

func _exit_tree():
	ws.close()
	tcp_server.stop()
	
func perform(action: Dictionary):
	print("Performing action: ", action)
	match action:
		{"type": "gain", "target": _}:
			var new_target = action["target"]
			end_communication = false
			nav.set_target_position(get_node("/root/Node3D/" + new_target).global_position)
		{"type": "clean", "target": _}:
			var dirt = action["target"]
			get_node("/root/Node3D/" + dirt).queue_free()
			var msg = {"type": "inform", "code": "cleaned"}
			ws.send_text(JSON.stringify(msg))
	

func get_rough_area(static_body: StaticBody3D):
	var collision_shape = static_body.get_node("CollisionShape3D")
	if collision_shape and collision_shape.shape is ConcavePolygonShape3D:
		var shape = collision_shape.shape
		var faces = shape.get_faces()
		
		var min_x = INF
		var max_x = -INF
		var min_z = INF
		var max_z = -INF
		
		for point in faces:
			point = static_body.to_global(point)
			min_x = min(min_x, point.x)
			max_x = max(max_x, point.x)
			min_z = min(min_z, point.z)
			max_z = max(max_z, point.z)
		
		return [[snapped(min_x, 0.001), snapped(min_z, 0.001)], [snapped(max_x, 0.001), snapped(max_z, 0.001)]]

	return [[null, null], [null, null]]
	
func see():
	var sight = $Area3D
	var objects = sight.get_overlapping_bodies()
	objects.erase(self)
	if objects != old_objects:
		old_objects = objects
		for obj in objects:
			var obj_name = obj.get_parent().name
			if "Door" in obj_name:
				obj_name = "door"
			elif "Wall" in obj_name:
				obj_name = "wall"
			elif "cabinet" in obj_name:
				obj_name = "cabinet"
			elif "chair" in obj_name:
				obj_name = "chair"
			elif "table" in obj_name:
				obj_name = "table"
			var rectangle_area = get_rough_area(obj)
			var distance = snapped(global_position.distance_to(obj.global_position), 0.001)
			var direction = ""
			if ( obj.global_position.x - global_position.x ) > 4.0:
				direction += "down"
			elif ( obj.global_position.x - global_position.x ) < 4.0:
				direction += "up"
			if ( obj.global_position.z - global_position.z ) > 4.0:
				direction += "left"
			elif ( obj.global_position.z - global_position.z) < 4.0:
				direction += "right"
			
			var perception = {"type": "see", "object": obj_name, "min_x": rectangle_area[0][0], "min_y": rectangle_area[0][1], "max_x": rectangle_area[1][0], "max_y": rectangle_area[1][1], "distance": distance, "direction": direction}
			ws.send_text(JSON.stringify(perception))
