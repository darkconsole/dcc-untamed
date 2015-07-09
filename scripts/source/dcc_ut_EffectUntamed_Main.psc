Scriptname dcc_ut_EffectUntamed_Main extends ActiveMagicEffect

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dcc_ut_QuestController Property Untamed Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnEffectStart(Actor target, Actor caster)
	self.OnUpdate()
	Return
EndEvent

Event OnUpdate()

	If(self == None)
		Return
	EndIf

	If(Untamed.OptCheckPack)
		self.UpdatePack()
	EndIf

	self.RegisterForSingleUpdate(10)
	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function UpdatePack()
{this is a really shitty maintenance function because magic effects will just
randomly fall off non-player actors.}

	;; http://www.loverslab.com/topic/42498-help-mgefs-falling-off-actors-spel-ability-constant-effect-still-there/
	;; http://www.loverslab.com/topic/30613-best-practice-for-scripts-attached-to-magic-effects-oneffectfinish-or-registerforsingleupdate/?p=764305

	;; Untamed.WhilePackListLocked("UtUP")
	;; Untamed.PlacePackListLock("UtUP")

	Int a = 0
	Int len = StorageUtil.FormListCount(None,"Untamed.TrackingList")
	Actor what

	While(a < len)
		what = StorageUtil.FormListGet(None,"Untamed.TrackingList",a) as Actor
		If(what == None)
			;; skip lost actors
		ElseIf(what.IsDead())
			;; skip dead actors
		Else
			what.AllowPCDialogue(false)
			what.AllowPCDialogue(true)
			If(!what.HasMagicEffect(Untamed.dcc_ut_EffectFollower))
				what.RemoveSpell(Untamed.dcc_ut_SpellFollower)
				what.AddSpell(Untamed.dcc_ut_SpellFollower)
			EndIf
		EndIf

		If(Untamed.OptCheckPackThrottle)
			Utility.Wait(0.75)
		EndIf

		a += 1
	EndWhile

	;; Untamed.RemovePackListLock("UtUP")
	Return
EndFunction
