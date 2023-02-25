extends KinematicBody2D

class_name Actor

const FLOOR_NORMAL = Vector2.UP
const FRICTION = 0.18

var max_hp = 50.0

export var hp = 100.0 setget set_hp
signal hp_changed(new_hp)

export var speed = Vector2(150.0, 350.0)
export var gravity = 20


onready var state_machine = get_node("FiniteStateMachine")
onready var animated_sprite: AnimatedSprite = get_node("AnimatedSprite")

var _velocity = Vector2.ZERO


func take_damage(damage, push_direction, force):
	self.hp -= damage
	if hp > 0:
		state_machine.set_state(state_machine.states.Damaged)
		_velocity += push_direction * force
	else:
		state_machine.set_state(state_machine.states.Dead)
		_velocity += push_direction * force

func add_health(health):
	self.hp += health
	#get_node("SoundFX/Health").play()

func set_hp(new_hp):
	hp = new_hp
	emit_signal("hp_changed", new_hp)
