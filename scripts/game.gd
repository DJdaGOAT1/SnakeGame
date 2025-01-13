extends Node

#game variables
var score: int
var gameStarted: bool = false

#grid variables
var cells: int = 30
var cell_size: int = 50

 # snake variables
var old_data : Array
var snake_data : Array
var snake : Array

# movement varaibles

var start_pos = Vector2(9, 9)
var up = Vector2(0, -1)
var down = Vector2(0, 1)
var left = Vector2(-1,0)
var right = Vector2(1, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game() # Replace with function body.

func new_game():
	score = 0;
	$Hud.get_node("Score").text = "SCORE: " + str(score)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
