//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_WHArtilleryGunner extends DHGETankCrewmanRoles;

defaultproperties
{
    MyName="Artillery Gunner"
    AltName="Artillerie Schütze"
    Article="a "
    PluralName="Artillery Gunners"

    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_GermanArtilleryHeerPawn')
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetThree'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetTwo'

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    PrimaryWeapons(1)=(Item=none)
}
