//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BritishPlatoonMGHampshires extends DH_Hampshires;

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
    {
        return Headgear[0];
    }
}

defaultproperties
{
     MyName="Machine-Gunner"
     AltName="Machine-Gunner"
     Article="a "
     PluralName="Machine-Gunners"
     InfoText="The machine-gunner is tasked with the tactical employment of the light machine gun to provide direct fire support to his squad, and in many cases being its primary source of mid- and long-range firepower. Due to the light machine gun's high rate of fire, an adequate supply of ammunition is needed to maintain a constant rate of fire, provided largely by his accompanying units."
     MenuImage=Texture'DHBritishCharactersTex.Icons.Brit_PMG'
     Models(0)="Hamp_1"
     Models(1)="Hamp_2"
     Models(2)="Hamp_3"
     Models(3)="Hamp_4"
     Models(4)="Hamp_5"
     Models(5)="Hamp_6"
     bIsGunner=true
     SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
     PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_30calWeapon',Amount=6)
     SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo2Weapon',Amount=1)
     Headgear(0)=class'DH_BritishPlayers.DH_BritishTurtleHelmet'
     Headgear(1)=class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
     Headgear(2)=class'DH_BritishPlayers.DH_BritishTommyHelmet'
     bCarriesMGAmmo=false
     PrimaryWeaponType=WT_LMG
     Limit=1
}
