//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_CanadianTanker1stHussars extends DH_1stHussars;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_BritishPlayers.DH_CanadianOfficer1stPawn',Weight=1.0)
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
