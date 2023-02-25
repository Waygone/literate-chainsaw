extends FiniteStateMachine

func _init():
	_add_state("Idle")
	_add_state("Moving")
	_add_state("Jump")
	_add_state("Attack")
	_add_state("Damaged")
	_add_state("Dead")

func _ready():
	set_state(states.Idle)
	
func _state_logic(_delta):
	if state != states.Dead:
		pass

func _get_transition():
	match state:
		states.Idle:
			if parent.is_attacking:
				return states.Attack
				
			if parent.is_jumping:
				return states.Jump
				
			if parent._velocity.length() > 15:
				#get_parent().get_node("SoundFX/Walk").playing = true
				return states.Moving
		
		states.Jump:
			if parent.is_attacking:
				parent.is_jumping = false
				return states.Attack
				
			if parent.is_grounded():
				#get_parent().get_node("SoundFX/Walk").playing = true
				parent.is_jumping = false
				return states.Idle
		
		states.Moving:
			if parent.is_attacking:
				return states.Attack
			
			if parent.is_jumping:
				return states.Jump
			
			if parent._velocity.length() < 15:
				#get_parent().get_node("SoundFX/Walk").playing = false
				return states.Idle
		
		states.Attack:
			if not animation_player.is_playing():
				parent.is_attacking = false
				return states.Idle
		
		states.Damaged:
			#get_parent().get_node("SoundFX/Walk").playing = false
			#get_parent().get_node("SoundFX/Damaged").play()
			if not animation_player.is_playing():
				return states.Idle

		states.Dead:
			#get_parent().get_node("SoundFX/Walk").playing = false
			parent.is_dead = true
			
	return -1

func _enter_state(_previous_state, new_state):
	match new_state:
		states.Idle:
			animation_player.play("Idle")
		states.Moving:
			animation_player.play("Moving")
		states.Attack:
			animation_player.play("Attack")
		states.Jump:
			animation_player.play("Jump")
		states.Damaged:
			animation_player.play("Damaged")
		states.Dead:
			animation_player.play("Dead")
			
