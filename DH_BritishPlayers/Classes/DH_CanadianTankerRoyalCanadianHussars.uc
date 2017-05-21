//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_CanadianTankerRoyalCanadianHussars extends DH_RoyalCanadianHussars;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_BritishPlayers.DH_CanadianRoyalHussarsPawn',Weight=1.0)
    MyName="Tank Crewman"
    AltName="Tank Crewman"
    Article="a "
    PluralName="Tank Crewmen"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_StenMkIIWeapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo2Weapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItem"
    Headgear(0)=class'DH_BritishPlayers.DH_CanadianTankerBeret'
    bCanBeTankCrew=true
    Limit=3
}
