//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WHArtilleryGunner extends DHGERiflemanRoles;

defaultproperties
{
    MyName="Artillery Gunner"
    AltName="Artillerie Schütze"

    RolePawns(0)=(PawnClass=Class'DH_GermanArtilleryHeerPawn')
    Headgear(0)=Class'DH_HeerHelmetThree'
    Headgear(1)=Class'DH_HeerHelmetTwo'

    Grenades(0)=(Item=none)
}
