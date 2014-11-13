//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_WHMortarObserverC extends DH_HeerCamo;

function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.2)
    {
        return Headgear[0];
    }
    else
    {
        return Headgear[1];
    }
}

defaultproperties
{
     bIsMortarObserver=true
     MyName="Mortar Observer"
     AltName="Werferbeobachter"
     Article="a "
     PluralName="Mortar Observers"
     InfoText="The mortar observer is tasked with assisting the mortar operator by acquiring and marking targets using his binoculars.  Targets marked by the mortar observer will be relayed to the mortar operator."
     MenuImage=Texture'DHGermanCharactersTex.Icons.WH_MortarObserver'
     Models(0)="WH_C1"
     Models(1)="WH_C2"
     Models(2)="WH_C3"
     Models(3)="WH_C4"
     Models(4)="WH_C5"
     Models(5)="WH_C6"
     SleeveTexture=Texture'Weapons1st_tex.Arms.german_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_Kar98Weapon',Amount=18,AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
     Grenades(0)=(Item=Class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
     GivenItems(0)="DH_Equipment.DH_GerMortarBinocularsItem"
     Headgear(0)=Class'DH_GerPlayers.DH_HeerHelmetOne'
     Headgear(1)=Class'DH_GerPlayers.DH_HeerHelmetTwo'
     Limit=1
}
