//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_RKKA_SnowRadioOperatorEarly extends DHSOVRadioOperatorRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietSnowStrapsPawn',Weight=1.0)
    SleeveTexture=Texture'Weapons1st_tex.Arms.RussianSnow_Sleeves'
    DetachedArmClass=class'ROEffects.SeveredArmSovSnow'
    DetachedLegClass=class'ROEffects.SeveredLegSovSnow'
    Headgear(0)=class'DH_SovietPlayers.DH_SovietHelmetSnow'
    HandType=Hand_Gloved
    GlovedHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_whitegloves'
	Backpack(0)=(BackpackClass=class'DH_SovietPlayers.DH_SovRadioBackpack',LocationOffset=(X=-0.1))
}
