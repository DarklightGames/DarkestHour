//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Ardennes_WSSTanker extends DHGETankCrewmanRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_GermanTankCrewAutumnSSPawn')
    RolePawns(1)=(PawnClass=Class'DH_GermanTankCrewAutumnSSPawnB')
    SleeveTexture=Texture'DHGermanCharactersTex.Dot44Sleeve'
    Headgear(0)=Class'DH_WSSHatPanzerA'
    Headgear(1)=Class'DH_WSSHatPanzerB'

    PrimaryWeapons(0)=(Item=Class'DH_M712Weapon')

    SecondaryWeapons(0)=(Item=none)
    SecondaryWeapons(1)=(Item=none) //pistols are removed so that he wouldnt get 2 pistols, m712 counting as one
}
