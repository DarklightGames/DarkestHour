//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_WSSGunner extends DH_WaffenSS;

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
     AltName="Maschinengewehrschütze"
     Article="a "
     PluralName="Machine-Gunners"
     InfoText="The machine-gunner is tasked with the tactical employment of the light machine gun to provide direct fire support to his squad, and in many cases being its primary source of mid- and long-range firepower. Due to the light machine gun's high rate of fire, an adequate supply of ammunition is needed to maintain a constant rate of fire, provided largely by his accompanying units."
     MenuImage=Texture'DHGermanCharactersTex.Icons.WSS_MG'
     Models(0)="SS_1"
     Models(1)="SS_2"
     Models(2)="SS_3"
     Models(3)="SS_4"
     Models(4)="SS_5"
     Models(5)="SS_6"
     bIsGunner=true
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_MG42Weapon',Amount=6)
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_MG34Weapon',Amount=6)
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_P38Weapon',Amount=1)
     SecondaryWeapons(1)=(Item=Class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
     Headgear(0)=Class'DH_GerPlayers.DH_SSHelmetOne'
     Headgear(1)=Class'DH_GerPlayers.DH_SSHelmetTwo'
     bCarriesMGAmmo=false
     PrimaryWeaponType=WT_LMG
     Limit=2
}
