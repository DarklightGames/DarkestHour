//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USPlatoonMG502101st extends DH_US_502PIR;

function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.2)
        return Headgear[0];
    else
        return Headgear[1];
}

defaultproperties
{
     MyName="Machine-Gunner"
     AltName="Machine-Gunner"
     Article="a "
     PluralName="Machine-Gunners"
     InfoText="The machine-gunner is tasked with the tactical employment of the medium machine gun to provide direct fire support to his squad, and in many cases being its primary source of mid- and long-range firepower. Due to the medium machine gun's high rate of fire, an adequate supply of ammunition is needed to maintain a constant rate of fire, provided largely by his accompanying units."
     MenuImage=Texture'DHUSCharactersTex.Icons.ABPMG'
     Models(0)="US_502101AB1"
     Models(1)="US_502101AB2"
     Models(2)="US_502101AB3"
     bIsGunner=true
     SleeveTexture=Texture'DHUSCharactersTex.Sleeves.USAB_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_30calWeapon',Amount=6)
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_ColtM1911Weapon',Amount=1)
     Headgear(0)=Class'DH_USPlayers.DH_AmericanHelmet502101stEMa'
     Headgear(1)=Class'DH_USPlayers.DH_AmericanHelmet502101stEMb'
     bCarriesMGAmmo=false
     PrimaryWeaponType=WT_LMG
     Limit=1
}
