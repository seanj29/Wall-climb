extends KinematicBody2D

export (int) var speed = 250
export (int) var max_speed = 200
export (int) var gravity = 350
export (int) var jump_speed = 150

onready var screen_size = get_viewport_rect().size
onready var _sprite = $AnimatedSprite

var direction = Vector2.RIGHT
var velocity = Vector2()


func _process(delta):

	animLoop()


func _physics_process(delta):
	velocity.y += delta * gravity

	if Input.is_action_pressed("ui_left"):
		velocity.x = -speed
		direction = Vector2.LEFT
	elif Input.is_action_pressed("ui_right"):
		velocity.x = speed
		direction = Vector2.RIGHT
	else:
		velocity.x = 0



	if is_on_floor() and Input.is_action_just_pressed("ui_select"):
		velocity.y = -jump_speed

	move_and_slide(velocity, Vector2(0, -1))

	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func animLoop():

	if velocity.x != 0 and is_on_floor():
		playAnim("Running",velocity.x < 0)
	else:
		playAnim("Idling", direction == Vector2.LEFT)
	

func playAnim(animName, isflippedh = false, isflippedv = false):
	 _sprite.play(animName)
	 _sprite.flip_h = isflippedh
	 _sprite.flip_v = isflippedv

