Scriptname dcc_ut_EffectShiftCat_Main extends ActiveMagicEffect

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dcc_ut_QuestController Property Untamed Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnEffectStart(Actor target, Actor caster)
{convert the person into the bear.}

	Race which

	Debug.SendAnimationEvent(target,"arrok_doggystyle_a1_s1")

	If(Untamed.OptFormCat == 0)
		which = Untamed.dcc_ut_RaceCatTint
	ElseIf(Untamed.OptFormCat == 1)
		which = Untamed.dcc_ut_RaceCatPlain
	ElseIf(Untamed.OptFormCat == 2)
		which = Untamed.dcc_ut_RaceCatSnow
	Else
		which = Untamed.dcc_ut_RaceCatTint
	EndIf

	;; give the sfx some time to sfx.
	Utility.Wait(1.5)

	;; shapeshift.
	Untamed.Shapeshift(target,which)
	If(Untamed.OptFormCat == 0)
		Game.UpdateHairColor()
	EndIf
	Return
EndEvent

Event OnEffectFinish(Actor target, Actor caster)
{restore the person to normal gameplay.}

	Untamed.Shapeunshift(target)
	Return
EndEvent
