class_name AnimationManger extends Node
@onready var beauty_animator: AnimationPlayer = $"../BEUASTYYYYY/beautyAnimator"
@onready var target_right_arm: Marker3D = $"../BEUASTYYYYY/TargetRightArm"
@onready var board: Board = $"../Board"

#pass turns here
func _ready() -> void:
	$"../BEUASTYYYYY/Armature/Skeleton3D/SkeletonIK3D".start() 

func play_draw_grap():
	beauty_animator.play('grab card')
	await beauty_animator.animation_finished
	GameState.emit_signal("turn_pass")

func play_card(card_position : Vector3, card : Card, placement : CardPlacement):
	var tween = get_tree().create_tween()
	var old_pos = target_right_arm.global_position
	tween.tween_property(target_right_arm, "global_position", card_position + Vector3(.4,0,-.2), .5 ).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	
	await tween.finished
	var tween_2 = get_tree().create_tween()
	board.set_card(placement, card)
	tween_2.tween_property(target_right_arm, "global_position", old_pos, .5 ).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await tween_2.finished
	
	GameState.emit_signal("turn_pass")
	
	
func lady_end():
	beauty_animator.play("end")
	await beauty_animator.animation_finished
	GameState.emit_signal("turn_pass")
