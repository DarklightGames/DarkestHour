//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BritishSquadMGOx_Bucks extends DH_Ox_Bucks;

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
     MyName="Bren Gunner"
     AltName="Bren Gunner"
     Article="a "
     PluralName="Bren Gunners"
     InfoText="The Bren gunner is tasked with the tactical employment of the light machine gun to provide direct fire support to his squad, and in many cases being its primary source of mid- and long-range firepower. Due to the light machine gun's high rate of fire, an adequate supply of ammunition is needed to maintain a constant rate of fire, provided largely by his accompanying units."
     MenuImage=Texture'DHBritishCharactersTex.Icons.Para_SMG'
     Models(0)="para1"
     Models(1)="para2"
     Models(2)="para3"
     Models(3)="para4"
     Models(4)="para5"
     Models(5)="para6"
     bIsGunner=true
     SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.Brit_Para_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_BrenWeapon',Amount=6)
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_EnfieldNo2Weapon',Amount=1)
     Headgear(0)=Class'DH_BritishPlayers.DH_BritishParaHelmet1'
     Headgear(1)=Class'DH_BritishPlayers.DH_BritishParaHelmet2'
     Headgear(2)=Class'DH_BritishPlayers.DH_BritishAirborneBeretOx_Bucks'
     bCarriesMGAmmo=false
     PrimaryWeaponType=WT_LMG
     Limit=4
}
