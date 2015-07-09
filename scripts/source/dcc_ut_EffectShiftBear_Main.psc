Scriptname dcc_ut_EffectShiftBear_Main extends ActiveMagicEffect

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dcc_ut_QuestController Property Untamed Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnEffectStart(Actor target, Actor caster)
{convert the person into the bear.}

	Race which

	Debug.SendAnimationEvent(target,"arrok_doggystyle_a1_s1")

	;; determine which variant to use.
	If(Untamed.OptFormBear == 0)
		which = Untamed.dcc_ut_RaceBearBrown
	ElseIf(Untamed.OptFormBear == 1)
		which = Untamed.dcc_ut_RaceBearBlack
	ElseIf(Untamed.OptFormbear == 2)
		which = Untamed.dcc_ut_RaceBearPolar
	Else
		which = Untamed.dcc_ut_RaceBearBlack
	EndIf

	;; give the sfx some time to sfx.
	Utility.Wait(1.5)

	;; shapeshift.
	Untamed.Shapeshift(target,which)
	Return
EndEvent

Event OnEffectFinish(Actor target, Actor caster)
{restore the person to normal gameplay.}

	Untamed.Shapeunshift(target)
	Return
EndEvent
