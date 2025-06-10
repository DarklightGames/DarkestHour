//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_VSGunner extends DHGEMachineGunnerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_VSGreatCoatPawn',Weight=1.0)
    RolePawns(1)=(PawnClass=Class'DH_VSGreatCoatPawnB',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Volkssturm_sleeve'
    Headgear(0)=Class'ROGermanHat'
    Headgear(1)=Class'ROGermanHat'
	
    PrimaryWeapons(0)=(Item=Class'DH_ZB30Weapon') // TO DO: wz28
    PrimaryWeapons(1)=(Item=none)
    PrimaryWeapons(2)=(Item=none)
    SecondaryWeapons(0)=(Item=Class'DH_Nagant1895Weapon') // TO DO: some other weird sidearms?
    SecondaryWeapons(1)=(Item=none)
    SecondaryWeapons(2)=(Item=none)
    
    bCanBeSquadLeader=false
}
