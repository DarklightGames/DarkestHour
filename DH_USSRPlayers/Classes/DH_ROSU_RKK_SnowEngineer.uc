//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ROSU_RKK_SnowEngineer extends DH_ROSU_RKK_Snow;

function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.2)
    {
        return Headgear[1];
    }
    else
    {
        return Headgear[0];
    }
}

defaultproperties
{
    MyName="Combat Engineer"
    AltName="Saper"
    Article="a "
    PluralName="Combat Engineers"
    PrimaryWeaponType=WT_SMG
    PrimaryWeapons(0)=(Item=class'DH_ROWeapons.DH_M38Weapon',Amount=15,AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_ROWeapons.DH_M44Weapon',Amount=15,AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')
    Grenades(0)=(Item=class'DH_ROWeapons.DH_F1GrenadeWeapon',Amount=2)
    Grenades(1)=(Item=class'DH_ROWeapons.DH_RDG1GrenadeWeapon',Amount=1)
    GivenItems(0)="DH_Weapons.DH_SatchelCharge10lb10sWeapon"
    Headgear(0)=class'DH_ROPlayers.DH_ROSovietFurHat'
    Headgear(1)=class'DH_ROPlayers.DH_ROSovietFurHat'
    Headgear(2)=class'DH_ROPlayers.DH_ROSovietFurHat'
    InfoText="The combat engineer is tasked with destroying front-line enemy obstacles and fortifications.  Geared for close quarters combat, the combat engineer is generally equipped with submachine-guns and grenades.  for instances where enemy fortifications or obstacles are exposed to enemy fire, he is equipped with concealment smoke so he may get close enough to destroy the target."
    bEnhancedAutomaticControl=true
    MenuImage=Texture'InterfaceArt_tex.SelectMenus.Saper'
    limit=2
}
