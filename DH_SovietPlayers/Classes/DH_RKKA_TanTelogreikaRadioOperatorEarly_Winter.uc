//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_RKKA_TanTelogreikaRadioOperatorEarly_Winter extends DHSOVRadioOperatorRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietTanTeloStrapsEarlyPawn_Winter',Weight=1.0)
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_rus_sleeves_tan'
    Headgear(0)=class'DH_SovietPlayers.DH_SovietHelmet'
    HeadgearProbabilities(0)=1.0
    HandType=Hand_Gloved
	Backpack(0)=(BackpackClass=class'DH_SovietPlayers.DH_SovRadioBackpack',LocationOffset=(X=-0.1))
}
