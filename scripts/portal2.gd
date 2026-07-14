extends Area2D

@export var target_position: Vector2

signal teleport_player(pos: Vector2)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		emit_signal("teleport_player", target_position)


func _on_teleport_player(pos: Vector2) -> void:
	print("void?")
