//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USCorporal29thBeach extends DH_US_29th_Infantry;

function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.2)
    {
        return Headgear[0];
    }
    else
    {
        return Headgear[1];
    }
}

defaultproperties
{
    MyName="Corporal"
    AltName="Corporal"
    Article="a "
    PluralName="Corporals"
    InfoText="The corporal is the NCO tasked to coordinate his team's movement in accordance with the squad's objective. As the direct assistant to the squad leader, he is expected to provide a comparable level of support to his men."
    MenuImage=texture'DHUSCharactersTex.Icons.IconCorporal'
    Models(0)="US_29Inf1B"
    Models(1)="US_29Inf2B"
    Models(2)="US_29Inf3B"
    Models(3)="US_29Inf4B"
    Models(4)="US_29Inf5B"
    SleeveTexture=texture'DHUSCharactersTex.Sleeves.US_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M1GarandWeapon',Amount=6,AssociatedAttachment=class'DH_Weapons.DH_M1GarandAmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon',Amount=2)
    Grenades(1)=(Item=class'DH_Equipment.DH_USSmokeGrenadeWeapon',Amount=1)
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet29thEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet29thEMb'
    PrimaryWeaponType=WT_SemiAuto
    Limit=2
}
