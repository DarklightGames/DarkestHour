//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ROSU_RKK_StandardAntiTank extends DH_ROSU_RKK_Standard;

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
    MyName="Anti-tank soldier"
    AltName="PT-Soldat"
    Article="an "
    PluralName="Anti-tank soldiers"
    PrimaryWeaponType=WT_Rifle
    PrimaryWeapons(0)=(Item=class'DH_ROWeapons.DH_M38Weapon',Amount=15,AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_ROWeapons.DH_TT33Weapon',Amount=1)
    Grenades(0)=(Item=class'DH_ROWeapons.DH_RPG43GrenadeWeapon',Amount=3)
    Headgear(0)=class'DH_ROPlayers.DH_ROSovietSidecap'
    Headgear(1)=class'DH_ROPlayers.DH_ROSovietSidecap'
    Headgear(2)=class'DH_ROPlayers.DH_ROSovietHelmet'
    InfoText="Late war anti-tank soldiers were equipped with anti-tank grenades: shaped-charge HEAT warheads that explode on impact.  Because range is limited to within throwing distance, an anti-tank soldier must get dangerously close to the enemy to be effective."
    bEnhancedAutomaticControl=false
    MenuImage=texture'InterfaceArt_tex.SelectMenus.PT-soldat'
    bIsGunner=True
    limit=2
}
