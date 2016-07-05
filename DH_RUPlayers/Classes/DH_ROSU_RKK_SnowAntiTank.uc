//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ROSU_RKK_SnowAntiTank extends DH_ROSU_RKK_Snow;

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
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M38Weapon',Amount=15,AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_TT33Weapon',Amount=1)
    Grenades(0)=(Item=class'DH_Weapons.DH_RPG43GrenadeWeapon',Amount=3)
    Headgear(0)=class'DH_RUPlayers.DH_ROSovietFurHat'
    Headgear(1)=class'DH_RUPlayers.DH_ROSovietFurHat'
    Headgear(2)=class'DH_RUPlayers.DH_ROSovietHelmet'
    bEnhancedAutomaticControl=false
    bIsGunner=true
    limit=2
}
