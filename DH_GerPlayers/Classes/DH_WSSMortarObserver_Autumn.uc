// *************************************************************************
//
//  ***   SS Mortar Observer   ***
//
// *************************************************************************

class DH_WSSMortarObserver_Autumn extends DH_WaffenSSAutumn;

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
     MenuImage=Texture'DHGermanCharactersTex.Icons.WSS_MortarObserver'
     Models(0)="SSA_1"
     Models(1)="SSA_2"
     Models(2)="SSA_3"
     Models(3)="SSA_4"
     Models(4)="SSA_5"
     Models(5)="SSA_6"
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_Kar98Weapon',Amount=18,AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
     Grenades(0)=(Item=Class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
     GivenItems(0)="DH_Equipment.DH_GerMortarBinocularsItem"
     Headgear(0)=Class'DH_GerPlayers.DH_SSHelmetCover'
     Headgear(1)=Class'DH_GerPlayers.DH_SSHelmetNoCover'
     Limit=1
}
