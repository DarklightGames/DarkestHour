//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_VSGunner extends DHGEMachineGunnerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_VSGreatCoatPawn',Weight=1.0)
    RolePawns(1)=(PawnClass=class'DH_GerPlayers.DH_VSGreatCoatPawnB',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Volkssturm_sleeve'
    Headgear(0)=class'ROInventory.ROGermanHat'
    Headgear(1)=class'ROInventory.ROGermanHat'
	
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_ZB30Weapon') // TO DO: wz28
    PrimaryWeapons(1)=(Item=none)
    PrimaryWeapons(2)=(Item=none)
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_Nagant1895Weapon') // TO DO: some other weird sidearms?
    SecondaryWeapons(1)=(Item=none)
    SecondaryWeapons(2)=(Item=none)
}
