//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WHAntiTank_Autumn extends DHGEAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_GermanParkaHeerPawnB',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_GermanSmockHeerPawn',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.SplinterASleeve'
    Headgear(0)=Class'DH_HeerHelmetCover'
    Headgear(1)=Class'DH_HeerHelmetNoCover'
    GivenItems(0)="DH_Weapons.DH_PanzerschreckWeapon_Camo"
}
