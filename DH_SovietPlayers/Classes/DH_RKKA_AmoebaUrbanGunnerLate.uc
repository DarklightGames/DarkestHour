//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_AmoebaUrbanGunnerLate extends DHSOVMachineGunnerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietAmoebaUrbanLatePawn',Weight=1.0)
    SleeveTexture=Texture'DHSovietCharactersTex.AmoebaUrbanSleeves'
    Headgear(0)=Class'DH_SovietSidecap'
    
    PrimaryWeapons(0)=(Item=Class'DH_DP27LateWeapon')
}
