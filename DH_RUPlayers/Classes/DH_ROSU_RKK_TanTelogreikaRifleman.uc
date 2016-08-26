//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ROSU_RKK_TanTelogreikaRifleman extends DH_ROSU_RKK_TanTelogreika;

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
    MyName="Rifleman"
    AltName="Strelok"
    Article="a "
    PluralName="Riflemen"
    PrimaryWeaponType=WT_Rifle
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MN9130Weapon',Amount=15,AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_M38Weapon',Amount=15,AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_F1GrenadeWeapon',Amount=2)
    Headgear(0)=class'DH_RUPlayers.DH_ROSovietSidecap'
    Headgear(1)=class'DH_RUPlayers.DH_ROSovietSidecap'
    Headgear(2)=class'DH_RUPlayers.DH_ROSovietSidecap'
    }
