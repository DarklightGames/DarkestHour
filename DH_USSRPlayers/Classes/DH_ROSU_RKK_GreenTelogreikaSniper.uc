//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ROSU_RKK_GreenTelogreikaSniper extends DH_ROSU_RKK_GreenTelogreika;

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
    PrimaryWeapons(0)=(Item=class'DH_ROWeapons.DH_MN9130ScopedWeapon',Amount=15,AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_ROWeapons.DH_TT33Weapon',Amount=1)
    Headgear(0)=class'DH_ROPlayers.DH_ROSovietSidecap'
    Headgear(1)=class'DH_ROPlayers.DH_ROSovietSidecap'
    Headgear(2)=class'DH_ROPlayers.DH_ROSovietSidecap'
    InfoText="The sniper is tasked with the specialized goal of eliminating key hostile units and shaking enemy morale through careful marksmanship and fieldcraft.  Through patient observation, the sniper is also capable of providing valuable reconnaissance which can have a significant impact on the outcome of the battle."
    MenuImage=Texture'InterfaceArt_tex.SelectMenus.sniper'
    limit=1
}
