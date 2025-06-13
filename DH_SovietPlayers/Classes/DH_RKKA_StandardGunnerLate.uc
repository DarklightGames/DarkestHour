//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_StandardGunnerLate extends DHSOVMachineGunnerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietTunicLatePawn',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_SovietTunicM43SergeantPawnB',Weight=1.0)
    RolePawns(2)=(PawnClass=Class'DH_SovietTunicM43SergeantGreenPawnB',Weight=1.0)
    RolePawns(3)=(PawnClass=Class'DH_SovietTunicM43SergeantDarkPawnB',Weight=1.0)
    SleeveTexture=Texture'DHSovietCharactersTex.DH_rus_sleeves'
    
    PrimaryWeapons(0)=(Item=Class'DH_DP27LateWeapon')
}
