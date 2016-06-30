//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ROSU_RKK_StandardAssault extends DH_ROSU_RKK_Standard;

function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.2)
        return Headgear[1];
    else
        return Headgear[0];
}

defaultproperties
{
    MyName="Assault Trooper"
    AltName="Avtomatchik"
    Article="an "
    PluralName="Assault Troops"
    PrimaryWeaponType=WT_Assault
    PrimaryWeapons(0)=(Item=class'DH_ROWeapons.DH_PPSH41Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    Grenades(0)=(Item=class'DH_ROWeapons.DH_F1GrenadeWeapon',Amount=2)
    Headgear(0)=class'DH_ROPlayers.DH_ROSovietHelmet'
    Headgear(1)=class'DH_ROPlayers.DH_ROSovietHelmet'
    Headgear(2)=class'DH_ROPlayers.DH_ROSovietHelmet'
    InfoText="The assault trooper is a specialized infantry class who is tasked with closing with the enemy and eliminating him from difficult positions such as houses and fortifications.  The assault trooper is generally better armed than most infantrymen."
    bEnhancedAutomaticControl=true
    MenuImage=Texture'InterfaceArt_tex.SelectMenus.Avtomatchik'
    limit=3
}
