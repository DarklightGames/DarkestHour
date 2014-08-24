//=============================================================================
// DH_BritishSquadMGRMCommando
//=============================================================================
class DH_BritishSquadMGRMCommando extends DH_RoyalMarineCommandos;

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
     MenuImage=Texture'DHBritishCharactersTex.Icons.Brit_SMG'
     Models(0)="RMC1"
     Models(1)="RMC2"
     Models(2)="RMC3"
     Models(3)="RMC4"
     Models(4)="RMC5"
     Models(5)="RMC6"
     bIsGunner=true
     SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_BrenWeapon',Amount=6)
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_ColtM1911Weapon',Amount=1)
     Headgear(0)=Class'DH_BritishPlayers.DH_BritishTurtleHelmet'
     Headgear(1)=Class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
     Headgear(2)=Class'DH_BritishPlayers.DH_BritishRMCommandoBeret'
     bCarriesMGAmmo=false
     PrimaryWeaponType=WT_LMG
     Limit=3
}
