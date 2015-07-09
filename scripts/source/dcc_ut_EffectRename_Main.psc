Scriptname dcc_ut_EffectRename_Main extends ActiveMagicEffect

dcc_ut_QuestController Property Untamed Auto

Event OnEffectStart(Actor target, Actor caster)
	Untamed.FollowerRename(target)
	Return
EndEvent
