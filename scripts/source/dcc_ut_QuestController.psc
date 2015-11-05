Scriptname dcc_ut_QuestController extends Quest
{Main controller for the entire mod.}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; StorageUtil keys
;; Global Int      Untamed.UpdateBuffLock
;; Global Form     Untamed.TrackingList
;; Actor Float     Untamed.Level
;; Actor Int       Untamed.Count.Bears
;; Actor Int       Untamed.Count.Beasts
;; Actor Int       Untamed.Count.Cats
;; Actor Int       Untamed.Count.People
;; Actor Form      Untamed.Shapeshift.OriginalRace
;; Actor FormList  Untamed.Shapeshift.Items

;; adding beast forms
;; 1a. edit beast skeleton to add third person camera node and subnodes.
;; 1b. make sure the nodes have proper names.
;; 2. make ListRaceWhatever array, populate in CK with valid matching races.
;; 3. make Effect, Spell, and Script for transform. see bear as template.
;; 4a. add actions to the gameplay > animations list for that race type.
;; 4b. ActionLeftAttack lattk1, ActionRightAttack rattk1, ActionDualAttack pattk1, ActionJump pattk2
;; 5. add stat for base race encounter counting
;; 6. add spell to transform into that race when over threshold.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; basic and core framework references.
Actor   Property Player Auto
SexlabFramework Property SexLab Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; stock index references.
ActorBase Property SabreCat Auto
GlobalVariable Property GlobalTimescale Auto
Faction Property FactionFollowerCurrent Auto
Faction Property FactionFollower Auto
Faction Property FactionPlayer Auto
Faction Property FactionPredator Auto
Keyword Property KeywordActorTypeAnimal Auto
Keyword Property KeywordActorTypeCreature Auto
Race Property RaceMammoth Auto
Race Property RaceWerewolf Auto

Race[] Property ListRaceBear Auto
Race[] Property ListRaceCat Auto

;; untamed index references.
ImageSpaceModifier Property dcc_ut_ImodCallToMe Auto
ImageSpaceModifier Property dcc_ut_ImodCmdMenu Auto
ImageSpaceModifier Property dcc_ut_ImodPowerAwaken Auto
ImageSpaceModifier Property dcc_ut_ImodPackLoss Auto
ImageSpaceModifier Property dcc_ut_ImodTaunt Auto
Faction            Property dcc_ut_FactionFollower Auto
MagicEffect        Property dcc_ut_BuffResistMagic Auto
MagicEffect        Property dcc_ut_BuffResistPhysical Auto
MagicEffect        Property dcc_ut_EffectFollower Auto
Message            Property dcc_ut_MsgShoutCower Auto
Message            Property dcc_ut_MsgPerkBeastCarry Auto
Message            Property dcc_ut_MsgPerkLooter Auto
Message            Property dcc_ut_MsgPerkExtendSprint Auto
Message            Property dcc_ut_MsgPowerAwaken Auto
Message            Property dcc_ut_MsgShiftBear Auto
Message            Property dcc_ut_MsgShiftCat Auto
Message            Property dcc_ut_MsgShoutFollow Auto
Message            Property dcc_ut_MsgShoutLastStand Auto
Message            Property dcc_ut_MsgShoutRename Auto
Message            Property dcc_ut_MsgShoutSprint Auto
Message            Property dcc_ut_MsgShoutStay Auto
Message            Property dcc_ut_MsgShoutTaunt Auto
Message            Property dcc_ut_MsgSpellIFF Auto
MiscObject         Property dcc_ut_ItemLooterCard Auto
Package            Property dcc_ut_PackageDoNothing Auto
Package            Property dcc_ut_PackageFollowPlayer Auto
Package            Property dcc_ut_PackageLooter Auto
Perk               Property dcc_ut_PerkBeastCarry Auto
Perk               Property dcc_ut_PerkExtendSprint Auto
Perk               Property dcc_ut_PerkLooter Auto
Quest              Property dcc_ut_QuestLooter Auto
Race               Property dcc_ut_RaceBearBlack Auto
Race               Property dcc_ut_RaceBearBrown Auto
Race               Property dcc_ut_RaceBearPolar Auto
Race               Property dcc_ut_RaceCatTint Auto
Race               Property dcc_ut_RaceCatPlain Auto
Race               Property dcc_ut_RaceCatSnow Auto
Shout              Property dcc_ut_ShoutCower Auto
Shout              Property dcc_ut_ShoutFollow Auto
Shout              Property dcc_ut_ShoutComeToMe Auto
Shout              Property dcc_ut_ShoutLastStand Auto
Shout              Property dcc_ut_ShoutMateCall Auto
Shout              Property dcc_ut_ShoutRename Auto
Shout              Property dcc_ut_ShoutSprint Auto
Shout              Property dcc_ut_ShoutStay Auto
Shout              Property dcc_ut_ShoutTaunt Auto
Sound              Property dcc_ut_SoundCmdMenu Auto
Sound              Property dcc_ut_SoundPowerAwaken Auto
Spell              Property dcc_ut_SpellBeastial Auto
Spell              Property dcc_ut_SpellCmdMenu Auto
Spell              Property dcc_ut_SpellCower Auto
Spell              Property dcc_ut_SpellFollower Auto
Spell              Property dcc_ut_SpellGiveBirth Auto
Spell              Property dcc_ut_SpellIFF Auto
Spell              Property dcc_ut_SpellLooter Auto
Spell              Property dcc_ut_SpellPackLoss Auto
Spell              Property dcc_ut_SpellShiftBear Auto
Spell              Property dcc_ut_SpellShiftCat Auto
Spell              Property dcc_ut_SpellSprint Auto
Spell              Property dcc_ut_SpellStanceTank Auto
Spell              Property dcc_ut_SpellStanceDamage Auto
Spell              Property dcc_ut_SpellTaunt Auto
Spell              Property dcc_ut_SpellUnshift Auto
Spell              Property dcc_ut_SpellUntamed Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; mod options.
Float Property OptScaleLevel = 1.0 Auto Hidden
{laying with a beast incremements the untamed level by this much.}

Float Property OptMaxLevel = 100.0 Auto Hidden
{the maximum untamed level that can be achieved. all the default maths that are
designed not to be game breaking out of the box are based on this being 100.}

Float Property OptBaseResistPhysical = 50.0 Auto Hidden
{the base fake armor you get for laying with animals.}

Float Property OptBaseResistMagic = 5.0 Auto Hidden
{the base fake magic resist you get for laying with animals.}

Float Property OptScaleResistPhysical = 5.0 Auto Hidden
{how much your armor scales. ((scale * utlvl) + base)}

Float Property OptScaleResistMagic = 0.6 Auto Hidden
{how much your magic resist scales. ((scale * utlvl) + base)}

Float Property OptUpdateBuffLockDelay = 0.75 Auto Hidden
{how long to wait before trying to process an actors level again. works with
the update buff lock function.}

Float Property OptPackScale = 1.0 Auto Hidden
{the default size for members of your pack.}

Float Property OptPregTime = 3.0 Auto Hidden
{how long in game time a preg should sit before its considered ready.}

Float Property OptScaleShoutLevel = 0.125 Auto Hidden
{how much your untamed levels each time you shout.}

Bool Property OptCheckPack = True Auto Hidden
{this will allow an update loop which will make sure all your pack members have
the follower effect every so often. its an option in case it causes studders on
slow machines or large packs.}

Bool Property OptCheckPackThrottle = False Auto Hidden
{this will prompt a wait between each updated pack member to try and ease any
jerking.}

Bool Property OptDebug = False Auto Hidden
{to enable debugging messages or not.}

Bool Property OptPostSexEffect = True Auto Hidden
{to enable the post-sex screen visual effects and sounds}

Bool Property OptPostSexFollow = True Auto Hidden
{to enable beasts to follow whoever they had sex with.}

Bool Property OptPostSexHeal = True Auto Hidden
{to enable healing both parties after an encounter.}

Bool Property OptPostSexPack = False Auto Hidden
{if anything intercoursed should be added to pack.}

Bool Property OptMakePackDocile = True Auto Hidden
{attempt to make the beast followers not fight everything they see.}

Bool Property OptMateCallCharmAll = True Auto Hidden
{charm all the animals that heard the mating call, not just the one that was
fast enough to sex you.}

Bool Property OptMateCallCalmAll = True Auto Hidden
{if we should try and stop combat on anything mate call hit.}

Bool Property OptMateCallSkipPack = True Auto Hidden
{ignore animals already in the pack on the mate call.}

Bool Property OptMateCallEngage = True Auto Hidden
{mate call will automatically trigger sexy time.}

Bool Property OptMateCallIncludeCreature = False Auto Hidden
{mate call will include the extended creature range.}

Bool Property OptCallSkipToldStay = True Auto Hidden
{call to me can be told to skip those who are holding short.}

Bool Property OptEnablePreg = True Auto Hidden
{if to enable the preg features or not.}

Bool Property OptBeastsCanLevel = True Auto Hidden
{if beasts should level from sexing.}

Bool Property OptBeastsLargerLevel = False Auto Hidden
{if beasts should get larger the higher level they are.}

Bool Property OptLooterClearInv = True Auto Hidden
{if beasts should delete all the crap they picked up after you close inventory.}

Bool Property OptCmdMenu = True Auto Hidden
{use the command radial menu instead of dialog.}

Bool Property OptJerkoffMode = False Auto Hidden
{start sex again right after finishing it until canceled.}

Bool Property OptBeastLevelCatchup = True Auto Hidden
{beasts will level faster the greater the gap between your level and theirs.}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ability progression.
Int Property OptCountUnlockShift    = 10 Auto Hidden
Int Property OptLvlShoutStay        = 1 Auto Hidden
Int Property OptLvlShoutFollow      = 2 Auto Hidden
Int Property OptLvlShoutSprint      = 10 Auto Hidden
Int Property OptLvlShoutLastStand   = 15 Auto Hidden
Int Property OptLvlShoutRename      = 20 Auto Hidden
Int Property OptLvlPerkExtendSprint = 22 Auto Hidden
Int Property OptLvlPerkLooter       = 25 Auto Hidden
Int Property OptLvlShoutTaunt       = 30 Auto Hidden
Int Property OptLvlShoutCower       = 35 Auto Hidden
Int Property OptLvlSpellIFF         = 40 Auto Hidden
Int Property OptLvlPerkBeastCarry   = 50 Auto Hidden

;; pack stat progression.
Float Property OptBeastScaleHealth = 5.0 Auto Hidden
Float Property OptBeastScaleStamina = 5.0 Auto Hidden
Float Property OptBeastScaleAttackDamage = 0.005 Auto Hidden
Float Property OptBeastScaleDamageResist = 5.0 Auto Hidden
Float Property OptBeastScaleMagicResist = 0.007 Auto Hidden

;; what colour of the animals we want to be. these values line up with the
;; races put into the ListRace arrays.
Int Property OptFormBear = 0 Auto Hidden
Int Property OptFormCat = 0 Auto Hidden

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Int Property PackListLock = 0 Auto Hidden
Int Property UpdateBuffLock = 0 Auto Hidden

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; moonlight tales integration.
Bool  Property MT_Enabled = False Auto Hidden
Float Property MT_OptWerewolfSTD = 2.0 Auto Hidden
Spell Property MT_SpellWerewolfSTD Auto Hidden

Function MT_OnEncounterEnd(Actor[] actors)
{handle the results of having an encounter with a werewolf.}

	If(!self.MT_Enabled)
		Return
	EndIf

	Int a
	Bool wolfed = False

	;; check if a werewolf was involved.

	a = 0
	While(a < actors.Length)
		If(actors[a].GetRace() == self.RaceWerewolf)
			wolfed = True
		EndIf

		a += 1
	EndWhile

	;; if so spread the disease.

	If(wolfed)
		a = 0
		While(a < actors.Length)
			If(actors[a].GetRace() != self.RaceWerewolf && !actors[a].HasSpell(self.MT_SpellWerewolfSTD))
				If(self.MT_OptWerewolfSTD > Utility.RandomFloat(0.0,100.0))
					self.Print(actors[a].GetDisplayName() + " has contracted Sanies Lupinus.")
					actors[a].AddSpell(self.MT_SpellWerewolfSTD)
				EndIf
			EndIf

			a += 1
		EndWhile
	EndIf

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

String Function GetActorName(Actor who)
{an easier to type function for getting the actor name.}

	;;Return who.GetActorBase().GetName()
	Return who.GetDisplayName()
EndFunction

Race Function GetActorRace(Actor who)
{an easier to type function for getting actor race.}

	Return who.GetActorBase().GetRace()
	;;Return who.GetLeveledActorBase().GetRace()
	;;Return who.GetRace()
EndFunction

Function Print(String msg)
{an easier to type function for printing messages out the notification area.}

	Debug.Notification("[UT] " + msg)
	Return
EndFunction

Function PrintDebug(String msg)
{disableable debugging messages.}

	If(self.OptDebug)
		self.Print(msg)
	EndIf

	Return
EndFunction

Function HasMoonlightTales()
{check if we have moonlight tales for werewolf std.}

	Int mod = Game.GetModByName("Brevi_MoonlightTales.esp")
	If(mod != 255)
		self.Print("Moonlight Tales integration enabled.")
		self.MT_Enabled = True
		self.MT_SpellWerewolfSTD = Game.GetFormFromFile(0x09d8ce,"Brevi_MoonlightTales.esp") as Spell
	Else
		self.MT_Enabled = False
		self.MT_SpellWerewolfSTD = None
	EndIf

	Return
EndFunction

Function HasUiExtensions()
{make sure the mods this mod depends on exist.}

	Int mod = Game.GetModByName("UIExtensions.esp")

	If(mod == 255)
		String msg
		msg = "You do not appear to have UIExtensions installed or activated. "
		msg += "Stop being bad, read the info for mods you install.\n\n"
		msg += "UIExtensions: http://www.nexusmods.com/skyrim/mods/57046/\n\n"
		msg += "Cats make the best cuddle buddies."
		Debug.MessageBox(msg)
		self.FunkSoulBrother()
	EndIf

	Return
EndFunction

Function FunkSoulBrother()
{<casually whistles to self>}

	Actor friend

	While(Game.GetModByName("UIExtensions.esp") == 255)
		friend = self.Player.PlaceAtMe(self.SabreCat) as Actor
		friend.ForceActorValue("Health",9001)
		friend.ForceActorValue("AttackDamageMult",0.1)
		friend.StartCombat(self.Player)
		Utility.Wait(4)
	EndWhile

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function ResetMod(Bool playertoo)
{reset the entire mod to factory settings.}

	self.ResetQuest()
	self.ResetModValues()

	If(playertoo)
		self.ResetActorValues(Game.GetPlayer())
	EndIf

	self.Print("Untamed has restarted.")
	Return
EndFunction

Function ResetQuest()
{reset the quests involved with this mod.}

	self.PrintDebug("Reset Mod Quest")

	;; http://www.loverslab.com
	;; /blog/199/entry-844-alias-refilling-on-non-clean-saves-and-quest-reset/

	self.Reset()
	Utility.Wait(1)
	self.Stop()
	Utility.Wait(1)
	self.Start()
	Utility.Wait(1)

	Return
EndFunction

Function ResetModValues()
{reset all the options and settings of this mod to their default values.}

	self.PrintDebug("Reset Mod Values")
	self.RemoveUpdateBuffLock()
	self.RemovePackListLock()

	self.OptScaleLevel = 1.0
	self.OptMaxLevel = 100.0
	self.OptBaseResistPhysical = 50
	self.OptBaseResistMagic = 5.0
	self.OptPackScale = 1.0
	self.OptScaleResistPhysical = 5.0
	self.OptScaleResistMagic = 0.6
	self.OptScaleShoutLevel = 0.125
	self.OptUpdateBuffLockDelay = 0.75
	self.OptDebug = False
	self.OptPostSexEffect = True
	self.OptPostSexFollow = True
	self.OptPostSexHeal = True
	self.OptPostSexPack = False
	self.OptCheckPack = True
	self.OptCheckPackThrottle = False
	self.OptMakePackDocile = True
	self.OptMateCallCharmAll = True
	self.OptMateCallCalmAll = True
	self.OptMateCallSkipPack = True
	self.OptMateCallEngage = True
	self.OptMateCallIncludeCreature = False
	self.OptCallSkipToldStay = True
	self.OptBeastsCanLevel = True
	self.OptBeastsLargerLevel = False
	self.OptCmdMenu = True
	self.OptJerkoffMode = False
	self.OptCountUnlockShift = 10
	self.OptLvlShoutStay = 1
	self.OptLvlShoutFollow = 2
	self.OptLvlShoutSprint = 10
	self.OptLvlShoutLastStand = 15
	self.OptLvlShoutRename = 20
	self.OptLvlPerkExtendSprint = 22
	self.OptLvlPerkLooter = 25
	self.OptLvlShoutTaunt = 30
	self.OptLvlShoutCower = 35
	self.OptLvlSpellIFF = 40
	self.OptLvlPerkBeastCarry = 50
	self.OptFormBear = 0
	self.OptFormCat = 1

	;; reset events.
	self.UnregisterForModEvent("OrgasmStart")
	self.UnregisterForModEvent("OrgasmEnd")
	Utility.Wait(0.25)
	self.RegisterForModEvent("OrgasmStart","OnEncounterEnd")
	Utility.Wait(0.25)

	;; reset mod core interface spells.
	self.Player.RemoveSpell(self.dcc_ut_SpellCmdMenu)
	self.Player.RemoveSpell(self.dcc_ut_SpellUntamed)
	self.Player.AddSpell(self.dcc_ut_SpellCmdMenu)
	self.Player.AddSpell(self.dcc_ut_SpellUntamed)

	;; add base interaction spells.
	self.Player.RemoveShout(self.dcc_ut_ShoutComeToMe)
	self.Player.RemoveShout(self.dcc_ut_ShoutMateCall)
	self.GiveShout(self.Player,self.dcc_ut_ShoutComeToMe)
	self.GiveShout(self.Player,self.dcc_ut_ShoutMateCall)

	;; add command menu interaction.
	self.UnregisterCmdMenu()
	self.RegisterCmdMenu()

	Return
EndFunction

Function ResetActorValues(Actor who)
{clear this actor of all storage util data and reset any features.}

	self.PrintDebug("Reset Actor Values")
	StorageUtil.UnsetFloatValue(who,"Untamed.Level")
	StorageUtil.UnsetIntValue(who,"Untamed.Count.Beasts")
	StorageUtil.UnsetIntValue(who,"Untamed.Count.People")

	who.RemovePerk(self.dcc_ut_PerkLooter)
	who.RemoveSpell(self.dcc_ut_SpellLooter)
	who.RemoveShout(self.dcc_ut_ShoutStay)
	who.RemoveShout(self.dcc_ut_ShoutFollow)
	who.RemoveShout(self.dcc_ut_ShoutSprint)
	who.RemoveShout(self.dcc_ut_ShoutLastStand)
	who.RemoveShout(self.dcc_ut_ShoutRename)

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnInit()
{hello world}

	;; self.ResetMod()
	self.ResetModValues()

	;; this is a little catch to prevent resetting the actor data quest restart
	;; so the auto reset actor value should only init first time mod loads ever.
	If(!self.Player.HasSpell(self.dcc_ut_SpellUntamed))
		self.ResetActorValues(self.Player)
	EndIf

	Return
EndEvent

Event OnEncounterEnd(String EventName, String Args, Float Argc, Form From)
{catch when an encounter ends so that we can intrement stats.}

	Actor[] actors = SexLab.HookActors(Args)
	sslBaseAnimation ani = SexLab.HookAnimation(Args)
	sslThreadController ctrl = SexLab.HookController(Args)

	Int beastcount = SexLab.CreatureCount(actors)
	Int peoplecount = actors.Length - beastcount
	Bool hasplayer = False

	self.PrintDebug("Encounter Ended (" + peoplecount + " ppl, " + beastcount + "beast)")

	;;;;;;;;
	;;;;;;;;

	;; determine if the player was involved in this scene.

	Int a = 0
	While(a < actors.Length)
		If(actors[a] == self.Player)
			hasplayer = True
		EndIf
		a += 1
	EndWhile

	If(self.MT_Enabled)
		self.MT_OnEncounterEnd(actors)
	EndIf

	;;;;;;;;
	;;;;;;;;

	;; handle encounter with the player.

	If(hasplayer)
		If(self.OptJerkoffMode && StorageUtil.GetIntValue(self.Player,"Untamed.JerkoffMode") == 1)
			Game.EnablePlayerControls(true,false,false,true,false,false,false,false,0)
			Utility.Wait(ctrl.GetStageTimer(ctrl.Timers.Length - 1) * 0.75)
			ctrl.Stage = 2
			ctrl.ChangeAnimation()
		EndIf

		self.ProgressCountBeasts(self.Player,beastcount)
		self.ProgressLevel(self.Player,True,beastcount,False)
		self.ProgressLevel(self.Player,False,(peoplecount - 1),True)
		self.UpdateBuffValues(self.Player)
		self.PrintDebug(self.Player.GetDisplayName() + " updated.")

		;;;;;;;;
		;;;;;;;;

		a = 0
		While(a < actors.Length)
			If(self.OptPostSexHeal)
				actors[a].RestoreActorValue("Health",9001)
				actors[a].RestoreActorValue("Stamina",9001)
				actors[a].RestoreActorValue("Magicka",9001)
			EndIf

			If(SexLab.GetGender(actors[a]) == 2)
				If(self.OptBeastsCanLevel)
					self.ProgressLevel(actors[a],true,1)
				EndIf

				If(self.OptPostSexPack && !actors[a].IsInFaction(self.dcc_ut_FactionFollower))
					self.AddToPack(actors[a],self.Player)
				EndIf

				If(self.OptEnablePreg && (!self.IsPreg(self.Player) || self.OptPregTime == 0.0))
					self.SetPregWith(self.Player,actors[a])
					self.SetPregTime(self.Player)
					self.GiveSpell(self.Player,self.dcc_ut_SpellGiveBirth)
				ElseIf(!self.OptEnablePreg)
					self.Player.RemoveSpell(self.dcc_ut_SpellGiveBirth)
				EndIf

				If(self.IsRaceBear(actors[a]))
					self.ProgressCountBears(self.Player)
				ElseIf(self.IsRaceCat(actors[a]))
					self.ProgressCountCats(self.Player)
				EndIf
			Else
				self.dcc_ut_SpellBeastial.Cast(actors[a],actors[a])
			EndIf

			a += 1
		EndWhile

		;;;;;;;;
		;;;;;;;;

	EndIf

	;;;;;;;;
	;;;;;;;;

	Return
EndEvent

Event OnEncounterFinished(String EventName, String Args, Float Argc, Form From)
{when sexlab is completely done.}

	Actor[] actors = SexLab.HookActors(Args)
	sslBaseAnimation ani = SexLab.HookAnimation(Args)

	bool hasplayer = False

	Int a = 0
	While(a < actors.Length)
		If(actors[a] == self.Player)
			hasplayer = True
		EndIf
		a += 1
	EndWhile


	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function RegisterCmdMenu()
	self.RegisterForControl("Activate")
	Return
EndFunction

Function UnregisterCmdMenu()
	self.UnregisterForControl("Activate")
	Return
EndFunction

Event OnControlDown(String ctrl)
{handle talking to animals.}

	If(ctrl == "Jump")
		self.OnControlDown_Shout()
	ElseIf(ctrl == "Activate")
		;; self.OnControlDown_Activate()
	EndIf

	Return
EndEvent

Event OnControlUp(String ctrl, Float time)
{handle press times}

	If(ctrl == "Activate")
		If(time < 0.5)
			self.OnControlUp_ShortActivate()
		Else
			self.OnControlUp_LongActivate()
		EndIf
	EndIf

	Return
EndEvent

Function OnControlDown_Shout()
{handle pressing [RB]}

	If(StorageUtil.GetIntValue(self.Player,"Untamed.JerkoffMode") == 1)
		self.UnregisterForControl("Jump")
		;;self.UnregisterForModEvent("AnimationEnd")
		StorageUtil.UnsetIntValue(self.Player,"Untamed.JerkoffMode")
		self.UnregisterCmdMenu()
		Debug.MessageBox("Infinite Mode cancelled. This will be the last encounter.")
		self.RegisterCmdMenu()
	EndIf

EndFunction

Function OnControlUp_ShortActivate()
{handle tapping (A)}

	Actor animal = Game.GetCurrentCrosshairRef() as Actor
	If(animal == None || !animal.IsInFaction(self.dcc_ut_FactionFollower) || animal.IsDoingFavor())
		Return
	EndIf

	self.dcc_ut_SoundCmdMenu.Play(self.Player)
	self.dcc_ut_ImodCmdMenu.Apply()
	animal.AllowPCDialogue(False)
	self.FollowerCmdMenu(animal)

	Return
EndFunction

Function OnControlUp_LongActivate()
{handle longpressing (A)}

	Actor animal = Game.GetCurrentCrosshairRef() as Actor
	If(animal == None || !animal.IsInFaction(self.dcc_ut_FactionFollower))
		Return
	EndIf

	animal.AllowPCDialogue(False)
	animal.GetRace().SetAllowPCDialogue()
	Utility.Wait(0.1)

	If(animal.IsDoingFavor() || animal.GetActorValue("WaitingForPlayer") == 1)
		animal.SetDoingFavor(False)
		animal.SetActorValue("WaitingForPlayer",0)
		self.Print(animal.GetDisplayName() + " will returns to normal behaviour.")
	Else
		animal.SetDoingFavor(True)	
		self.Print(animal.GetDisplayName() + " is awaiting command...")
	EndIf
	
	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Bool Function IsInRaceList(Actor who, Race[] list)

	Race what = who.GetRace()
	Int len = list.Length
	Int a

	While(a < len)
		If(what == list[a])
			Return True
		EndIf

		a += 1
	EndWhile

	Return False
EndFunction

Bool function IsRaceBear(Actor who)
{determine if this was a bear.}

	Return self.IsInRaceList(who,self.ListRaceBear)
EndFunction

Bool function IsRaceCat(Actor who)
{determine if this was a cat.}

	Return self.IsInRaceList(who,self.ListRaceCat)
EndFunction

Bool Function IsSexable(Actor what, Actor who)
{determine if we can sex the specified actor. im going to write this as a lol
cascade.}

	;; if the creature has a sex animation...
	If(SexLab.AllowedCreature(self.GetActorBase(what).GetRace()))
		;; and neither party is currently sexing something.

		If(!SexLab.IsActorActive(what) && !SexLab.IsActorActive(who))
			Return True
		Else
			self.PrintDebug(what.GetDisplayName()+" or "+who.GetDisplayName()+" is currently Sexlab Active.")
		EndIf
	Else
		self.PrintDebug(what.GetDisplayName()+" ("+self.GetActorBase(what).GetRace().GetName()+") is not in SexLab.AllowedCreature")
	EndIf

	Return False
EndFunction

Bool Function IsMateCallValid(Actor what, Actor who)
{determine if this animal is a valid selection for the mate call.}

	If(!self.IsSexable(what,who))
		self.PrintDebug(what.GetDisplayName()+" is not sexable.")
		Return False
	EndIf

	If(self.OptMateCallSkipPack && what.IsInFaction(self.dcc_ut_FactionFollower))
		self.PrintDebug(what.GetDisplayName()+" is already in pack.")
		Return False
	EndIf

	Return True
EndFunction

Function StopCombat(Actor who)
{if the option is enabled, attempt to calm the target.}

	;;If(self.OptMateCallCalmAll)
	who.StopCombat()
	who.StopCombatAlarm()
	self.Player.StopCombatAlarm()
	;;EndIf

	Return
EndFunction

ActorBase Function GetActorBase(Actor who)
{attempt to fetch the first actual legit actor base that we can use to clone an
actor with. we have to be careful because most actors in the world seem to be
temporary (ffxxxxxx) and will be garbage collected. when this happens our new
spawns will be different or cause crashes.}

	;; inspired by Skyrimfloo
	;; http://www.loverslab.com/topic/42343-untamed/?p=1069356

	ActorBase flat = who.GetActorBase()
	ActorBase lvld = who.GetLeveledActorBase()
	ActorBase tmpl = None

	If(flat != lvld)
		tmpl = lvld.GetTemplate()

		If(tmpl != None)
			flat = tmpl
		EndIf
	EndIf

	Return flat
EndFunction

Actor Function Clone(Actor who)
{clone the actor with force persist. delete the old.}

	ObjectReference newactor

	;; create a copy of what we have been given.
	;;newactor = who.PlaceAtMe(who.GetLeveledActorBase(),1,True,False)
	;;newactor = who.PlaceAtMe(who.GetActorBase(),1,True,False)
	newactor = who.PlaceAtMe(self.GetActorBase(who),1,True,False)

	If(self.OptDebug)
		String spawnmsg = ""
		spawnmsg += "spawned " + (newactor as Actor).GetDisplayName() + " [" + (newactor as Actor).GetFormID() + ", " + (newactor as Actor).GetRace().GetName() + ", " + (newactor as Actor).GetRace().GetFormID() + "]"
		spawnmsg += "\n\n"
		spawnmsg += "from " + who.GetDisplayName() + " [" + who.GetFormID() + ", " + who.GetRace().GetName() + ", " + who.GetRace().GetFormID() + "] "
		Debug.MessageBox(spawnmsg)
	EndIf

	;; wait for it to load.
	While(!newactor.Is3DLoaded() || newactor.IsDisabled())
		Utility.Wait(0.25)
	EndWhile

	;; vanish the old one.
	who.DisableNoWait()

	;; move new the old.
	newactor.MoveTo(who)

	;; get rid of the old.
	who.Delete()

	Return (newactor as Actor)
EndFunction

Bool Function GiveShout(Actor who, Shout what, bool unlock=True)
{give the actor the specified shout. by the way wiki says that giving shouts
to anyone not the player will fuck the savegame. so don't do that. returns if
we had to give it or not.}

	If(who != self.Player)
		Return False
	EndIf

	If(!who.HasSpell(what))
		who.AddShout(what)

		If(unlock)
			If(what.GetNthWordOfPower(0) != None)
				Game.UnlockWord(what.GetNthWordOfPower(0))
			EndIf

			If(what.GetNthWordOfPower(1) != None)
				Game.UnlockWord(what.GetNthWordOfPower(1))
			EndIf

			If(what.GetNthWordOfPower(2) != None)
				Game.UnlockWord(what.GetNthWordOfPower(2))
			EndIf
		EndIf

		Return True
	EndIf

	Return False
EndFunction

Bool Function GiveSpell(Actor who, Spell what)
{give a spell if we do not already have it. returns if we had to give the spell
or not.}

	If(!who.HasSpell(what))
		who.AddSpell(what)
		Return True
	EndIf

	Return False
EndFunction

Bool Function GivePerk(Actor who, Perk what)
{give a perk if we do not already have it. returns if we hd to give the perk or
not.}

	If(!who.HasPerk(what))
		who.AddPerk(what)
		Return True
	EndIf

	Return False
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Bool Function IsActorInUse(Actor what)
{check if this mod is still using a specific actor base or not. we will scan the
pack lists as well as the pregnancy slot. if it does not exist in any of those
locations then it is candidiate for having its persist hack removed so that the
game may be allowed to clear it.}

	If(self.IsActorInUse_PackList(what,self.Player))
	 	Return True
	EndIf

	Return False
EndFunction

Bool Function IsActorInUse_PackList(Actor what, Actor who=None)
{perform a check on a specific actor's pack list. since only the player has
packlist  right now this function has been designed with the future in mind.}

	self.WhilePackListLocked("IsActorInUse")
	self.PlacePackListLock("IsActorInUse")

	Int len = StorageUtil.FormListCount(None,"Untamed.TrackingList")
	Int a
	Actor cur

	a = 0
	While(a < len)
		cur = StorageUtil.FormListGet(None,"Untamed.TrackingList",a) as Actor
		If(cur == what)
			self.RemovePackListLock("IsActorInUse")
			Return True
		EndIf

		a += 1
	EndWhile

	self.RemovePackListLock("IsActorInUse")
	Return False
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function PersistHackApply(Actor who)
{register an actor for persistence.}

	;; persist haxxxxxxxxx
	;; this is literally, one of the worst hacks ever devised. the problem here
	;; is that leveled actors will have their actor bases garbage collected
	;; out from under them. the result of this happening is 1) the actor (lets
	;; say it is a bear) will be replaced by a completely random NPC that now
	;; occupies that temporary ID, or 2) the game will crash.

	self.PrintDebug("PersistHackApply(" + who.GetDisplayName() + ")")
	who.UnregisterForUpdate()
	who.RegisterForUpdate(600)

	;; 9 times out of 10 if i saw that code in a mod i would say "god that guy
	;; is so fucking stupid he is ruining the save game." but because i am
	;; awesome and i am taking extra care required to clean this shit up after
	;; an actor dies or whatever, you can trust me. don't try this at home. i am
	;; what you call "an expert."
	;; [[ the actorbase hack is a test to see if that will prevent the gc on
	;; the actor base. it works on the actor itself alright, but the ab is an
	;; experiment. ]]

	Return
EndFunction


Function PersistHackClear(Actor who)
{unregister everything about the actor.}

	If(!self.IsActorInUse(who))
		self.PrintDebug("PersistHackClear(" + who.GetDisplayName() + ")")
		who.UnregisterForUpdate()
	EndIf

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function AddToPack(Actor animalsource, Actor who)
{add an animal to sombodies pack.}

	;; skip dead ones.
	If(animalsource.IsDead())
		Return
	EndIf

	;; only works on player atm
	If(who != self.Player)
		Return
	EndIf

	;; allow mods to specify for this animal to be ignored for other scripting
	;; or story quest reasons.
	If(animalsource.HasKeywordString("UntamedNoPack"))
		Return
	EndIf

	;;;;;;;;
	;;;;;;;;

	If(!StorageUtil.FormListHas(None,"Untamed.TrackingList",animalsource))
		;;Actor animal = self.Clone(animalsource)
		Actor animal = animalsource
		Utility.Wait(0.2)

		self.Print(self.GetActorName(animal) + " has joins the pack.")
		StorageUtil.FormListAdd(None,"Untamed.TrackingList",animal)

		;; prepare the npc for behaviour training.
		self.StopCombat(animal)
		self.BehaviourClear(animal,True)
		self.PersistHackApply(animal)

		;; have the creature stop being a dick to everyone.
		If(self.OptMakePackDocile)
			self.StopCombat(animal)
			animal.RemoveFromFaction(self.FactionPredator)
			animal.SetAV("Aggression",1)
			self.StopCombat(animal)
		EndIf

		;; have the creature stop being a dick to the player.
		self.StopCombat(animal)
		animal.AddToFaction(self.dcc_ut_FactionFollower)
		animal.SetFactionRank(self.dcc_ut_FactionFollower,1)
		animal.SetRelationshipRank(self.Player,3)
		animal.SetPlayerTeammate(true,true)

		;; allow the creature to talk.
		If(!self.OptCmdMenu)
			animal.AllowPCDialogue(true)
		EndIf

		;; add the update script to it.
		self.StopCombat(animal)
		animal.RemoveSpell(self.dcc_ut_SpellFollower)
		animal.AddSpell(self.dcc_ut_SpellFollower)

		;; follow the player. sets up a default package that tells the npc to
		;; follow them by default. we will override this with other packages set
		;; to 100 that way when they are cleared it falls back to follow.
		self.StopCombat(animal)
		self.BehaviourDefault(animal)
		animal.SetScale(self.OptPackScale)

		self.AddToPack_StorageUtil(animal,who)

		If(self.OptMateCallEngage)
			self.FollowerEngage(animal,who)
		EndIf
	EndIf

	;;;;;;;;
	;;;;;;;;

	Return
EndFunction

Function AddToPack_StorageUtil(Actor animal, Actor who)
{create and default storageutil data for animal actor.}

	StorageUtil.SetFloatValue(animal,"Untamed.Level",1.0)
	StorageUtil.SetFloatValue(animal,"Untamed.Pack.Joined",Utility.GetCurrentGameTime())
	Return
EndFunction

Function RemoveFromPack(Actor animal, Actor who)
{remove the specified actor from the list tracking all the people who have
contracted the main untamed buff.}

	;; only works on the player atm.
	If(who != self.Player)
		Return
	EndIf

	;;;;;;;;
	;;;;;;;;


	StorageUtil.FormListRemove(None,"Untamed.TrackingList",animal,True)

	self.Print(self.GetActorName(animal) + " has left the pack.")
	self.BehaviourClear(animal,True)
	self.PersistHackClear(animal)
	animal.AllowPCDialogue(false)

	animal.RemoveSpell(self.dcc_ut_SpellFollower)
	animal.RemoveFromFaction(self.dcc_ut_FactionFollower)
	animal.SetPlayerTeammate(False,False)
	self.RemoveFromPack_StorageUtil(animal,who)

	Return
EndFunction

Function RemoveFromPack_StorageUtil(Actor animal, Actor who)
{remove storageutil data for animal actor.}

	StorageUtil.UnsetFloatValue(animal,"Untamed.Level")
	StorageUtil.UnsetFloatValue(animal,"Untamed.Pack.Joined")
	Return
EndFunction

Function CleanPackList(Bool lock=True)
{remove any dead or lost actors from the pack list. this should almost always
be within a packlist lock.}

	If(lock)
		self.WhilePackListLocked("CPL")
		self.PlacePackListLock("CPL")
	EndIf

	Int a = 0
	Int len = self.GetPackSize()
	Actor who

	a = 0
	While(a < len)
		who = StorageUtil.FormListGet(None,"Untamed.TrackingList",a) as Actor

		If(who == None)
			self.Print("An animal has been lost from the pack.")
			StorageUtil.FormListRemoveAt(None,"Untamed.TrackingList",a)
		ElseIf(who.IsDead())
			StorageUtil.FormListRemoveAt(None,"Untamed.TrackingList",a)
		EndIf

		a += 1
	EndWhile

	If(lock)
		self.RemovePackListLock("CPL")
	EndIf

	Return
EndFunction

Int Function GetPackSize()
{get how large the pack currently is.}

	Return StorageUtil.FormListCount(None,"Untamed.TrackingList")
EndFunction

Actor Function GetPackMember(Int offset)
{get someone from the pack list.}

	Return StorageUtil.FormListGet(None,"Untamed.TrackingList",offset) as Actor
EndFunction

Function ResizePack()
{perform a scale on all the pack members, typically after changing the setting
in mcm.}

	Int offset = 0
	Int len = self.GetPackSize()
	Actor animal

	While(offset < len)
		animal = self.GetPackMember(offset)

		If(animal != None)
			animal.SetScale(self.OptPackScale)
		EndIf

		offset += 1
	EndWhile


	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function FollowerCmdMenu(Actor who)
{show the radial wheel menu when talking to an animal}

	;; 0 info
	;; 1 inventory
	;; 2 give name
	;; 3 dismiss
	;; 4 stay/follow
	;; 5 fondle
	;; 6 looter
	;; 7 taunt/cower/status

	self.UnregisterForControl("Activate")
	UIExtensions.InitMenu("UIWheelMenu")

	;;;;;;;;
	;;;;;;;;

	;; stats opeion.
	UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu","optionEnabled",0,True)
	UIExtensions.SetMenuPropertyIndexString("UIWheelMenu","optionText",0,"See info about this beast.")
	UIExtensions.SetMenuPropertyIndexString("UIWheelMenu","optionLabelText",0,"Beast Info...")

	;; inventory option.
	If(self.Player.HasPerk(self.dcc_ut_PerkBeastCarry) || (who.GetRace() == self.RaceMammoth && who.GetDisplayName() == "Packmoth"))
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu","optionEnabled",1,True)
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu","optionText",1,"Trade items with the beast.")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu","optionLabelText",1,"Inventory...")
	EndIf

	;; rename option.
	If(self.Player.HasSpell(self.dcc_ut_ShoutRename))
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu","optionEnabled",2,True)
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu","optionText",2,"Give the beast a name.")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu","optionLabelText",2,"Give Name...")
	EndIf

	;; add dismiss option.
	UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu","optionEnabled",3,True)
	UIExtensions.SetMenuPropertyIndexString("UIWheelMenu","optionText",3,"Dismiss beast from pack.")
	UIExtensions.SetMenuPropertyIndexString("UIWheelMenu","optionLabelText",3,"Dismiss")

	;; add follow/stay switch option.
	If(who.GetCurrentPackage() == self.dcc_ut_PackageDoNothing)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu","optionEnabled",4,True)
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu","optionText",4,"Have the beast follow.")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu","optionLabelText",4,"Follow")
	Else
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu","optionEnabled",4,True)
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu","optionText",4,"Have the beast hold position.")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu","optionLabelText",4,"Stay")
	EndIf

	;; engage option.
	UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu","optionEnabled",5,True)
	UIExtensions.SetMenuPropertyIndexString("UIWheelMenu","optionText",5,"Engage Sexy Time.")
	UIExtensions.SetMenuPropertyIndexString("UIWheelMenu","optionLabelText",5,"Fondle")

	;; looter option.
	If(self.Player.HasPerk(self.dcc_ut_PerkLooter))
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu","optionEnabled",6,True)
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu","optionText",6,"Loot the dead corpses.")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu","optionLabelText",6,"Fetch")
	EndIf

	;; taunt/cower option.
	Int taunt = 0
	If(who.GetCombatTarget() != None)
		If(who.GetCombatTarget().GetCombatTarget() != who)
			If(self.Player.HasSpell(self.dcc_ut_ShoutTaunt))
				taunt = 1
				UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu","optionEnabled",7,True)
				UIExtensions.SetMenuPropertyIndexString("UIWheelMenu","optionText",7,"Taunt his current target.")
				UIExtensions.SetMenuPropertyIndexString("UIWheelMenu","optionLabelText",7,"Taunt")
			EndIf
		Else
			If(self.Player.HasSpell(self.dcc_ut_ShoutCower))
				taunt = 2
				UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu","optionEnabled",7,True)
				UIExtensions.SetMenuPropertyIndexString("UIWheelMenu","optionText",7,"Cower away from target.")
				UIExtensions.SetMenuPropertyIndexString("UIWheelMenu","optionLabelText",7,"Cower")
			EndIf
		EndIf
	Else
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu","optionEnabled",7,False)
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu","optionText",7,"")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu","optionLabelText",7, ("[" + self.FollowerWhatDo(who) + "]") )
	EndIf

	;;;;;;;;
	;;;;;;;;

	Int result = UIExtensions.OpenMenu("UIWheelMenu",who)
	;;Int result = UIExtensions.GetMenuPropertyInt("UIWheelMenu","returnValue")

	;;;;;;;;
	;;;;;;;;

	bool CauseLvl = False

	If(result == 0)
		self.FollowerInfo(who)
	ElseIf(result == 1)
		who.OpenInventory()
	ElseIf(result == 2)
		self.FollowerRename(who)
	ElseIf(result == 3)
		self.RemoveFromPack(who,self.Player)
		self.Print(who.GetDisplayName() + " leaves the pack.")
	ElseIf(result == 4)
		If(who.GetCurrentPackage() == self.dcc_ut_PackageDoNothing)
			self.FollowerDefault(who)
			self.Print(who.GetDisplayName() + " shall follow you.")
			CauseLvl = True
		Else
			self.FollowerStay(who)
			self.Print(who.GetDisplayName() + " will hold their ground.")
			CauseLvl = True
		EndIf
	ElseIf(result == 5)
		self.FollowerEngage(who,self.Player,true)
		CauseLvl = True
	ElseIf(result == 6)
		self.FollowerLoot(who,True)
		self.Print(who.GetDisplayName() + " sniffs around for things.")
		CauseLvl = True
	ElseIf(result == 7)
		If(taunt == 1)
			self.dcc_ut_SpellTaunt.Cast(who,who.GetCombatTarget())
			CauseLvl = True
		ElseIf(taunt == 2)
			self.dcc_ut_SpellCower.Cast(who,who.GetCombatTarget())
			CauseLvl = True
		EndIf
	EndIf

	If(CauseLvl)
		;; go ahead and have commands from the command wheel prompt leveling
		;; as well at a reduced rate (because it soooooooo easy.)
		self.ProgressLevel(self.Player,True, (self.OptScaleShoutLevel/1.5) ,True)
		self.UpdateBuffValues(self.Player)
	EndIf

	;;;;;;;;
	;;;;;;;;

	self.RegisterForControl("Activate")
	Return
EndFunction

Function FollowerPurgeMenu(Actor who)
{perge a broken lost member from the pack.}

	UIExtensions.InitMenu("UIWheelMenu")

	Int result = UIExtensions.OpenMenu("UIWheelMenu",who)

	Return
EndFunction

Function FollowerInfo(Actor who)
{show a dialog about this actor.}

	;;who.ModActorValue("Health",self.OptBeastScaleHealth)
	;;who.ModActorValue("Stamina",self.OptBeastScaleStamina)
	;;who.ModActorValue("AttackDamageMult",self.OptBeastScaleAttackDamage)
	;;who.ModActorValue("DamageResist",self.OptBeastScaleDamageResist)
	;;who.ModActorValue("MagicResist",self.OptBeastScaleMagicResist)

	String msg

	msg = "Beast: " + who.GetDisplayName() + "\n"

	msg += "Pack member for " + ((Utility.GetCurrentGameTime() - self.GetWhenJoined(who)) as Int) + " day(s).\n"

	msg += "[Race: " + who.GetRace().GetName() + "] "
	msg += "[Untamed Level: " + (self.GetLevel(who) as Int) + "]\n"


	msg += "[Health: " + (who.GetActorValue("Health") as Int) + "] "
	msg += "[Stamina: " + (who.GetActorValue("Stamina") as Int) + "]\n"

	msg += "[Armor: " + (who.GetActorValue("DamageResist") as Int) + "] "
	msg += "[Magic Resist: " + ((who.GetActorValue("MagicResist") * 100) as Int) + "%]\n"

	msg += "[Attack Damage Multiplier: " + who.GetActorValue("AttackDamageMult")  + "x]\n"

	self.UnregisterCmdMenu()
	Debug.MessageBox(msg)
	self.RegisterCmdMenu()

	Return
EndFunction

Function FollowerDefault(Actor who)
{restore the follower's default behaviour.}

	who.SetAV("Aggression",1)
	self.BehaviourClear(who)
	Return
EndFunction

Function FollowerStay(Actor who)
{have an actor wait and do nothing.}

	self.BehaviourApply(who,self.dcc_ut_PackageDoNothing)
	Return
EndFunction

Function FollowerEngage(Actor who, Actor with, bool menu=false)
{have an adult conversation with the follower.}

	;; testing a delay to see if it fixes the unresponsive dialog problem.
	If(!menu)
		Utility.Wait(3.0)
	EndIF

	Actor[] ppl = new Actor[2]
	ppl[0] = with
	ppl[1] = who

	who.StopCombat()
	with.StopCombat()

	If(who.IsWeaponDrawn())
		who.SheatheWeapon()
		with.SheatheWeapon()
		Utility.Wait(2.0)
	EndIf

	sslBaseAnimation[] ani
	SexLab.StartSex(ppl,ani,allowBed=False)

	If((who==self.PLayer || with==self.Player) && self.OptJerkoffMode)
		self.UnregisterCmdMenu()
		Debug.MessageBox("Infinite Mode is enabled. The encounter will automatically restart when it ends until you cancel by pressing Jump.")
		self.RegisterCmdMenu()

		Utility.Wait(0.5)

		StorageUtil.SetIntValue(self.Player,"Untamed.JerkoffMode",1)
		;;self.RegisterForModEvent("AnimationEnd","OnEncounterFinished")
		self.RegisterForControl("Jump")
	EndIF

	Return
EndFunction

Function FollowerRename(Actor who)
{rename this animal.}

	String textinput

	UIExtensions.InitMenu("UITextEntryMenu")
	UIExtensions.SetMenuPropertyString("UITextEntryMenu","text",who.GetDisplayName())
	UIExtensions.OpenMenu("UITextEntryMenu")
	textinput = UIExtensions.GetMenuResultString("UITextEntryMenu")

	If(textinput != "")
		who.SetDisplayName(textinput)
		self.Print(who.GetDisplayName()  + " the " + who.GetRace().GetName())
	EndIf

	Return
EndFunction

Function FollowerAggroNone(Actor who)
	who.SetAV("Aggression",0)
	who.SetAV("Confidence",1)
	Return
EndFunction

Function FollowerAggroNormal(Actor who)
	who.SetAV("Aggression",1)
	who.SetAV("Confidence",3)
	Return
EndFunction

Function FollowerLoot(Actor who, Bool first=False)

	ReferenceAlias body = self.dcc_ut_QuestLooter.GetAliasByName("TheDead") as ReferenceAlias
	ReferenceAlias looter = self.dcc_ut_QuestLooter.GetAliasByName("TheLooter") as ReferenceAlias

	self.dcc_ut_QuestLooter.Stop()
	self.dcc_ut_QuestLooter.Start()
	Utility.Wait(0.25)

	If(body.GetRef() == None)
		;; if the radaint magic stuff stopped finding dead people then send the
		;; animal back to the player. the looting script on the package will
		;; then handle opening the inventory and ending this chain of lulz.
		self.Print(who.GetDisplayName() + " is done looting.")
		body.ForceRefTo(self.Player)
	EndIf

	looter.ForceRefTo(who)
	If(looter.TryToEvaluatePackage())
		self.BehaviourClear(who,True)
	EndIf

	If(looter.GetActorRef() != self.Player)
		self.Print(who.GetDisplayName() + " going to loot " + body.GetActorRef().GetDisplayName())
	Else
		self.Print(who.GetDisplayName() + " is returning after ninja'ing all the shit.")
	EndIf

	;; at this point the package should cause the animal to run over to a dead
	;; body. that marks the package complete, which will then trigger ninja'ing
	;; all the shit, and then rerunning this function.

	Return
EndFunction

String Function FollowerWhatDo(Actor who)
	Package doing = who.GetCurrentPackage()
	String whatdo

	If(doing == self.dcc_ut_PackageLooter)
		whatdo = "Looting"
	ElseIf(doing == self.dcc_ut_PackageDoNothing)
		whatdo = "Staying"
	Else
		whatdo = "Following"
	EndIf

	Return whatdo
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function LootTake(Actor who, Actor from)
{remove all the items from someone.}

	Form thing
	Int thingcount

	self.Print(from.GetDisplayName() + " has " + from.GetNumItems() + " thing(s).")

	thing = from.GetNthForm(0)
	While(thing)
		thingcount = from.GetItemCount(thing)

		who.AddItem(thing,thingcount)
		from.RemoveItem(thing,thingcount)

		thing = from.GetNthForm(0)
	EndWhile

	from.RemoveAllItems()
	from.AddItem(self.dcc_ut_ItemLooterCard,1)

	Return
EndFunction

Function LootListAdd(Actor who, Actor what)
{add a body to the list.}

	StorageUtil.FormListAdd(who,"Untamed.Loot.Actors",what)
	Return
EndFunction

Int Function LootListGetCount(Actor who)
{get how many bodies were found.}

	Return StorageUtil.FormListCount(who,"Untamed.Loot.Actors")
EndFunction

Function LootListClear(Actor who)
{drop all from the looting list.}

	StorageUtil.FormListClear(who,"Untamed.Loot.Actors")
	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function BehaviourApply(Actor who, Package pkg)
{have an actor begin a specific package.}

	self.BehaviourClear(who)

	StorageUtil.SetFormValue(who,"Untamed.AI.Package",pkg)
	ActorUtil.AddPackageOverride(who,pkg,100)
	who.EvaluatePackage()

	Return
EndFunction

Function BehaviourClear(Actor who, Bool full=False)
{have an actor clear their ruling overwrite package.}

	Package pkg = StorageUtil.GetFormValue(who,"Untamed.AI.Package",missing=None) as Package

	If(pkg != None)
		StorageUtil.UnsetFormValue(who,"Untamed.AI.Package")
		ActorUtil.RemovePackageOverride(who,pkg)
		who.EvaluatePackage()
	EndIf

	If(full)
		ActorUtil.RemovePackageOverride(who,self.dcc_ut_PackageDoNothing)
		ActorUtil.RemovePackageOverride(who,self.dcc_ut_PackageFollowPlayer)
		who.EvaluatePackage()
	EndIf

	Return
EndFunction

Function BehaviourDefault(Actor who)
	self.BehaviourClear(who,True)

	ActorUtil.AddPackageOverride(who,self.dcc_ut_PackageFollowPlayer,99)
	who.EvaluatePackage()

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Bool Function HasUpdateBuffLock(String name="Untamed.UpdateBuffLock")
{check if there is a global lock against updating the untamed spell}

	If(StorageUtil.GetIntValue(None,name) > 0)
		Return True
	Else
		Return False
	EndIf
EndFunction

Function PlaceUpdateBuffLock(String name="Untamed.UpdateBuffLock")
{create a lock for updating the untamed buff spell update}

	StorageUtil.SetIntvalue(None,name,1)
	Return
EndFunction

Function RemoveUpdateBuffLock(String name="Untamed.UpdateBuffLock")
{clear the lock on the untamed buff spell update}

	StorageUtil.UnsetIntValue(None,name)
	Return
EndFunction

Bool Function HasPackListLock()
	If(self.PackListLock > 0)
		Return True
	Else
		Return False
	EndIf
EndFunction

Function PlacePackListLock(String msg="PL")
	self.PackListLock = 1
	self.PrintDebug("LOCK GET " + msg)
	Return
EndFunction

Function RemovePackListLock(String msg="PL")
	self.PrintDebug("LOCK RELEASE " + msg)
	self.PackListLock = 0
	Return
EndFunction

Function WhilePackListLocked(String msg="PL")
	While(self.PackListLock > 0)
		self.PrintDebug("LOCK SPUN " + msg)
		Utility.Wait(0.25)
	EndWhile

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Int function GetCountBears(Actor who)
{fetch how many bears we have been with}

	Return StorageUtil.GetIntValue(who,"Untamed.Count.Bears")
EndFunction

Int function GetCountCats(Actor who)
{fetch how many cats we have been with}

	Return StorageUtil.GetIntValue(who,"Untamed.Count.Cats")
EndFunction

Int Function GetCountBeasts(Actor who)
{fetch how many beasts we have been with}

	Return StorageUtil.GetIntValue(who,"Untamed.Count.Beasts")
EndFunction

Int Function GetCountBirths(Actor who)
{fetch how many beasts we have birthed.}

	Return StorageUtil.GetIntValue(who,"Untamed.Count.Births")
EndFunction

Float Function GetLevel(Actor who)
{fetch the actor's untamed level}

	Return StorageUtil.GetFloatValue(who,"Untamed.Level",missing=0.0)
EndFunction

Float Function GetWhenJoined(Actor who)
{fetch the time the actor joined the pack.}

	Return StorageUtil.GetFloatValue(who,"Untamed.Pack.Joined",missing=Utility.GetCurrentGameTime())
EndFunction

Function ProgressLevel(Actor who, Bool beastial, Float count=1.0, Bool shouted=False)
{progress the actor's untamed level.}

	;; do nothing if there were none.
	If(count == 0)
		Return
	EndIf

	;; determine what direction to progress the level.
	If(beastial)
		If(!shouted)
			StorageUtil.AdjustFloatValue(who,"Untamed.Level",self.OptScaleLevel)
		Else
			StorageUtil.AdjustFloatValue(who,"Untamed.Level",count)
		EndIf
	Else
		StorageUtil.AdjustFloatValue(who,"Untamed.Level",(self.OptScaleLevel * -1))
	EndIf

	;; if the level is out of bounds, correct it.
	Float level = self.GetLevel(who)
	Bool done = False
	If(level < 0.0)
		StorageUtil.SetFloatValue(who,"Untamed.Level",0.0)
	ElseIf(level > self.OptMaxLevel)
		done = True
		StorageUtil.SetFloatValue(who,"Untamed.Level",self.OptMaxLevel)
	EndIf

	;;;;;;;;
	;;;;;;;;

	If(!done)
		If(!shouted)
			self.ProgressLevel_Immerse(who,level)
		EndIf

		self.ProgressLevel_Powers(who,level)
	EndIf

	;;;;;;;;
	;;;;;;;;

	self.PrintDebug(who.GetDisplayName() + " Untamed Level: " + level)

	Return
EndFunction

Function ProgressLevel_Immerse(Actor who, Float level)
{level up immersion.}

	If(who != self.Player)
		Return
	EndIf

	If(level == 1.0)
		self.Print("You can feel the bestial power stirring within.")
		self.dcc_ut_MsgPowerAwaken.Show()
	EndIf

	If(self.OptPostSexEffect)
		self.SceneStart_PowerAwaken(who)
	EndIf

	Return
EndFunction

Function ProgressLevel_Powers(Actor who, Float level)
{progress powers for actors.}

	If(who == self.Player)
		self.ProgressLevel_Powers_Player(who,level)
	ElseIf(SexLab.GetGender(who) == 2)
		self.ProgressLevel_Powers_Beast(who,level)
	EndIf

	Return
EndFunction

Function ProgressLevel_Powers_Player(Actor who, Float lvl)
{progress the spells by level.}

	If(who != self.Player)
		Return
	EndIf

	If(lvl >= self.OptLvlShoutStay)
		If(self.GiveShout(who,self.dcc_ut_ShoutStay))
			self.dcc_ut_MsgShoutStay.Show()
		EndIf
	EndIf

	If(lvl >= self.OptLvlShoutFollow)
		If(self.GiveShout(who,self.dcc_ut_ShoutFollow))
			self.dcc_ut_MsgShoutFollow.Show()
		EndIf
	EndIf

	If(lvl >= self.OptLvlShoutSprint)
		If(self.GiveShout(who,self.dcc_ut_ShoutSprint))
			self.dcc_ut_MsgShoutSprint.Show()
		EndIf
	EndIf

	If(lvl >= self.OptLvlShoutLastStand)
		If(self.GiveShout(who,self.dcc_ut_ShoutLastStand))
			self.dcc_ut_MsgShoutLastStand.Show()
		EndIf
	EndIf

	If(lvl >= Self.OptLvlShoutRename)
		If(self.GiveShout(who,self.dcc_ut_ShoutRename))
			self.dcc_ut_MsgShoutRename.Show()
		EndIf
	EndIf

	If(lvl >= self.OptLvlPerkLooter)
		self.GiveSpell(who,self.dcc_ut_SpellLooter)
		If(self.GivePerk(who,self.dcc_ut_PerkLooter))
			self.dcc_ut_MsgPerkLooter.Show()
		EndIf
	EndIf

	If(lvl >= self.OptLvlShoutTaunt)
		If(self.GiveShout(who,self.dcc_ut_ShoutTaunt))
			self.dcc_ut_MsgShoutTaunt.Show()
		EndIf
	EndIf

	If(lvl >= self.OptLvlShoutCower)
		If(self.GiveShout(who,self.dcc_ut_ShoutCower))
			self.dcc_ut_MsgShoutCower.Show()
		EndIf
	EndIf

	If(lvl >= self.OptLvlPerkExtendSprint)
		If(self.GivePerk(who,self.dcc_ut_PerkExtendSprint))
			self.dcc_ut_MsgPerkExtendSprint.Show()
		EndIf
	EndIf

	If(lvl >= self.OptLvlSpellIFF)
		If(self.GiveSpell(who,self.dcc_ut_SpellIFF))
			self.dcc_ut_MsgSpellIFF.Show()
		EndIf
	EndIf

	If(lvl >= self.OptLvlPerkBeastCarry)
		If(self.GivePerk(who,self.dcc_ut_PerkBeastCarry))
			self.dcc_ut_MsgPerkBeastCarry.Show()
		EndIf
	EndIf

	Return
EndFunction

Function ProgressLevel_Powers_Beast(Actor who, Float lvl)
{progress powers by level.}


	;; the higher level you are the faster i want you to bring beasts up to
	;; your level. so here is a stupid curve that will do that.

	Float bump = (self.GetLevel(self.Player) - lvl) * 0.25

	If(bump < 1.0 || !self.OptBeastLevelCatchup)
		bump = 1.0
	EndIf

	who.ModActorValue("Health",(self.OptBeastScaleHealth * bump))
	who.ModActorValue("Stamina",(self.OptBeastScaleStamina * bump))
	who.ModActorValue("AttackDamageMult",(self.OptBeastScaleAttackDamage * bump))
	who.ModActorValue("DamageResist",(self.OptBeastScaleDamageResist * bump))
	who.ModActorValue("MagicResist",(self.OptBeastScaleMagicResist * bump))

	If(bump > 1.0)
		StorageUtil.AdjustFloatValue(who,"Untamed.Level",(bump - 1))
	EndIf

	;; i found a note in the AFT code that said since skyrim auto levels
	;; npc, all you have to do is call setrace to trigger it. i don't think it
	;; will work as i want (keeping the pets within a respectable level of you)
	;; but why the fuck not, lets try it.
	who.SetRace(who.GetRace())

	Return
EndFunction

Function ProgressCountBears(Actor who, Int count=1)
{progress the bear counter.}

	If(who != self.Player)
		;; only work on player for now.
		Return
	EndIf

	StorageUtil.AdjustIntValue(who,"Untamed.Count.Bears",count)

	If(self.GetCountBears(who) >= self.OptCountUnlockShift)
		If(self.GiveSpell(who,self.dcc_ut_SpellShiftBear))
			self.dcc_ut_MsgShiftBear.Show()
		EndIf
	EndIf

	Return
EndFunction

Function ProgressCountCats(Actor who, Int count=1)
{progress the cat counter.}

	If(who != self.Player)
		;; only work on player for now.
		Return
	EndIf

	StorageUtil.AdjustIntValue(who,"Untamed.Count.Cats",count)

	If(self.GetCountCats(who) >= self.OptCountUnlockShift)
		If(self.GiveSpell(who,self.dcc_ut_SpellShiftCat))
			self.dcc_ut_MsgShiftCat.Show()
		EndIf
	EndIf

	Return
EndFunction


Function ProgressCountBeasts(Actor who, Int count=1)
{progress the beast counter}

	StorageUtil.AdjustIntValue(who,"Untamed.Count.Beasts",count)
	Return
EndFunction

Function ProgressCountBirths(Actor who, Int count=1)
{progress the birthed counter.}

	StorageUtil.AdjustIntValue(who,"Untamed.Count.Births",count)
	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function UpdateBuffValues(Actor who)
{update the buff values on the untamed spell. this update must work with the
global lock so that multiple actors do not try and mess with the spell data at
the same time so that their values may be trusted their values}

	Int enum = 0
	Int ecount = dcc_ut_SpellUntamed.GetNumEffects()
	Float emag = 0.0
	MagicEffect effect

	;; only process actors who have the spell.
	If(!who.HasSpell(dcc_ut_SpellUntamed))
		Return
	EndIf

	;; only process one actor at a time so that the spell can be updated and
	;; reapplied based on the actor's current levels.
	While(self.HasUpdateBuffLock())
		Utility.Wait(self.OptUpdateBuffLockDelay)
	EndWhile
	self.PlaceUpdateBuffLock()

	;; loop through all the magic effects on the untamed spell and determine
	;; new magnitudes for the effects.
	While(enum < ecount)
		effect = dcc_ut_SpellUntamed.GetNthEffectMagicEffect(enum)

		If(effect == self.dcc_ut_BuffResistPhysical)
			emag = self.UpdateBuffValues_ResistPhysical(who)
			dcc_ut_SpellUntamed.SetNthEffectMagnitude(enum,emag)
			self.PrintDebug("Armor Value: " + emag)
		ElseIf(effect == self.dcc_ut_BuffResistMagic)
			emag = self.UpdateBuffValues_ResistMagic(who)
			self.PrintDebug("Magic Resist Value:" + emag)
			dcc_ut_SpellUntamed.SetNthEffectMagnitude(enum,emag)
		EndIf

		enum += 1
	EndWhile

	;; now that we have updated this spell's values, we need to apply it to the
	;; actor with the updated values.
	who.RemoveSpell(self.dcc_ut_SpellUntamed)
	Utility.Wait(0.1)

	who.AddSpell(self.dcc_ut_SpellUntamed,False)
	self.RemoveUpdateBuffLock()

	Return
EndFunction

Float Function UpdateBuffValues_ResistPhysical(Actor who)
{calculate the new armor value based on untamed level}

	Return (self.GetLevel(who) * self.OptScaleResistPhysical) + self.OptBaseResistPhysical
EndFunction

Float Function UpdateBuffValues_ResistMagic(Actor who)
{calculate the new magic resist value based on untamed level}

	Return (self.GetLevel(who) * self.OptScaleResistMagic) + self.OptBaseResistMagic
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function SceneStart_PowerAwaken(Actor who)
{over the course of 7 seconds this transition will represent the moment the
untamed powers awaken in a player. it does a bit of blur, desat, colourise,
blooming, and then fades back to normal.}

	self.dcc_ut_ImodPowerAwaken.Apply()
	self.dcc_ut_SoundPowerAwaken.Play(who)
	;;Utility.Wait(7)
	;;self.dcc_ut_ImodPowerAwaken.Remove()

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; preg utility functions

Bool Function IsPreg(Actor who)
{determine if there is a pregnancy going on.}

	If(StorageUtil.GetFormValue(who,"Untamed.Preg.Actor") != None)
		Return True
	Else
		Return False
	EndIf
EndFunction

Function ClearPregWith(Actor who)
{clear the preg for the specified actor.}

	StorageUtil.UnsetFormValue(who,"Untamed.Preg.Actor")
	Return
EndFunction

ActorBase Function GetPregWith(Actor who)
{get the actor specified actor is preg with.}

	Return StorageUtil.GetFormValue(who,"Untamed.Preg.Actor") as ActorBase
EndFunction

Function SetPregWith(Actor who, Actor animal)
{set this actor preg with specified actor base.}

	ActorBase old = self.GetPregWith(who)
	self.PrintDebug("SetPregWith(" + who.GetDisplayName() + ", " + animal.GetDisplayName() + ")")

	;; clear and free the old one first.
	If(old != None)
		self.ClearPregWith(who)
	EndIf

	;; inspired by Skyrimfloo
	;; http://www.loverslab.com/topic/42343-untamed/?p=1069356
	ActorBase flatbass = animal.GetActorBase()
	ActorBase lvlbass = animal.GetLeveledActorBase()
	If(flatbass != lvlbass)
		self.PrintDebug("[SetPregWith] Template Dig Used")
		flatbass = lvlbass.GetTemplate()
	EndIf

	self.PrintDebug("[SetPregWith] storing " + flatbass.GetName())
	StorageUtil.SetFormValue(who,"Untamed.Preg.Actor",flatbass)
	Return
EndFunction

Function ClearPregTime(Actor who)
{clear this actors preg time.}

	StorageUtil.UnsetFloatValue(who,"Untamed.Preg.Time")
	Return
EndFunction

Float Function GetPregTime(Actor who)
{get the preg time. returns -1 if not preg.}

	Return StorageUtil.GetFloatValue(who,"Untamed.Preg.Time",missing=-1.0)
EndFunction

Function SetPregTime(Actor who, Float when=-1.0)
{set or reset the preg time}

	If(when == -1.0)
		when = Utility.GetCurrentGameTime()
	EndIf

	StorageUtil.SetFloatValue(who,"Untamed.Preg.Time",when)
	Return
EndFunction

Float Function GetPregTimeDelta(Actor who)
{fetch how long it has been since the last time the preg timer has been updated
with a value in game days. if the actor is not preg it will return 0, but dont
use this as a check for if pregnant.}

	Float time = Utility.GetCurrentGameTime()
	Return time - StorageUtil.GetFloatValue(who,"Untamed.Preg.Time",missing=time)
EndFunction

Function GiveBirth(Actor who)
{spawn a new whatever was incubating.}

	If(!self.IsPreg(who))
		self.Print(self.GetActorName(who) + " is not with cub.")
		Return
	EndIf

	If(self.OptPregTime > 0 && self.GetPregTimeDelta(who) < self.OptPregTime)
		self.Print(self.GetActorName(who) + " is not ready to give birth. It has been " + self.GetPregTimeDelta(who) +  " of " + self.OptPregTime + " day(s).")
		Return
	ElseIf(self.OptPregTime == 0.0 && self.GetPregTimeDelta(who) / self.GlobalTimescale.GetValue() < 0.0069)
		;; ten minute cooldown on the lesser power.
		self.Print(self.GetActorName(who) + " is not ready to give birth. It has been " + ((self.GetPregTimeDelta(who) * 1440) / self.GlobalTimescale.GetValue()) +  " of 10 minutes.")
		Return
	EndIf

	ObjectReference cub
	ActorBase animal = self.GetPregWith(who) as ActorBase
	self.PrintDebug("[GiveBirth] ab(" + animal.GetName() + ")")

	;; todo - cinematic this shit.
	;; fade out
	;; kick the missionary position in
	;; fade in
	;; i dunno. rotatey camera or someshit.
	;; fade out
	;; stand up, spawn cub
	;; fade in

	cub = who.PlaceAtMe(animal,1,False,True)

	self.AddToPack(cub as Actor,who)
	cub.MoveTo(who)
	cub.Enable()

	self.ProgressCountBirths(who)

	If(self.OptPregTime != 0.0)
		;; real mode.
		self.ClearPregWith(who)
		self.ClearPregTime(who)
	Else
		;; arcade mode.
		self.SetPregTime(who)
	EndIf

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; shapeshifting.

Function Requip(Actor who)
{re-equip an item slot we previously emptied.}

	Int cur = 0
	Form item

	While(cur < 3)
		item = StorageUtil.FormListGet(who,"Untamed.Shapeshift.Items",cur)

		If(item as Armor || item as Weapon)
			self.Requip_Item(who,cur,item)
		ElseIf(item as Spell)
			self.Requip_Spell(who,cur,item)
		EndIf

		cur += 1
	EndWhile

	StorageUtil.FormListClear(who,"Untamed.Shapeshift.Items")

	Return
EndFunction

Function Requip_Item(Actor who, Int slot, Form what)
{re-equip an item to a spot.}

	Int stupidslot = 0

	If(slot == 0)
		stupidslot = 2
	ElseIf(slot == 1)
		stupidslot = 1
	EndIf

	who.EquipItemEx(what,stupidslot,False,False)

	Return
EndFunction

Function Requip_Spell(Actor who, Int slot, Form what)
{re-equip a spell to a spot}

	who.EquipSpell(what as Spell, slot)

	Return
EndFunction

Function Unequip(Actor who)
{unequip the slot: left right shout.}

	Int cur = 2
	Form item
	Bool store = True

	StorageUtil.FormListClear(who,"Untamed.Shapeshift.Items")

	While(cur >= 0)
		item = who.GetEquippedObject(cur)

		;; remember the item that wasin this slot.
		If(store)
			StorageUtil.FormListAdd(who,"Untamed.Shapeshift.Items",item)
			store = False
		EndIf

		If(item as Armor || item as Weapon)
			self.Unequip_Item(who,cur,item)
		ElseIf(item as Spell)
			self.Unequip_Spell(who,cur,item)
		EndIf

		;; if the game re-equipped an item that was previously in this slot
		;; before the item we just removed we need to bash our face against it
		;; until it stops auto equipping.
		If(who.GetEquippedObject(cur) == None)
			store = True
			cur -= 1
		EndIf
	EndWhile

	Return
EndFunction

Function Unequip_Item(Actor who, Int slot, Form what)
{unequip an item}

	Int stupidslot = 0

	If(slot == 0)
		stupidslot = 2
	ElseIf(slot == 1)
		stupidslot = 1
	EndIf

	who.UnequipItemEx(what,stupidslot,False)

	Return
EndFunction

Function Unequip_Spell(Actor who, Int slot, Form what)
{unequip a spell}

	who.UnequipSpell(what as Spell,slot)
	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function Shapeshift(Actor who, Race what)
{turn into the specified thing.}

	;; unequip weapons and spells.
	self.Unequip(who)
	Utility.Wait(0.1)

	;; transform into the beast.
	StorageUtil.SetFormValue(who,"Untamed.Shapeshift.OriginalRace",who.GetRace())
	who.SetRace(what)
	Game.SetBeastForm(True)

	;; add extra abilities.
	If(what == self.dcc_ut_RaceBearBrown || what == self.dcc_ut_RaceBearBlack || what == self.dcc_ut_RaceBearPolar)
		who.AddSpell(self.dcc_ut_SpellStanceTank)
	ElseIf(what == self.dcc_ut_RaceCatPlain || what == self.dcc_ut_RaceCatSnow)
		who.AddSpell(self.dcc_ut_SpellStanceDamage)
	EndIf

	;; add ability to revert.
	If(!who.HasSpell(self.dcc_ut_SpellUnshift))
		who.AddSpell(self.dcc_ut_SpellUnshift)
	EndIf
	who.EquipSpell(self.dcc_ut_SpellUnshift,2)

	Return
EndFunction

Function Shapeunshift(Actor who)
{revert shapeshift form to original.}

	Race what = who.GetRace()

	;; remove extra abilities.
	If(what == self.dcc_ut_RaceBearBrown || what == self.dcc_ut_RaceBearBlack || what == self.dcc_ut_RaceBearPolar)
		who.RemoveSpell(self.dcc_ut_SpellStanceTank)
	ElseIf(what == self.dcc_ut_RaceCatPlain || what == self.dcc_ut_RaceCatSnow || what == self.dcc_ut_RaceCatTint)
		who.RemoveSpell(self.dcc_ut_SpellStanceDamage)
	EndIf

	;; transform back to original race.
	who.SetRace(StorageUtil.GetFormValue(who,"Untamed.Shapeshift.OriginalRace") as Race)
	Game.SetBeastForm(False)

	;; re-equip what we took off.
	self.Requip(who)

	Return
EndFunction

