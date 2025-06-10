//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WSSAntiTank_Autumn extends DHGEAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_GermanParkaSSPawn',Weight=1.5)
    RolePawns(1)=(PawnClass=Class'DH_GermanAutumnSmockSSPawn',Weight=1.0)
    RolePawns(2)=(PawnClass=Class'DH_GermanAutumnSSPawn',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
    Headgear(0)=Class'DH_SSHelmetCover'
    Headgear(1)=Class'DH_SSHelmetNoCover'

    PrimaryWeapons(1)=(Item=Class'DH_G43Weapon',AssociatedAttachment=Class'ROInventory.ROG43AmmoPouch')
}
