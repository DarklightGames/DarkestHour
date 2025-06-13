//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PzLehrAntiTank extends DHGEAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_PanzerLehrPawn',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.pzlehr_sleeve'
    Headgear(0)=Class'DH_HeerHelmetOne'
    Headgear(1)=Class'DH_HeerHelmetTwo'
    GivenItems(0)="DH_Weapons.DH_PanzerschreckWeapon_Camo"
}
