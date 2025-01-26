class_name Alien
extends CharacterBody2D
var hit_times = 0

func _on_hit_area_body_entered(body):
	hit_times += 1
	if hit_times >= 20:
		$FiniteStateMachine.exit_state()
		$AnimatedSprite2D.play("death")
		await $AnimatedSprite2D.animation_finished
		sync_kill.rpc()

var flag = false

#Function used to synchronize being killed
@rpc("any_peer", "call_local")
func sync_kill():
	if not flag:
		flag = true
		self.queue_free()
