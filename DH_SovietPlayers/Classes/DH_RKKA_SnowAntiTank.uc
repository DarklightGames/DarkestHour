//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_SnowAntiTank extends DHSOVAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietSnowPawn',Weight=1.0)
    DetachedArmClass=Class'SeveredArmSovSnow'
    DetachedLegClass=Class'SeveredLegSovSnow'
    SleeveTexture=Texture'Weapons1st_tex.Arms.RussianSnow_Sleeves'
    Grenades(0)=(Item=Class'DH_RPG43GrenadeWeapon')
    Headgear(0)=Class'DH_SovietHelmetSnow'
    HandType=Hand_Gloved
    GlovedHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_whitegloves'
}
