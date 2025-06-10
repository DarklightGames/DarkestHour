//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WHArtilleryGunner extends DHGETankCrewmanRoles;

defaultproperties
{
    MyName="Artillery Gunner"
    AltName="Artillerie Schütze"

    RolePawns(0)=(PawnClass=Class'DH_GermanArtilleryHeerPawn')
    Headgear(0)=Class'DH_HeerHelmetThree'
    Headgear(1)=Class'DH_HeerHelmetTwo'

    PrimaryWeapons(0)=(Item=Class'DH_Kar98Weapon',AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
    PrimaryWeapons(1)=(Item=none)
}
