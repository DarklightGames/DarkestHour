//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BritishMortarObserver extends DH_British_Infantry;

function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.2)
    {
        if (FRand() < 0.5)
            return Headgear[2];
        else
            return Headgear[1];
    }
    else
        return Headgear[0];
}

defaultproperties
{
    bIsMortarObserver=true
    MyName="Mortar Observer"
    AltName="Mortar Observer"
    Article="a "
    PluralName="Mortar Observers"
    InfoText="The mortar observer is tasked with assisting the mortar operator by acquiring and marking targets using his binoculars.  Targets marked by the mortar observer will be relayed to the mortar operator."
    MenuImage=texture'DHBritishCharactersTex.Icons.Brit_MortarObserver'
    Models(0)="PBI_1"
    Models(1)="PBI_2"
    Models(2)="PBI_3"
    Models(3)="PBI_4"
    Models(4)="PBI_5"
    Models(5)="PBI_6"
    SleeveTexture=texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo4Weapon',Amount=6)
    Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon',Amount=1)
    GivenItems(0)="DH_Engine.DH_BinocularsItem"
    Headgear(0)=class'DH_BritishPlayers.DH_BritishTurtleHelmet'
    Headgear(1)=class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
    Headgear(2)=class'DH_BritishPlayers.DH_BritishTommyHelmet'
}
