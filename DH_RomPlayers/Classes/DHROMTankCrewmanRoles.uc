//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHROMTankCrewmanRoles extends DHRomRoles
    abstract;

defaultproperties
{
    bCanBeTankCrew=true
    bExemptSquadRequirement=true
    MyName="Tank Crewman"
    AltName="aaa"
    Limit=3
    bCanCarryExtraAmmo=false
    AddedRoleRespawnTime=15
    //PrimaryWeapons(0)=

    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_BerettaM1934Weapon') //add m1912
    GivenItems(0)="DH_Equipment.DHBinocularsItemGerman" //?
}
