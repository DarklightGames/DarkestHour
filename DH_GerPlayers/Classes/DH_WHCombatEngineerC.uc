//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_WHCombatEngineerC extends DH_HeerCamo;

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
    MyName="Combat Engineer"
    AltName="Sturmpioniere"
    Article="a "
    PluralName="Combat Engineers"
    InfoText="The combat engineer is tasked with destroying front-line enemy obstacles and fortifications.  Geared for close quarters combat, the combat engineer is generally equipped with submachine-guns and grenades.  For instances where enemy fortifications or obstacles are exposed to enemy fire, he is equipped with concealment smoke so he may get close enough to destroy the target."
    MenuImage=Texture'InterfaceArt_tex.SelectMenus.Sturmpionier'
    Models(0)="WH_C1"
    Models(1)="WH_C2"
    Models(2)="WH_C3"
    Models(3)="WH_C4"
    Models(4)="WH_C5"
    Models(5)="WH_C6"
    SleeveTexture=Texture'Weapons1st_tex.Arms.german_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
    Grenades(1)=(Item=class'DH_Equipment.DH_NebelGranate39Weapon',Amount=1)
    GivenItems(0)="DH_Weapons.DH_SatchelCharge10lb10sWeapon"
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetOne'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetTwo'
    PrimaryWeaponType=WT_SMG
    Limit=1
}
