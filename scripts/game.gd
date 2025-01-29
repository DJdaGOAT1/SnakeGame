extends Node

@export var snake_scene : PackedScene

#game variables
var score : int
var highscore : int = 0
var game_started : bool = false
var foodswitch : int = 0

#grid variables
var cells : int = 20
var cell_size : int = 50

#food variables
var food_pos : Vector2
var regen_food : bool = true
var eat_yet : bool = false

#snake variables
var old_data : Array
var snake_data : Array
var snake : Array

#movement variables
var start_pos = Vector2(9, 9)
var up = Vector2(0, -1)
var down = Vector2(0, 1)
var left = Vector2(-1, 0)
var right = Vector2(1, 0)
var move_direction : Vector2
var can_move: bool


# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()
	
func new_game():
	get_tree().paused = false
	get_tree().call_group("segments", "queue_free")
	$GameOverScene.hide()
	$Banana.hide()
	$Staffy.hide()
	$Watson.hide()
	$Garcia.hide()
	score = 0
	foodswitch = 0
	$ScoreScene.get_node("ScoreLabel").text = "SCORE-" + str(score)
	$ScoreScene.get_node("HighScoreLabel").text = "HIGH-" + str(highscore)  # Display high score
	move_direction = up
	can_move = true
	generate_snake()
	move_food()
	
func generate_snake():
	old_data.clear()
	snake_data.clear()
	snake.clear()
	#starting with the start_pos, create tail segments vertically down
	for i in range(3):
		add_segment(start_pos + Vector2(0, i))
		
func add_segment(pos):
	snake_data.append(pos)
	var SnakeSegment = snake_scene.instantiate()
	SnakeSegment.position = (pos * cell_size) + Vector2(0, cell_size)
	add_child(SnakeSegment)
	snake.append(SnakeSegment)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_snake()
func move_snake():
	if can_move:
		#update movement from keypresses
		if Input.is_action_just_pressed("movedown") and move_direction != up:
			move_direction = down
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("moveup") and move_direction != down:
			move_direction = up
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("moveleft") and move_direction != right:
			move_direction = left
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("moveright") and move_direction != left:
			move_direction = right
			can_move = false
			if not game_started:
				start_game()

	

func start_game():
	game_started = true
	$Timer.start()


func _on_timer_timeout():
	#allow snake movement
	can_move = true
	#use the snake's previous position to move the segments
	old_data = [] + snake_data
	snake_data[0] += move_direction
	for i in range(len(snake_data)):
		#move all the segments along by one
		if i > 0:
			snake_data[i] = old_data[i - 1]
		snake[i].position = (snake_data[i] * cell_size) + Vector2(0, cell_size)
	check_out_of_bounds()
	check_self_eaten()
	check_food_eaten()
	
func check_out_of_bounds():
	if snake_data[0].x < 0 or snake_data[0].x > cells - 1 or snake_data[0].y < 0 or snake_data[0].y > cells - 1:
		$OutEdgeHit.play()
		end_game()
		
func check_self_eaten():
	for i in range(1, len(snake_data)):
		if snake_data[0] == snake_data[i]:
			$HitItself.play()
			end_game()
			
func check_food_eaten():
	if snake_data[0] == food_pos:
		if(foodswitch % 5 == 1): $Crunching.play()
		if(foodswitch % 5 == 2): $Burp.play()
		if(foodswitch % 5 == 4): $WatsonAudio.play()
		if(foodswitch % 5 == 0): $GarciaAudio.play()
		score += 1
		$ScoreScene.get_node("ScoreLabel").text = "SCORE-" + str(score)
		add_segment(old_data[-1])
		if(foodswitch % 5 == 0):
			$Banana.hide()
			$Staffy.hide()
			$Watson.hide()
			$Garcia.hide()
			move_food()
		elif(foodswitch % 5 == 1):
			$Apple.hide()
			$Staffy.hide()
			$Watson.hide()
			$Garcia.hide()
			move_food2()
		elif(foodswitch % 5 == 2):
			$Apple.hide() 
			$Banana.hide()
			$Watson.hide()
			$Garcia.hide()
			move_food3()
		elif(foodswitch % 5 == 3):
			$Apple.hide()
			$Banana.hide()
			$Staffy.hide()
			$Garcia.hide()
			move_food4()
		else:
			$Apple.hide()
			$Banana.hide()
			$Staffy.hide()
			$Watson.hide()
			move_food5()
		# Check if the new score exceeds the high score
		if score > highscore:
			highscore = score
			$ScoreScene.get_node("HighScoreLabel").text = "HIGH-" + str(highscore)  # Update the high score label
	
func move_food():
	foodswitch += 1
	while regen_food:
		regen_food = false
		food_pos = Vector2(randi_range(0, cells - 1), randi_range(0, cells - 1))
		for i in snake_data:
			if food_pos == i:
				regen_food = true
	$Apple.position = (food_pos * cell_size)+ Vector2(0, cell_size)
	$Apple.show()
	regen_food = true

func move_food2():
	foodswitch += 1
	while regen_food:
		regen_food = false
		food_pos = Vector2(randi_range(0, cells - 1), randi_range(0, cells - 1))
		for i in snake_data:
			if food_pos == i:
				regen_food = true
	$Banana.show()
	$Banana.position = (food_pos * cell_size)+ Vector2(0, cell_size)
	regen_food = true
	
func move_food3():
	foodswitch += 1
	while regen_food:
		regen_food = false
		food_pos = Vector2(randi_range(0, cells - 1), randi_range(0, cells - 1))
		for i in snake_data:
			if food_pos == i:
				regen_food = true
	$Staffy.show()
	$Staffy.position = (food_pos * cell_size)+ Vector2(0, cell_size)
	regen_food = true

func move_food4():
	foodswitch += 1
	while regen_food:
		regen_food = false
		food_pos = Vector2(randi_range(0, cells - 1), randi_range(0, cells - 1))
		for i in snake_data:
			if food_pos == i:
				regen_food = true
	$Watson.show()
	$Watson.position = (food_pos * cell_size)+ Vector2(0, cell_size)
	regen_food = true
		
func move_food5():
	foodswitch += 1
	while regen_food:
		regen_food = false
		food_pos = Vector2(randi_range(0, cells - 1), randi_range(0, cells - 1))
		for i in snake_data:
			if food_pos == i:
				regen_food = true
	$Garcia.show()
	$Garcia.position = (food_pos * cell_size)+ Vector2(0, cell_size)
	regen_food = true

func end_game():
	$GameOverScene.show()
	$GameOverScene.get_node("Label2").text = "SCORE-" + str(score)
	$Timer.stop()
	game_started = false
	get_tree().paused = true
	if score > highscore:
		highscore = score
		$ScoreScene.get_node("HighScoreLabel").text = "HIGH-" + str(highscore)  # Update the high score label


func _on_game_over_scene_restart():
	new_game() # Replace with function body.
