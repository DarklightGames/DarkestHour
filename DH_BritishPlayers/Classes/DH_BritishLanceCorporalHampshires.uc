//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BritishLanceCorporalHampshires extends DH_Hampshires;

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
     MyName="Lance Corporal"
     AltName="Lance Corporal"
     Article="a "
     PluralName="Lance Corporals"
     InfoText="The lance corporal is the NCO tasked to coordinate his team's movement in accordance with the squad's objective. As the direct assistant to the squad leader, he is expected to provide a comparable level of support to his men."
     MenuImage=Texture'DHBritishCharactersTex.Icons.Brit_LanceCorporal'
     Models(0)="Hamp_1"
     Models(1)="Hamp_2"
     Models(2)="Hamp_3"
     Models(3)="Hamp_4"
     Models(4)="Hamp_5"
     Models(5)="Hamp_6"
     SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
     PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_StenMkIIWeapon',Amount=6)
     PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_ThompsonWeapon',Amount=6)
     Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon',Amount=1)
     Grenades(1)=(Item=class'DH_Equipment.DH_USSmokeGrenadeWeapon',Amount=1)
     Headgear(0)=class'DH_BritishPlayers.DH_BritishTurtleHelmet'
     Headgear(1)=class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
     Headgear(2)=class'DH_BritishPlayers.DH_BritishTommyHelmet'
     Limit=2
}
