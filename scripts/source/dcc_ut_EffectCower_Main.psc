Scriptname dcc_ut_EffectCower_Main extends ActiveMagicEffect

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dcc_ut_QuestController Property Untamed Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnEffectStart(Actor target, Actor caster)

	Untamed.Print("Attempting to slip away from " + target.GetDisplayName())
	;; so here is a shittone of code i am going to write assuming i can get it
	;; to work in ck later. the idea is that we cast an aoe on ourself that hits
	;; anyone who is attacking the player. we then sic the pack on them and then
	;; try to remove the player from the aggrostream.

	Int len = Untamed.GetPackSize()
	Int cur = 0
	Actor who

	;; confuse everything involved.
	caster.StopCombat()
	caster.StopCombatAlarm()

	;; send the pack in. only send the ones that are nearby and not doing
	;; anything special.
	While(cur < len)
		who = Untamed.GetPackMember(cur)

		If(who.GetDistance(target) < 1000 && who.GetCurrentPackage() == Untamed.dcc_ut_PackageFollowPlayer)
			Untamed.PrintDebug("Sicking " + who.GetDisplayName() + " on " + target.GetDisplayName())
			who.StartCombat(target)
			target.StartCombat(who)
		EndIf

		cur += 1
	EndWhile

	;; pull the player out of the combat again.
	;; caster.StopCombat()
	;; caster.StopCombatAlarm()
	;; commenting these extras out, because removing you from combat will also
	;; remove your teammates from combat, it seems, at least for actor types
	;; which unaggro easy like bears.

	Return
EndEvent
