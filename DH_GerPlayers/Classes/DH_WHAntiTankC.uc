//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WHAntiTankC extends DHGEAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_GermanCamoHeerPawn',Weight=4.0)
    RolePawns(1)=(PawnClass=Class'DH_GermanCamoHeerPawnB',Weight=4.0)
    RolePawns(2)=(PawnClass=Class'DH_GermanSniperHeerPawn',Weight=1.0)
    SleeveTexture=Texture'Weapons1st_tex.german_sleeves'
    Headgear(0)=Class'DH_HeerHelmetOne'
    Headgear(1)=Class'DH_HeerHelmetTwo'
    GivenItems(0)="DH_Weapons.DH_PanzerschreckWeapon_Camo"
}
