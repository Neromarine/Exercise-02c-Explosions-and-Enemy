extends KinematicBody2D
var inital_position = Vector2.ZERO
var direction = Vector2(1.5,0)
var wabble = 30
var health = 1
var y_positions = [100,150,200,500,550]

var Effects = null
onready var Bullet = load("res://Enemy/Bullet.tscn")
onready var Explosion = load("res://Explosion.tscn")

func _ready():
	inital_position.x += 100
	inital_position.y = y_positions[randi()%y_positions.size()]
	position = inital_position
	pass

func _physics_process(_delta):
	position += direction
	position.y = inital_position.y + sin(position.x/20)*wabble
	if position.x >= 1200:
		queue_free()

func damage(d):
	health -= d
	if health <= 0:
		Effects = get_node_or_null("root/Game/Effects")
		if Effects != null:
			var explosion = Explosion.instance()
			Effects.add_child(explosion)
			explosion.position = self.position
	queue_free()
			
	

	


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.damage(100)
		damage(100)

func _on_Timer_timeout():
	var Player = get_node_or_null("/root/Game/Player_Container/Player")
	Effects = get_node_or_null("/root/Game/Effects")
	if Effects != null and Player != null:
		var bullet = Bullet.instance()
		var d = position.angle_to_point(Player.position) - PI/2
		bullet.rotation = d
		bullet.position = self.position + Vector2(0,-40).rotated(d)
		Effects.add_child(bullet)
