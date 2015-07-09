Scriptname dcc_ut_QuestLooter_TheLooter extends ReferenceAlias

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dcc_ut_QuestController Property Untamed Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnPackageEnd(Package old)
	ReferenceAlias looterr = Untamed.dcc_ut_QuestLooter.GetAliasByName("TheLooter") as ReferenceAlias
	ReferenceAlias deadbodyr = Untamed.dcc_ut_QuestLooter.GetAliasByName("TheDead") as ReferenceAlias
	Actor looter = looterr.GetRef() as Actor
	Actor deadbody = deadbodyr.GetRef() as Actor

	If(deadbody == Untamed.Player)
		;; no. the player is not really dead. this is the cue we give from
		;; Untamed.FollowerLoot(looter) to stop when there are no more dudes to
		;; loot.

		;; drop the alias and reset behaviour.
		looterr.Clear()
		Untamed.BehaviourDefault(looter)

		;; then give the player the shit.
		looter.OpenInventory()
		Return
	EndIf

	;; ninja the shit
	Untamed.LootTake(looter,deadbody)

	;; try to find another dead body.
	Untamed.FollowerLoot(looter,False)

	Return
EndEvent
