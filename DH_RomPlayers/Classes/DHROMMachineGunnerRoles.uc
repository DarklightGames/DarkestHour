//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHROMMachineGunnerRoles extends DHRomRoles
    abstract;

defaultproperties
{
    bIsGunner=true
    MyName="Light Machine-Gunner"
    AltName="aaa"
    Limit=3
    bCanCarryExtraAmmo=false
    AddedRoleRespawnTime=16
    bCanBeSquadLeader=false
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Zb30Weapon')

    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_BerettaM1934Weapon') //add m1912

    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.8

    HandType=Hand_Gloved
}
