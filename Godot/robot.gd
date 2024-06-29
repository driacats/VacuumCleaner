extends CharacterBody3D

# Connection parameters
const PORT = 9080
var tcp_server = TCPServer.new()
var ws = WebSocketPeer.new()

var motion = false

var old_objects = []

func _ready():
	if tcp_server.listen(PORT) != OK:
		print("Unable to start the server.")
		set_process(false)


func _physics_process(delta):

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
			look_at(global_position + Vector3(-1, 0, 0))
		"down":
			look_at(global_position + Vector3(1, 0, 0))
		"left":
			look_at(global_position + Vector3(0, 0, -1))
		"right":
			look_at(global_position + Vector3(0, 0, 1))
		_:
			print("Unknown direction: ", direction)

func clean():
	pass
	
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
			var perception = {"type": "see", "object": obj_name}
			ws.send_text(JSON.stringify(perception))
