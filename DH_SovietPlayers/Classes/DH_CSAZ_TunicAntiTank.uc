//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_CSAZ_TunicAntiTank extends DHCSAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_CSAZTunicGPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_CSAZTunicGBritpackPawn',Weight=1.0)
    RolePawns(2)=(PawnClass=Class'DH_CSAZTunicGSidorPawn',Weight=1.0)
    Headgear(0)=Class'DH_CSAZSidecap'
    Headgear(1)=Class'DH_BritishTommyHelmet'
    Headgear(2)=Class'DH_SovietHelmet'
    HeadgearProbabilities(0)=0.6
    HeadgearProbabilities(1)=0.2
    HeadgearProbabilities(2)=0.2
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_rus_sleeves'
    Grenades(0)=(Item=Class'DH_RPG43GrenadeWeapon')
    GivenItems(0)="none"
}
