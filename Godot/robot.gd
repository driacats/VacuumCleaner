extends CharacterBody3D

# Connection parameters
const PORT = 9080
var tcp_server = TCPServer.new()
var ws = WebSocketPeer.new()

var motion = false

var old_objects = []

var collisions = []

func _ready():
	if tcp_server.listen(PORT) != OK:
		print("Unable to start the server.")
		set_process(false)


func _physics_process(delta):
	
	if $RayCast3D.is_colliding():
		var collider = $RayCast3D.get_collider()
		if collider.get_parent().name not in collisions:
			var perception = {"type": "warning", "colliding": true, "object": collider.get_parent().name.to_lower()}
			collisions.append(collider.get_parent().name)
			ws.send_text(JSON.stringify(perception))

	if motion:
		translate(-Vector3.FORWARD * delta * 2)

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
	see()

func _exit_tree():
	ws.close()
	tcp_server.stop()

func perform(action: Dictionary):
	print("Performing action: ", action)
	match action:
		{"type": "move", "status": _}:
			my_move(action["status"])
		{"type": "rotate", "direction": _}:
			my_rotate(action["direction"])
		{"type": "clean"}:
			clean()
		_:
			print("Unknown action: ", action)

func my_move(status: String):
	match status:
		"start":
			motion = true
		"stop":
			motion = false
		_:
			print("Unknown status: ", status)	

func my_rotate(direction):
	match direction:
		"up":
			look_at(global_position + Vector3(1, 0, 0))
		"down":
			look_at(global_position + Vector3(-1, 0, 0))
		"left":
			look_at(global_position + Vector3(0, 0, -1))
		"right":
			look_at(global_position + Vector3(0, 0, 1))
		_:
			print("Unknown direction: ", direction)

func clean():
	pass

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
