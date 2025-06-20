extends Node

# signals regarding dialogue
@warning_ignore("unused_signal") signal readDialogueSignal(dialogueString : String)
@warning_ignore("unused_signal") signal resetReadDialogue(dialogueString : String)
@warning_ignore("unused_signal") signal dialogueCompletedSignal

# signals regarding game state
@warning_ignore("unused_signal") signal changeStage
@warning_ignore("unused_signal") signal changePlayerState(enumStateName : String)
@warning_ignore("unused_signal") signal changeLadyState(enumStateName : String)
@warning_ignore("unused_signal") signal changeItemState(enumStateName : String)
@warning_ignore("unused_signal") signal getPlayerState
@warning_ignore("unused_signal") signal sendPlayerState(enumStateName : String)

# signals regarding any of the animations
@warning_ignore("unused_signal") signal ladyAnimationComplete
