//=============================================================================
// DH_USMortarObserver3rd
//=============================================================================
class DH_USMortarObserver3rd extends DH_US_3rd_Infantry;

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
     AltName="Mortar Observer"
     Article="a "
     PluralName="Mortar Observers"
     InfoText="The mortar observer is tasked with assisting the mortar operator by acquiring and marking targets using his binoculars.  Targets marked by the mortar observer will be relayed to the mortar operator."
     menuImage=Texture'DHUSCharactersTex.Icons.IconMortarObserver'
     Models(0)="US_3Inf1"
     Models(1)="US_3Inf2"
     Models(2)="US_3Inf3"
     Models(3)="US_3Inf4"
     Models(4)="US_3Inf5"
     SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_M1CarbineWeapon',Amount=6,AssociatedAttachment=Class'DH_Weapons.DH_M1CarbineAmmoPouch')
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_M1GarandWeapon',Amount=6,AssociatedAttachment=Class'DH_Weapons.DH_M1GarandAmmoPouch')
     Grenades(0)=(Item=Class'DH_Weapons.DH_M1GrenadeWeapon',Amount=2)
     GivenItems(0)="DH_Equipment.DH_USMortarBinocularsItem"
     Headgear(0)=Class'DH_USPlayers.DH_AmericanHelmet3rdEMa'
     Headgear(1)=Class'DH_USPlayers.DH_AmericanHelmet3rdEMb'
     PrimaryWeaponType=WT_SemiAuto
     limit=1
}
