//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ROSU_RKK_SnowSniper extends DH_ROSU_RKK_Snow;

function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.2)
    {
        if (FRand() < 0.5)
        {
            return Headgear[2];
        }
        else
        {
            return Headgear[1];
        }
    }
    else
    {
        return Headgear[0];
    }
}

defaultproperties
{
    MyName="Sniper"
    AltName="Sniper"
    Article="a "
    PluralName="Snipers"
    PrimaryWeaponType=WT_Sniper
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MN9130ScopedWeapon',Amount=15,AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_TT33Weapon',Amount=1)
    Headgear(0)=class'DH_RUPlayers.DH_ROSovietFurHat'
    Headgear(1)=class'DH_RUPlayers.DH_ROSovietFurHat'
    Headgear(2)=class'DH_RUPlayers.DH_ROSovietFurHat'
    limit=1
}
