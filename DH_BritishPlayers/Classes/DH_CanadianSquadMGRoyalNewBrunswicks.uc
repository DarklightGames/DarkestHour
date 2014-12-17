//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_CanadianSquadMGRoyalNewBrunswicks extends DH_RoyalNewBrunswicks;

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
    MenuImage=texture'DHCanadianCharactersTex.Icons.Can_SMG'
    Models(0)="RNB_1"
    Models(1)="RNB_2"
    Models(2)="RNB_3"
    Models(3)="RNB_4"
    Models(4)="RNB_5"
    Models(5)="RNB_6"
    bIsGunner=true
    SleeveTexture=texture'DHCanadianCharactersTex.Sleeves.CanadianSleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_BrenWeapon',Amount=6)
    Headgear(0)=class'DH_BritishPlayers.DH_BritishTurtleHelmet'
    Headgear(1)=class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
    Headgear(2)=class'DH_BritishPlayers.DH_BritishTommyHelmet'
    bCarriesMGAmmo=false
    PrimaryWeaponType=WT_LMG
    Limit=3
}
