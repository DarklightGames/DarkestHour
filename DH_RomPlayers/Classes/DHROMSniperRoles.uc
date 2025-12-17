//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHROMSniperRoles extends DHRomRoles
    abstract;

defaultproperties
{
    MyName="Sniper"
    AltName="aaa"
    Limit=1
    AddedRoleRespawnTime=5
    bExemptSquadRequirement=true
    bCanBeSquadLeader=false
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Vz24ScopedWeapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_BerettaM1934Weapon')  //add m1912

    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
}
