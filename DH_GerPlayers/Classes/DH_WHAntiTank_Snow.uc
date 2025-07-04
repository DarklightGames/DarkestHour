//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WHAntiTank_Snow extends DHGEAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_GermanParkaSnowHeerPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_GermanSmockToqueHeerPawn',Weight=1.0)
    SleeveTexture=Texture'Weapons1st_tex.RussianSnow_Sleeves'
    Headgear(0)=Class'DH_HeerHelmetCover'
    Headgear(1)=Class'DH_HeerHelmetSnow'
    GivenItems(0)="DH_Weapons.DH_PanzerschreckWeapon_Winter"
    HandType=HAND_Gloved
}
