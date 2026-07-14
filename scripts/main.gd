extends Node
@onready var score_label: Label = $HUD/Scorepanel/ScoreLabel

var score: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _setup_level() -> void:
	
	var coin = $LevelRoot.get_node_or_null("Coin")
	if coin:
		for enemy in coin.get_children():
			enemy.collected.connect(increase_score)
	
	
	var enemies = $LevelRoot.get_node_or_null("Enemies")
	if enemies:
		for enemy in enemies.get_children():
			enemy.player_died.connect(_on_player_died)

# SIGNAL HANDLERS

func _on_player_died(body):
	print(body)
	print("Player killed")
	
func increase_score() -> void:
	score +=1
	score_label.text = "Score: %s" % score
	


func _on_flag_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		call_deferred("level2")
	
func level2():
	var current_scene_path = get_tree().current_scene.scene_file_path
	if current_scene_path.contains("level2.tscn"):
		get_tree().change_scene_to_file("res://sprites&scenes/winscreen.tscn")
	else:
		get_tree().change_scene_to_file("res://sprites&scenes/level2.tscn")
