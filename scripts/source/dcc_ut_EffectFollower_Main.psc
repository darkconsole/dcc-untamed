Scriptname dcc_ut_EffectFollower_Main extends activemagiceffect
{this script will handle various processing on the pack members. we accept the
fact that the magic effect containing this script will just randomly vanish from
the actor when crossing load screens, but there is an effect on the player which
is periodically checking the pack to refresh it.}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dcc_ut_QuestController Property Untamed Auto
Actor Property Who Auto Hidden

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnEffectStart(Actor target, Actor caster)
	self.Who = target

	;; we should not do anything special in here. this needs to work properly
	;; without resetting anything every time it is refreshed on the actor.

	If(self == None)
		;; if for some reason this is happening (i have seen it in the logs)
		;; i assume it is because its trying too fast after load or something.
		;; go ahead and drop it now and let the SpellUntamed script attempt to
		;; renew it again.
		Untamed.PrintDebug("dropping broken effect (effect start).")
		target.RemoveSpell(Untamed.dcc_ut_SpellFollower)
	EndIf

	self.RegisterForSingleUpdate(30)
	Return
EndEvent

Event OnUpdate()

	If(self == None)
		;; if for some reason this is happening (i have seen it in the logs)
		;; i assume it is because its trying too fast after load or something.
		;; go ahead and drop it now and let the SpellUntamed script attempt to
		;; renew it again.
		Untamed.PrintDebug("dropping broken effect (effect update).")
		self.Who.RemoveSpell(Untamed.dcc_ut_SpellFollower)
	EndIf

	;; handle growing up.
	;; the cubs spawn at 0.25 scale. at 0.01 per minute it will take 75 minutes
	;; of gameplay for them to reach adulthood.

	;; disabling scaling for now.
	;;If(who.Is3dLoaded())
	;;	Float scale = NetImmerse.GetNodeScale(who,"NPC Root",False)
	;;	;;Untamed.Print(who.GetDisplayName() + " " + scale)
	;;
	;;	If(scale < Untamed.OptPackScale)
	;;		NetImmerse.SetNodeScale(who,"NPC Root",(scale + 0.01),False)
	;;	Else
	;;		If(Untamed.OptBeastsLargerLevel)
	;;			NetImmerse.SetNodeScale(who,"NPC Root",(Untamed.OptPackScale + (0.005 * Untamed.GetLevel(self.Who))),False)
	;;		EndIf
	;;	EndIf
	;;EndIf

	self.RegisterForSingleUpdate(30)
	Return
EndEvent

Event OnDeath(Actor killer)

	Untamed.Print(Untamed.GetActorName(self.Who) + " has fallen!")

	;; the player feels grief at the loss of a companion, and gains power to
	;; fight a little harder for a short time to avenge the fallen pack member.
	;; If(Untamed.GetPackSize() == 0)
		Untamed.dcc_ut_ImodPackLoss.Apply()
		Untamed.dcc_ut_SpellPackLoss.Cast(Untamed.Player,Untamed.Player)
	;; EndIf

	Untamed.RemoveFromPack(self.Who,Untamed.Player)

	Return
EndEvent

Event OnCombatStateChanged(Actor target, Int combatstate)

	;;;;;;;;
	;;;;;;;;
	;; this is a stupid hack, but seeing if it works to help making the actors
	;; dialog bug out less.
	;; self.Who.AllowPCDialogue(False)
	;; self.Who.GetRace().ClearAllowPCDialogue()
	;; self.Who.AllowPCDialogue(True)
	;; self.Who.GetRace().SetAllowPCDialogue()
	;;;;;;;;
	;;;;;;;;

	Return
EndEvent
