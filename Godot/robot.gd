extends CharacterBody3D

# Connection parameters
const PORT = 9080
var tcp_server = TCPServer.new()
var ws = WebSocketPeer.new()

var motion = false

func _ready():
	if tcp_server.listen(PORT) != OK:
		print("Unable to start the server.")
		set_process(false)


func _physics_process(delta):

	if motion:
		translate(-Vector3.FORWARD * delta)

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
		"left":
			look_at(Vector3(-1, 0, 0))
		"right":
			look_at(Vector3(1, 0, 0))
		"up":
			look_at(Vector3(0, 0, -1))
		"down":
			look_at(Vector3(0, 0, 1))
		_:
			print("Unknown direction: ", direction)

func clean():
	pass
