//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USMortarObserver502101st extends DH_US_502PIR;

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
     MenuImage=Texture'DHUSCharactersTex.Icons.IconMortarObserver'
     Models(0)="US_502101AB1"
     Models(1)="US_502101AB2"
     Models(2)="US_502101AB3"
     SleeveTexture=Texture'DHUSCharactersTex.Sleeves.USAB_sleeves'
     PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M1CarbineWeapon',Amount=6,AssociatedAttachment=class'DH_Weapons.DH_M1CarbineAmmoPouch')
     PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_M1GarandWeapon',Amount=6,AssociatedAttachment=class'DH_Weapons.DH_M1GarandAmmoPouch')
     SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_ColtM1911Weapon',Amount=1)
     Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon',Amount=2)
     GivenItems(0)="DH_Equipment.DH_USMortarBinocularsItem"
     Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet502101stEMa'
     Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet502101stEMb'
     PrimaryWeaponType=WT_SemiAuto
     Limit=1
}
