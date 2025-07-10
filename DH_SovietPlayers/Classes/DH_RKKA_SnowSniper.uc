//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_SnowSniper extends DHSOVSniperRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietSnowPawn',Weight=1.0)
    SleeveTexture=Texture'Weapons1st_tex.RussianSnow_Sleeves'
    DetachedArmClass=Class'SeveredArmSovSnow'
    DetachedLegClass=Class'SeveredLegSovSnow'
    Headgear(0)=Class'DH_SovietHelmetSnow'
    HandType=Hand_Gloved
    GlovedHandTexture=Texture'DHSovietCharactersTex.hands_whitegloves'
}
