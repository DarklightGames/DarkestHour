//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_USSergeant82nd extends DH_US_82nd_Airborne;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_USPlayers.DH_USAB82ndNCOPawn',Weight=1.0)
    MyName="Sergeant"
    AltName="Sergeant"
    Article="a "
    PluralName="Sergeants"
    bIsLeader=true
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_ThompsonWeapon',AssociatedAttachment=class'DH_Weapons.DH_ThompsonAmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_GreaseGunWeapon',AssociatedAttachment=class'DH_Weapons.DH_ThompsonAmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_ColtM1911Weapon')
    Grenades(0)=(Item=class'DH_Equipment.DH_USSmokeGrenadeWeapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_RedSmokeWeapon')
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet82ndNCOa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet82ndNCOb'
    Limit=2
}
