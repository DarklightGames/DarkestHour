//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_StandardAntiTankLate extends DHSOVAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietTunicNocoatLatePawn',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_SovietTunicLatePawn',Weight=1.0)
    RolePawns(2)=(PawnClass=Class'DH_SovietTunicM43PawnA',Weight=1.0)
    RolePawns(3)=(PawnClass=Class'DH_SovietTunicM43PawnB',Weight=1.0)
    RolePawns(4)=(PawnClass=Class'DH_SovietTunicM43GreenPawnA',Weight=1.0)
    RolePawns(5)=(PawnClass=Class'DH_SovietTunicM43GreenPawnB',Weight=1.0)
    RolePawns(6)=(PawnClass=Class'DH_SovietTunicM43DarkPawnA',Weight=1.0)
    RolePawns(7)=(PawnClass=Class'DH_SovietTunicM43DarkPawnB',Weight=1.0)

    Headgear(0)=Class'DH_SovietSidecap'
    Headgear(1)=Class'DH_SovietHelmet'
    HeadgearProbabilities(0)=0.1
    HeadgearProbabilities(1)=0.9
    SleeveTexture=Texture'DHSovietCharactersTex.DH_rus_sleeves'
    Grenades(0)=(Item=Class'DH_RPG43GrenadeWeapon')
    GivenItems(0)="none"
}
