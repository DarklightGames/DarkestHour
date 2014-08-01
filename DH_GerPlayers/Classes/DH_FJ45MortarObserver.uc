// *************************************************************************
//	***   FJ Mortar Observer   ***
// *************************************************************************

class DH_FJ45MortarObserver extends DH_FJ_1945;

function class<ROHeadgear> GetHeadgear()
{
    local int RandNum;
    RandNum = Rand(3);

    switch (RandNum)
    {
        case 0:
             return Headgear[0];
        case 1:
             return Headgear[1];
        case 2:
             return Headgear[2];
        default:
             return Headgear[0];
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
     menuImage=Texture'DHGermanCharactersTex.Icons.FJ_MortarObserver'
     Models(0)="FJ451"
     Models(1)="FJ452"
     Models(2)="FJ453"
     Models(3)="FJ454"
     Models(4)="FJ455"
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_Kar98Weapon',Amount=18)
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_P38Weapon',Amount=1)
     Grenades(0)=(Item=Class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
     GivenItems(0)="DH_Equipment.DH_GerMortarBinocularsItem"
     Headgear(0)=Class'DH_GerPlayers.DH_FJHelmet1'
     Headgear(1)=Class'DH_GerPlayers.DH_FJHelmet2'
     Headgear(2)=Class'DH_GerPlayers.DH_FJHelmetNet1'
     limit=1
}
