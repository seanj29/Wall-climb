extends KinematicBody2D

export (int) var speed = 250
export (int) var max_speed = 200
export (int) var gravity = 350
export (int) var jump_speed = 150
export (int) var max_jumps = 2

onready var screen_size = get_viewport_rect().size
onready var _sprite = $AnimatedSprite

const UPV = Vector2(0, -1)

var direction = Vector2.RIGHT
var velocity = Vector2()
var jumpCount = 0

func _process(_delta):

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


	if is_on_floor():
		jumpCount = 0

	if Input.is_action_just_pressed("ui_select") and jumpCount == 0:
		velocity.y = -jump_speed
		jumpCount += 1
	elif Input.is_action_just_pressed("ui_select") and jumpCount == 1:
		velocity.y = -jump_speed
		position += velocity * delta 
		jumpCount += 1

	move_and_slide(velocity, UPV)

	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func animLoop():

	if velocity.x != 0 and is_on_floor():
		playAnim("Running",velocity.x < 0)
	elif !is_on_floor():
		playAnim("Jumping",  direction == Vector2.LEFT)
	else:
		playAnim("Idling", direction == Vector2.LEFT)


func playAnim(animName, isflippedh = false, isflippedv = false):
	_sprite.play(animName)
	_sprite.flip_h = isflippedh
	_sprite.flip_v = isflippedv



	