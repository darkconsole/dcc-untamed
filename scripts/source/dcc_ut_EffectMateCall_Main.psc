Scriptname dcc_ut_EffectMateCall_Main extends ActiveMagicEffect

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dcc_ut_QuestController Property Untamed Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnEffectStart(Actor target, Actor caster)

	If(!Untamed.OptMateCallIncludeCreature && target.HasKeyword(Untamed.KeywordActorTypeCreature) && !target.HasKeyword(Untamed.KeywordActorTypeAnimal))
		;; Untamed.PrintDebug("mate call w\\creature would have charmed " + target.GetDisplayName())
		Return
	EndIf

	If(Untamed.IsMateCallValid(target,Untamed.Player))
		Untamed.Print(Untamed.GetActorName(target) + " has answered your call!")
		Untamed.AddToPack(target,Untamed.Player)
	ElseIf(Untamed.OptMateCallCharmAll)
		Untamed.AddToPack(target,Untamed.Player)
	EndIf

	Return
EndEvent
