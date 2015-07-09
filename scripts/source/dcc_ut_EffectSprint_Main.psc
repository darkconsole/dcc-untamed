Scriptname dcc_ut_EffectSprint_Main extends activemagiceffect

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dcc_ut_QuestController Property Untamed Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnEffectStart(Actor target, Actor caster)

	;; reflect this spell back on the caster. the condition on the mgef which
	;; makes sure we don't have this mgef is what stops this from bubbling until
	;; infinity. this means this wont really work unless there is a valid beast
	;; follower. this is intentional.

	;; this could theoretically also create a chain where you have a whole line
	;; of beast followers told to hold. if you shout in range of the nearest it
	;; will bubble all the way down the line. also intentional.

	;; the main reason is that the caster of the aoe is not inluded in the aoe
	;; hit set... so... we need to hit the player somehow.

;;	Untamed.dcc_ut_SpellSprint.Cast(target,target)

	Utility.Wait(1.0)
	Input.HoldKey(Input.GetMappedKey("Sprint"))
	Utility.Wait(0.5)
	Input.ReleaseKey(Input.GetMappedKey("Sprint"))

	Return
EndEvent

Event OnEffectFinish(Actor target, Actor caster)
	Input.HoldKey(Input.GetMappedKey("Sprint"))
	Utility.Wait(0.1)
	Input.ReleaseKey(Input.GetMappedKey("Sprint"))
	Return
EndEvent
