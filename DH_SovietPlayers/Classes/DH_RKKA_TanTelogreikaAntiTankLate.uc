//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_TanTelogreikaAntiTankLate extends DHSOVAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietTanTeloLatePawn',Weight=1.0)
    Headgear(0)=Class'DH_SovietFurHat'
    Headgear(1)=Class'DH_SovietHelmet'
    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.8
    SleeveTexture=Texture'DHSovietCharactersTex.DH_rus_sleeves_tan'
    Grenades(0)=(Item=Class'DH_RPG43GrenadeWeapon')
    GivenItems(0)="none"
}
