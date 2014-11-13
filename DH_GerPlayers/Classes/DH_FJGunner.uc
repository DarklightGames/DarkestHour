//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_FJGunner extends DH_FJ;

function class<ROHeadgear> GetHeadgear()
{
    local int RandNum;
    RandNum = Rand(11);

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
     MyName="Machine-Gunner"
     AltName="Maschinengewehrschütze"
     Article="a "
     PluralName="Machine-Gunners"
     InfoText="The machine-gunner is tasked with the tactical employment of the light machine gun to provide direct fire support to his squad, and in many cases being its primary source of mid- and long-range firepower. Due to the light machine gun's high rate of fire, an adequate supply of ammunition is needed to maintain a constant rate of fire, provided largely by his accompanying units."
     MenuImage=Texture'DHGermanCharactersTex.Icons.FJ_MG'
     Models(0)="FJ1"
     Models(1)="FJ2"
     Models(2)="FJ3"
     Models(3)="FJ4"
     Models(4)="FJ5"
     bIsGunner=true
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
     PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MG42Weapon',Amount=6)
     PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_MG34Weapon',Amount=6)
     SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon',Amount=1)
     Headgear(0)=class'DH_GerPlayers.DH_FJHelmetCamo1'
     Headgear(1)=class'DH_GerPlayers.DH_FJHelmetCamo2'
     Headgear(2)=class'DH_GerPlayers.DH_FJHelmetNet1'
     bCarriesMGAmmo=false
     PrimaryWeaponType=WT_LMG
     Limit=2
}
