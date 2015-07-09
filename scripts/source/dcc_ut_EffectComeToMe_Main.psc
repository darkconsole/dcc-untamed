Scriptname dcc_ut_EffectComeToMe_Main extends activemagiceffect

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dcc_ut_QuestController Property Untamed Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function OnEffectStart(Actor target, Actor caster)

	Untamed.WhilePackListLocked("CTM")
	Untamed.PlacePackListLock("CTM")

	;; first thing is to make sure the list is clean.
	Untamed.CleanPackList(False)

	Int len = StorageUtil.FormListCount(None,"Untamed.TrackingList")
	Int a
	Actor who

	;; try and give the imod time to fade to black.
	Utility.Wait(0.75)

	a = 0
	While(a < len)
		who = StorageUtil.FormListGet(None,"Untamed.TrackingList",a) as Actor

		If(who == None)
			;; actor got reckt.
			Untamed.PrintDebug("reckt")
		ElseIf(Untamed.OptCallSkipToldStay && who.GetCurrentPackage() == Untamed.dcc_ut_PackageDoNothing)
			;; literally do nothing
			Untamed.PrintDebug("staying behind " + who.GetDisplayName() + " " + who.GetFormId())
		Else
			Untamed.PrintDebug("teleporting " + who.GetDisplayName() + " " + who.GetFormId())
			who.MoveTo(Untamed.Player)
		EndIf

		a += 1
	EndWhile

	Untamed.RemovePackListLock("CTM")
	Return
EndFunction

