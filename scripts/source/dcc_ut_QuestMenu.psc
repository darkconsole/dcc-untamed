Scriptname dcc_ut_QuestMenu extends SKI_ConfigBase

Import StorageUtil
Import Utility

dcc_ut_QuestController Property Untamed Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Int Function GetVersion()
	Return 1
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnGameReload()
	parent.OnGameReload()
	Untamed.HasMoonlightTales()
	Untamed.HasUiExtensions()
	Untamed.UpdateBuffValues(Untamed.Player)
	Return
EndEvent

Event OnVersionUpdate(Int ver)
	OnConfigInit()
	Return
EndEvent

Event OnConfigInit()
	Pages = new String[7]
	Pages[0] = "My Pack"
	Pages[1] = "General"
	Pages[2] = "Progression"
	Pages[3] = "Shapeshift"
	Pages[4] = "Stats"
	Pages[5] = "Integrations"
	Pages[6] = "Repair"
	Return
EndEvent

Event OnConfigOpen()
	;; OnVersionUpdate never fucking happens.
	;; this does though.
	;; http://www.loverslab.com/topic/30694-mcms-ski-configbaseonversionupdate-sucks/

	OnConfigInit()

	;; update the player effect when the config is opened. we will use this as
	;; an update mechanism.
	Untamed.Player.RemoveSpell(Untamed.dcc_ut_SpellUntamed)
	Untamed.Player.AddSpell(Untamed.dcc_ut_SpellUntamed)

	Return
EndEvent

Event OnConfigClose()
	Untamed.UpdateBuffValues(Untamed.Player)
	Return
EndEvent

Event OnPageReset(string page)
	UnloadCustomContent()

	If page == "General"
		ShowPageGeneral()
	ElseIf page == "Progression"
		ShowPageProgression()
	ElseIf page == "Shapeshift"
		ShowPageShapeshift()
	ElseIf page == "Stats"
		ShowPageStats()
	ElseIf page == "Integrations"
		ShowPageIntegrations()
	ElseIf page == "Repair"
		ShowPageRepair()
	ElseIf page == "My Pack"
		ShowPagePack()
	Else
		ShowPageIntro()
	EndIf

	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnOptionSelect(Int Menu)

	Bool Val

	If(Menu == MenuResetMod)
		Untamed.Print("The entire mod shall be reset.")
		SetToggleOptionValue(Menu,True)
		Utility.Wait(0.25)
		Untamed.ResetMod(True)
		Return
	ElseIf(Menu == MenuResetModSettings)
		Untamed.Print("The mod settings shall be reset.")
		SetToggleOptionValue(Menu,True)
		Utility.Wait(0.25)
		Untamed.ResetQuest()
		Untamed.ResetModValues()
		Return
	ElseIf(Menu == MenuDebug)
		Untamed.OptDebug = !Untamed.OptDebug
		Val = Untamed.OptDebug
	ElseIf(Menu == MenuPostSexEffect)
		Untamed.OptPostSexEffect = !Untamed.OptPostSexEffect
		Val = Untamed.OptPostSexEffect
	ElseIf(Menu == MenuPostSexPack)
		Untamed.OptPostSexPack = !Untamed.OptPostSexPack
		Val = Untamed.OptPostSexPack
	ElseIf(Menu == MenuLooterClearInv)
		Untamed.OptLooterClearInv = !Untamed.OptLooterClearInv
		Val = Untamed.OptLooterClearInv
	ElseIf(Menu == MenuEnablePreg)
		Untamed.OptEnablePreg = !Untamed.OptEnablePreg
		Val = Untamed.OptEnablePreg
	ElseIf(Menu == MenuCheckPack)
		Untamed.OptCheckPack = !Untamed.OptCheckPack
		Val = Untamed.OptCheckPack
	ElseIf(Menu == MenuCheckPackThrottle)
		Untamed.OptCheckPackThrottle = !Untamed.OptCheckPackThrottle
		Val = Untamed.OptCheckPackThrottle
	ElseIf(Menu == MenuPostSexFollow)
		Untamed.OptPostSexFollow = !Untamed.OptPostSexFollow
		Val = Untamed.OptPostSexFollow
	ElseIf(Menu == MenuMakePackDocile)
		Untamed.OptMakePackDocile = !Untamed.OptMakePackDocile
		Val = Untamed.OptMakePackDocile
	ElseIf(Menu == MenuMateCallCharmAll)
		Untamed.OptMateCallCharmAll = !Untamed.OptMateCallCharmAll
		Val = Untamed.OptMateCallCharmAll
	ElseIf(Menu == MenuMateCallCalmAll)
		Untamed.OptMateCallCalmAll = !Untamed.OptMateCallCalmAll
		Val = Untamed.OptMateCallCalmAll
	ElseIf(Menu == MenuMateCallSkipPack)
		Untamed.OptMateCallSkipPack = !Untamed.OptMateCallSkipPack
		Val = Untamed.OptMateCallSkipPack
	ElseIf(Menu == MenuMateCallEngage)
		Untamed.OptMateCallEngage = !Untamed.OptMateCallEngage
		Val = Untamed.OptMateCallEngage
	ElseIf(Menu == MenuMateCallIncludeCreature)
		Untamed.OptMateCallIncludeCreature = !Untamed.OptMateCallIncludeCreature
		Val = Untamed.OptMateCallIncludeCreature
	ElseIf(Menu == MenuCallSkipToldStay)
		Untamed.OptCallSkipToldStay = !Untamed.OptCallSkipToldStay
		Val = Untamed.OptCallSkipToldStay
	ElseIf(Menu == MenuBeastsCanLevel)
		Untamed.OptBeastsCanLevel = !Untamed.OptBeastsCanLevel
		Val = Untamed.OptBeastsCanLevel
	ElseIf(Menu == MenuBeastsLargerLevel)
		Untamed.OptBeastsLargerLevel = !Untamed.OptBeastsLargerLevel
		Val = Untamed.OptBeastsLargerLevel
	ElseIf(Menu == MenuJerkoffMode)
		Untamed.OptJerkoffMode = !Untamed.OptJerkoffMode
		Val = Untamed.OptJerkoffMode
	EndIf

	SetToggleOptionValue(Menu,Val)
	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnOptionSliderOpen(Int menu)

	Float val
	Float min
	Float max
	Float interval

	If(menu == MenuPregTime)
		val = Untamed.OptPregTime
		min = 0.0
		max = 30.0
		interval = 0.5
	ElseIf(menu == MenuPackScale)
		val = Untamed.OptPackScale
		min = 0.25
		max = 3.0
		interval = 0.05
	ElseIf(menu == MenuBeastScaleHealth)
		val = Untamed.OptBeastScaleHealth
		min = 0.0
		max = 15.0
		interval = 0.1
	ElseIf(menu == MenuBeastScaleStamina)
		val = Untamed.OptBeastScaleStamina
		min = 0.0
		max = 15.0
		interval = 0.1
	ElseIf(menu == MenuBeastScaleAttackDamage)
		val = Untamed.OptBeastScaleAttackDamage
		min = 0.0
		max = 5.0
		interval = 0.001
	ElseIf(menu == MenuBeastScaleDamageResist)
		val = Untamed.OptBeastScaleDamageResist
		min = 0.0
		max = 15.0
		interval = 0.1
	ElseIf(menu == MenuBeastScaleMagicResist)
		val = Untamed.OptBeastScaleMagicResist
		min = 0.0
		max = 15.0
		interval = 0.001
	ElseIf(menu == MenuBaseResistPhysical)
		val = Untamed.OptBaseResistPhysical
		min = 0.0
		max = 100.0
		interval = 1.0
	ElseIf(menu == MenuBaseResistMagic)
		val = Untamed.OptBaseResistMagic
		min = 0.0
		max = 100.0
		interval = 1.0
	ElseIf(menu == MenuScaleResistPhysical)
		val = Untamed.OptScaleResistPhysical
		min = 0.0
		max = 10.0
		interval = 0.5
	ElseIf(menu == MenuScaleResistMagic)
		val = Untamed.OptScaleResistMagic
		min = 0.0
		max = 10.0
		interval = 0.1
	ElseIf(menu == MenuCountUnlockShift)
		val = Untamed.OptCountUnlockShift
		min = 1.0
		max = 25
		interval = 1.0
	ElseIf(menu == MenuFormBear)
		val = Untamed.OptFormBear
		min = 0.0
		max = 2.0
		interval = 1.0
	ElseIf(menu == MenuFormCat)
		val = Untamed.OptFormCat
		min = 0.0
		max = 2.0
		interval = 1.0
	ElseIf(menu == MenuScaleShoutLevel)
		val = Untamed.OptScaleShoutLevel
		min = 0.0
		max = 1.0
		interval = 0.001
	ElseIf(menu == Menu_MT_OptWerewolfSTD)
		val = Untamed.MT_OptWerewolfSTD
		min = 0.0
		max = 100.0
		interval = 0.1
	EndIf

	SetSliderDialogStartValue(val)
	SetSliderDialogRange(min,max)
	SetSliderDialogInterval(interval)
	Return
EndEvent

Event OnOptionSliderAccept(Int menu, Float val)

	String fmt

	If(menu == MenuPregTime)
		fmt = "{0}"
		Untamed.OptPregTime = val
	ElseIf(menu == MenuPackScale)
		fmt = "{2}x"
		Untamed.OptPackScale = val
		Untamed.ResizePack()
	ElseIf(menu == MenuBeastScaleHealth)
		fmt = "{1}"
		Untamed.OptBeastScaleHealth = val
	ElseIf(menu == MenuBeastScaleStamina)
		fmt = "{1}"
		Untamed.OptBeastScaleStamina = val
	ElseIf(menu == MenuBeastScaleAttackDamage)
		fmt = "{3}"
		Untamed.OptBeastScaleAttackDamage = val
	ElseIf(menu == MenuBeastScaleDamageResist)
		fmt = "{1}"
		Untamed.OptBeastScaleDamageResist = val
	ElseIf(menu == MenuBeastScaleMagicResist)
		fmt = "{3}"
		Untamed.OptBeastScaleMagicResist = val
	ElseIf(menu == MenuBaseResistPhysical)
		fmt = "{1}"
		Untamed.OptBaseResistPhysical = val
	ElseIf(menu == MenuBaseResistMagic)
		fmt = "{1}"
		Untamed.OptBaseResistMagic = val
	ElseIf(menu == MenuScaleResistPhysical)
		fmt = "{1}"
		Untamed.OptScaleResistPhysical = val
	ElseIf(menu == MenuScaleResistMagic)
		fmt = "{1}"
		Untamed.OptScaleResistMagic = val
	ElseIf(menu == MenuCountUnlockShift)
		fmt = "{0}"
		Untamed.OptCountUnlockShift = val as Int
	ElseIf(menu == MenuFormBear)
		fmt = "{0}"
		Untamed.OptFormBear = val as Int
	ElseIf(menu == MenuFormCat)
		fmt = "{0}"
		Untamed.OptFormCat = val as Int
	ElseIf(menu == MenuScaleShoutLevel)
		fmt = "{3}"
		Untamed.OptScaleShoutLevel = val
	ElseIf(menu == Menu_MT_OptWerewolfSTD)
		fmt = "{1}%"
		Untamed.MT_OptWerewolfSTD = val
	EndIf

	SetSliderOptionValue(menu,val,fmt)
	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnOptionHighlight(Int Menu)

	If(Menu == MenuResetMod)
		SetInfoText("This is a FULL reset. It will also reset your levels and spells.")
	ElseIf(Menu == MenuResetModSettings)
		SetInfoText("This will only reset the Mod settings, leaving your Untamed level and spells alone.")
	ElseIf(Menu == MenuDebug)
		SetInfoText("Enable a lot of debugging output.")
	ElseIf(Menu == MenuPostSexEffect)
		SetInfoText("Enable the after sex visual effects and sound.")
	ElseIf(Menu == MenuPostSexPack)
		SetInfoText("If enabled any animal sexed will join your pack. If disabled, only animals which were hit by your mating call will be added to the pack.")
	ElseIf(Menu == MenuLooterClearInv)
		SetInfoText("The animal who loots will clear his inventory after you close the trade screen when he offers it. It will be forever gone.")
	ElseIf(Menu == MenuEnablePreg)
		SetInfoText("Hide the Give Birth shout if you do not plan to use it. Will take effect after the next sexing.")
	ElseIf(Menu == MenuPregTime)
		SetInfoText("How long after sexing can you birth an animal. If set to 0 you will be in ARCADE MODE where you can spawn a cub of the last thing you sexed every 10 minutes.")
	ElseIf(Menu == MenuCheckPack)
		SetInfoText("If you are noticing your game studdering every 5 seconds, keep a smaller pack or turn this off. If you turn this off things like Pack Member Death Rage will probably almost never work. BEFORE TURNING THIS OFF attempt the throttle option below.")
	ElseIf(Menu == MenuCheckPackThrottle)
		SetInfoText("This will cause a wait between updating each pack member. May ease jerking.")
	ElseIf(Menu == MenuPostSexFollow)
		SetInfoText("Beasts will join your pack and follow you after sexing them.")
	ElseIf(Menu == MenuMakePackDocile)
		SetInfoText("Attempt to make it so that your beast followers will not be attacked when you get near a city. It does not seem to always work. But hey, we are dealing with wild animals here after all.")
	ElseIf(Menu == MenuMateCallCharmAll)
		SetInfoText("Your Mating Call will charm all animals who heard the call. If you disable this only the one animal that you got to sex with will join your pack.")
	ElseIf(Menu == MenuMateCallCalmAll)
		SetInfoText("Your Mating Call will try to calm all animals who heard it so that they may peacefully join your pack. If you disable this you will need to use a Calm spell before attempting to sex a beast.")
	ElseIf(Menu == MenuMateCallSkipPack)
		SetInfoText("Your Mating Call will not trigger sex with animals already in your pack.")
	ElseIf(Menu == MenuMateCallEngage)
		SetInfoText("Your Mating Call will automatically trigger a sexual encounter.")
	ElseIf(Menu == MenuMateCallIncludeCreature)
		SetInfoText("Your Mating Call will work on additional creature types such as skeletons, dragons, spriggan, and lots of other hillarious things.")
	ElseIf(Menu == MenuCallSkipToldStay)
		SetInfoText("The Call To Me shout will not teleport beasts which you have told to stay.")
	ElseIf(Menu == MenuBeastsCanLevel)
		SetInfoText("Beasts will scale in strength with their Untamed Level in a similar manner as the player.")
	ElseIf(Menu == MenuPackScale)
		SetInfoText("You can shrink or grow the default pack member size.")
	ElseIf(Menu == MenuBeastsLargerLevel)
		SetInfoText("Beasts will grow larger as they level. This might fuck up SexLab scales and animation alignment.")
	ElseIf(Menu == MenuStatLevel)
		SetInfoText("Your current Untamed level. Goes up when you sleep with animals, goes down when you sleep with people.")
	ElseIf(Menu == MenuStatBeastCount)
		SetInfoText("How many beasts you have slept with thusfar.")
	ElseIf(Menu == MenuStatPackSize)
		SetInfoText("How many beasts are currently in your pack. Any beasts which have died will be removed from this list the next time you use Call Pack.")
	ElseIf(Menu == MenuStatResistPhysical)
		SetInfoText("How much invisible armour you have earned based on your Untamed level.")
	ElseIf(Menu == MenuStatResistMagic)
		SetInfoText("How much magic resist you have earned based on your Untamed level.")
	ElseIf(Menu == MenuBeastScaleHealth)
		SetInfoText("How much extra health the beast gets per level.")
	ElseIf(Menu == MenuBeastScaleStamina)
		SetInfoText("How much extra stamina the beast gets per level.")
	ElseIf(Menu == MenuBeastScaleAttackDamage)
		SetInfoText("How much extra attack damage the beast gets per level. Note this is very small. A value of 0.005 means 50% more damage at level 100.")
	ElseIf(Menu == MenuBeastScaleDamageResist)
		SetInfoText("How much extra physical damage resist the beast gets per level. Note this is equivilant to Armor Value.")
	ElseIf(Menu == MenuBeastScaleMagicResist)
		SetInfoText("How much extra magic resist the beast gets per level. Note this is a very small. A value of 0.005 means 50% resist at level 100.")
	ElseIf(Menu == MenuBaseResistPhysical)
		SetInfoText("How much free base armor you get just for having slept with an animal once.")
	ElseIf(Menu == MenuBaseResistMagic)
		SetInfoText("How much free base magic resist you get just for having slept with an animal once.")
	ElseIf(Menu == MenuScaleResistPhysical)
		SetInfoText("How much additional free armor you get for each Untamed level.")
	ElseIf(Menu == MenuScaleResistMagic)
		SetInfoText("How much additional free magic resist you get for each Untamed level.")
	ElseIf(Menu == MenuScaleShoutLevel)
		SetInfoText("How much you level by using the Untamed Shouts. Default 0.125 means 8 shouts = 1 level.")
	ElseIf(Menu == MenuCountUnlockShift)
		SetInfoText("How many times you have to lay with a beast before unlocking that shapeshift.")
	ElseIf(Menu == MenuFormBear)
		SetInfoText("0 = Brown Bear, 1 = Black Bear, 2 = Polar Bear")
	ElseIf(Menu == MenuFormCat)
		SetInfoText("0 = Hair Tint Cat, 1 = Plains Cat, 2 = Snowy Cat")
	ElseIf(Menu == MenuJerkoffMode)
		SetInfoText("Trigger another sex scene as soon as the last one ends. Continues to do so until you press your Shout key. Handy for leveling new followers easily and without intervention.")
	ElseIf(Menu == Menu_MT_Enabled)
		SetInfoText("Is Moonlight Tales installed and activated?")
	ElseIf(Menu == Menu_MT_OptWerewolfSTD)
		SetInfoText("This is the chance of contracting Sanies Lupinus from encounters with werewolves. It works the same as the Vampire disease - once you get it you have time to get rid of it before turning.")
	Else
		SetInfoText("Untamed")
	EndIf

	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function ShowPageIntro()
	LoadCustomContent("untamed/splash.dds")
	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Int MenuPostSexEffect
Int MenuPostSexFollow
Int MenuPostSexHeal
Int MenuMakePackDocile
Int MenuMateCallCharmAll
Int MenuMateCallCalmAll
Int MenuMateCallSkipPack
Int MenuMateCallEngage
Int MenuCallSkipToldStay
Int MenuCheckPack
Int MenuCheckPackThrottle
Int MenuPregTime
Int MenuMateCallIncludeCreature
Int MenuBeastsLargerLevel
Int MenuPackScale
Int MenuLooterClearInv
Int MenuEnablePreg
Int MenuPostSexPack
Int MenuJerkoffMode

Function ShowPageGeneral()
	SetTitleText("General Settings")
	SetCursorFillMode(TOP_TO_BOTTOM)

	SetCursorPosition(0)
	AddHeaderOption("Basic")
	MenuPostSexHeal = AddToggleOption("Post-Sex Heal",Untamed.OptPostSexHeal)
	MenuPostSexEffect = AddToggleOption("Post-Sex SFX",Untamed.OptPostSexEffect)
	MenuPostSexPack = AddToggleOption("Post-Sex Add To Pack",Untamed.OptPostSexPack)
	MenuLooterClearInv = AddToggleOption("Looters clear inventory",Untamed.OptLooterClearInv)
	MenuEnablePreg = AddToggleOption("Pregnancy and birthing",Untamed.OptEnablePreg)
	MenuJerkoffMode = AddToggleOption("Infinite Sex Mode",Untamed.OptJerkoffMode)

	AddHeaderOption("Pack Building")
	MenuPackScale = AddSliderOption("Beasts default size",Untamed.OptPackScale,"{2}x")
	MenuBeastsLargerLevel = AddToggleOption("Beasts grow with level",Untamed.OptBeastsLargerLevel)
	MenuMakePackDocile = AddToggleOption("Make pack docile",Untamed.OptMakePackDocile)
	MenuPregTime = AddSliderOption("Days to birth",Untamed.OptPregTime,"{1} Day(s)")

	SetCursorPosition(1)
	AddHeaderOption("Pack Maintain")
	MenuCheckPack = AddToggleOption("Pack Update Event",Untamed.OptCheckPack)
	MenuCheckPackThrottle = AddToggleOption("Throttle Pack Update",Untamed.OptCheckPackThrottle)

	AddHeaderOption("Shout Tweaks")
	MenuCallSkipToldStay = AddToggleOption("Call To Me: Told To Stay Ignores",Untamed.OptCallSkipToldStay)
	MenuMateCallEngage = AddToggleOption("Mate Call: Automatic Sexy Time",Untamed.OptMateCallEngage)
	MenuMateCallCalmAll = AddToggleOption("Mate Call: Calm all who heard",Untamed.OptMateCallCalmAll)
	MenuMateCallCharmAll = AddToggleOption("Mate Call: Charm all who heard",Untamed.OptMateCallCharmAll)
	MenuMateCallIncludeCreature = AddToggleOption("Mate Call: Include addl. creature type",Untamed.OptMateCallIncludeCreature)
	MenuMateCallSkipPack = AddToggleOption("Mate Call: Skip pack members",Untamed.OptMateCallSkipPack)


	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Int MenuBeastsCanLevel
Int MenuBeastScaleHealth
Int MenuBeastScaleStamina
Int MenuBeastScaleAttackDamage
Int MenuBeastScaleDamageResist
Int MenuBeastScaleMagicResist
Int MenuBaseResistPhysical
Int MenuBaseResistMagic
Int MenuScaleResistPhysical
Int MenuScaleResistMagic
Int MenuScaleShoutLevel

Function ShowPageProgression()
	SetTitleText("Progression")
	SetCursorFillMode(TOP_TO_BOTTOM)

	SetCursorPosition(0)
	AddHeaderOption("Player Progression")
	MenuBaseResistPhysical = AddSliderOption("Physical Resist (Base Armor)",Untamed.OptBaseResistPhysical,"{1}")
	MenuScaleResistPhysical = AddSliderOption("Physical Resist (Per Level Armor)",Untamed.OptScaleResistPhysical,"{1}")
	MenuBaseResistMagic = AddSliderOption("Magic Resist (Base Percent)",Untamed.OptBaseResistMagic,"{1}")
	MenuScaleResistMagic = AddSliderOption("Magic Resist (Per Level Percent)",Untamed.OptScaleResistMagic,"{1}")
	MenuScaleShoutLevel = AddSliderOption("Untamed Shouts Level",Untamed.OptScaleShoutLevel,"{3}")

	SetCursorPosition(1)
	AddHeaderOption("Pack Progression")
	MenuBeastsCanLevel = AddToggleOption("Beasts Can Level",Untamed.OptBeastsCanLevel)
	MenuBeastScaleHealth = AddSliderOption("Health",Untamed.OptBeastScaleHealth,"{1}")
	MenuBeastScaleStamina = AddSliderOption("Stamina",Untamed.OptBeastScaleStamina,"{1}")
	MenuBeastScaleAttackDamage = AddSliderOption("Attack Damage",Untamed.OptBeastScaleAttackDamage,"{3}")
	MenuBeastScaleDamageResist = AddSliderOption("Physical Resist (Armor Value)",Untamed.OptBeastScaleDamageResist,"{1}")
	MenuBeastScaleMagicResist = AddSliderOption("Magic Resist (Percent)",Untamed.OptBeastScaleMagicResist,"{3}")

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Int MenuCountUnlockShift
Int MenuFormBear
Int MenuFormCat

Function ShowPageShapeshift()
	SetTitleText("Shapeshifting")
	SetCursorFillMode(TOP_TO_BOTTOM)

	SetCursorPosition(0)
	MenuCountUnlockShift = AddSliderOption("Encounters to Unlock Shapeshift",Untamed.OptCountUnlockShift,"{0}")

	SetCursorPosition(1)
	MenuFormBear = AddSliderOption("Bear Form Variant",Untamed.OptFormBear,"{0}")
	MenuFormCat = AddSliderOption("Cat Form Variant",Untamed.OptFormCat,"{0}")

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Int MenuResetMod
Int MenuResetModSettings
Int MenuDebug
Int MenuPackListLock

Function ShowPageRepair()
	SetTitleText("Repair")
	SetCursorFillMode(TOP_TO_BOTTOM)

	SetCursorPosition(0)
	AddHeaderOption("Reset")
	MenuResetMod = AddToggleOption("Reset Entire Mod?",False)
	MenuResetModSettings = AddToggleOption("Reset Settings Only?",False)

	SetCursorPosition(1)
	AddHeaderOption("Debugging")
	MenuDebug = AddToggleOption("Debugging Messages",Untamed.OptDebug)
	MenuPackListLock = AddSliderOption("Pack List Spinlock Status",Untamed.PackListLock as Float,"{0}",OPTION_FLAG_DISABLED)

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Int Menu_MT_Enabled
Int Menu_MT_OptWerewolfSTD

Function ShowPageIntegrations()
	SetTitleText("Intergrations")
	SetCursorFillMode(TOP_TO_BOTTOM)

	SetCursorPosition(0)
	AddHeaderOption("Moonlight Tales")
	Menu_MT_Enabled = AddToggleOption("Installed?",Untamed.MT_Enabled,OPTION_FLAG_DISABLED)
	Menu_MT_OptWerewolfSTD = AddSliderOption("Chance of contracting Sanies Lupinus",Untamed.MT_OptWerewolfSTD,"{1}%")

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function ShowPagePack()
	SetTitleText("My Pack")
	SetCursorPosition(0)

	;; header row.
	AddHeaderOption("Name / Race")
	AddHeaderOption("Info")

	AddTextOption(Untamed.Player.GetDisplayName(),Untamed.Player.GetRace().GetName())
	AddTextOption("Leader",(Utility.GetCurrentGameTime() as Int) + " Days; Lvl " + (Untamed.GetLevel(Untamed.Player) as Int))

	Int a
	Int len = Untamed.GetPackSize()

	a = 0
	While(a < len)
		Actor animal = Untamed.GetPackMember(a)
		Int days = (Utility.GetCurrentGameTime() - Untamed.GetWhenJoined(animal)) as Int
		Int level = Untamed.GetLevel(animal) as Int
		String followaction = Untamed.FollowerWhatDo(animal)

		AddTextOption(animal.GetDisplayName(),animal.GetRace().GetName())
		AddTextOption("" + (((animal.GetScale()*100) as Int) As Float / 100.0) + "x; " + followaction, days + " Days; Lvl " + level)

		a += 1
	EndWhile

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Int MenuStatLevel
Int MenuStatBearCount
Int MenuStatBeastCount
Int MenuStatBirthCount
Int MenuStatCatCount
Int MenuStatPackSize
Int MenuStatResistPhysical
Int MenuStatResistMagic
Int MenuStatCurrentPreg

Function ShowPageStats()

	;; Untamed.CleanPackList()

	Int a = 0

	SetTitleText("Stats")
	SetCursorFillMode(TOP_TO_BOTTOM)

	SetCursorPosition(0)
	AddHeaderOption("Gameplay")
	MenuStatLevel = AddSliderOption("Untamed Level",Untamed.GetLevel(Untamed.Player),"{1}",OPTION_FLAG_DISABLED)
	MenuStatResistPhysical = AddSliderOption(" - Physical Resist",Untamed.UpdateBuffValues_ResistPhysical(Untamed.Player),"{1} Armor",OPTION_FLAG_DISABLED)
	MenuStatResistMagic = AddSliderOption(" - Magic Resist",Untamed.UpdateBuffValues_ResistMagic(Untamed.Player),"{1}%",OPTION_FLAG_DISABLED)

	AddHeaderOption("Beast Stats")
	MenuStatBearCount = AddSliderOption("Bear Count",Untamed.GetCountBears(Untamed.Player),"{0}",OPTION_FLAG_DISABLED)
	MenuStatCatCount = AddSliderOption("Cat Count",Untamed.GetCountCats(Untamed.Player),"{0}",OPTION_FLAG_DISABLED)

	SetCursorPosition(1)
	AddHeaderOption("Other")
	MenuStatBeastCount = AddSliderOption("Times With Beasts",Untamed.GetCountBeasts(Untamed.Player),"{0} Beasts",OPTION_FLAG_DISABLED)
	MenuStatBirthCount = AddSliderOption("Beasts Birthed",Untamed.GetCountBirths(Untamed.Player),"{0} Cubs",OPTION_FLAG_DISABLED)
	If(Untamed.IsPreg(Untamed.Player))
		MenuStatCurrentPreg = AddToggleOption("Pregnant (" + Untamed.GetPregWith(Untamed.Player).GetName() + ")",True,OPTION_FLAG_DISABLED)
	Else
		MenuStatCurrentPreg = AddToggleOption("Pregnant (NONE)",False,OPTION_FLAG_DISABLED)
	EndIf

	Return
EndFunction

