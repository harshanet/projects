extends CharacterBody2D
enum INJURIES { SprainedAnkles, AllergicReaction, AsthmaAttack, Burn, COPoison, WoundRustyObject }
const SPEED = 100.0
@onready var animated_sprite = $AnimatedSprite2D
@onready var finite_state_machine = $FiniteStateMachine as FiniteStateMachine
@onready var npc_cured_state = $FiniteStateMachine/CuredState as CuredState
@onready var npc_injured_state = $FiniteStateMachine/NPCInjuredState as InjuredState
@export var animations : SpriteFrames
@export var injury : INJURIES
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
signal cure_success
func _ready():
	$AnimatedSprite2D.set_sprite_frames(animations)
	npc_injured_state.cured.connect(finite_state_machine.change_state_no_rpc.bind(npc_cured_state))
	npc_injured_state.cured.connect(progress)
	npc_cured_state.injured.connect(finite_state_machine.change_state_no_rpc.bind(npc_injured_state))
	npc_injured_state.set_injury(INJURIES.keys()[injury])
	finite_state_machine.change_state_no_rpc(npc_injured_state)

func get_type():
	return "NPC"

func progress():
	cure_success.emit()
