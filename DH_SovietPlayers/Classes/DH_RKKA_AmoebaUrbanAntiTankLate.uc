//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_AmoebaUrbanAntiTankLate extends DHSOVAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietAmoebaUrbanLatePawn',Weight=1.0)
    Headgear(0)=Class'DH_SovietSidecap'
    Headgear(1)=Class'DH_SovietHelmet'
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
    SleeveTexture=Texture'DHSovietCharactersTex.AmoebaUrbanSleeves'
    Grenades(0)=(Item=Class'DH_RPG43GrenadeWeapon')
    GivenItems(0)="none"
}
