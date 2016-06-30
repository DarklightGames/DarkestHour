//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ROSU_RKK_GreenTelogreikaRifleman extends DH_ROSU_RKK_GreenTelogreika;

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
    PrimaryWeapons(0)=(Item=class'DH_ROWeapons.DH_MN9130Weapon',Amount=15,AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_ROWeapons.DH_M38Weapon',Amount=15,AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    Grenades(0)=(Item=class'DH_ROWeapons.DH_F1GrenadeWeapon',Amount=2)
    Headgear(0)=class'DH_ROPlayers.DH_ROSovietSidecap'
    Headgear(1)=class'DH_ROPlayers.DH_ROSovietSidecap'
    Headgear(2)=class'DH_ROPlayers.DH_ROSovietSidecap'
    InfoText="The rifleman is the basic soldier of the battlefield that is tasked with the important role of capturing and holding objectives, as well as the defense of key positions. Armed with the standard-issue battle rifle, the rifleman’s efficiency is determined by his ability to work as a member of a larger unit."
    MenuImage=Texture'InterfaceArt_tex.SelectMenus.Strelok'
}
