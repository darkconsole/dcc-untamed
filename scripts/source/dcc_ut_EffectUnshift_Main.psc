Scriptname dcc_ut_EffectUnshift_Main extends ActiveMagicEffect

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dcc_ut_QuestController Property Untamed Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnEffectStart(Actor target, Actor caster)
{convert the person into the bear.}

	Race cur = target.GetRace()

	If(cur == Untamed.dcc_ut_RaceBearBrown || cur == Untamed.dcc_ut_RaceBearBlack || cur == Untamed.dcc_ut_RaceBearPolar)
		target.DispelSpell(Untamed.dcc_ut_SpellShiftBear)
	ElseIf(cur == Untamed.dcc_ut_RaceCatPlain || cur == Untamed.dcc_ut_RaceCatSnow || cur == Untamed.dcc_ut_RaceCatTint)
		target.DispelSpell(Untamed.dcc_ut_SpellShiftCat)
	EndIf

	Return
EndEvent
