// *************************************************************************
//
//  ***   Heer Mortar Operator   ***
//
// *************************************************************************

class DH_WHMortarObserver_Autumn extends DH_HeerAutumn;

function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.2)
        return Headgear[0];
    else
        return Headgear[1];
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
     Models(0)="WHAu_1"
     Models(1)="WHAu_2"
     Models(2)="WHAu_3"
     Models(3)="WHAu_4"
     Models(4)="WHAu_5"
     Models(5)="WHAu_6"
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.SplinterASleeve'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_Kar98Weapon',Amount=18,AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
     Grenades(0)=(Item=Class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
     GivenItems(0)="DH_Equipment.DH_GerMortarBinocularsItem"
     Headgear(0)=Class'DH_GerPlayers.DH_HeerHelmetCover'
     Headgear(1)=Class'DH_GerPlayers.DH_HeerHelmetNoCover'
     Limit=1
}
