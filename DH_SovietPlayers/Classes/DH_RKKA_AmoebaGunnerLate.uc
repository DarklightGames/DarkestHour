//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_AmoebaGunnerLate extends DHSOVMachineGunnerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietAmoebaLatePawn',Weight=1.0)
    SleeveTexture=Texture'DHSovietCharactersTex.AmoebaGreenSleeves'
    Headgear(0)=Class'DH_SovietSidecap'
    
    PrimaryWeapons(0)=(Item=Class'DH_DP27LateWeapon')
}
