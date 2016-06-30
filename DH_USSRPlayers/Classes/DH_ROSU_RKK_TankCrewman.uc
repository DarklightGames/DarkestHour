//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ROSU_RKK_TankCrewman extends DH_ROSU_RKK;

defaultproperties
{
    MyName="Tank Crewman"
    AltName="Ekipazh tanka"
    Article="a "
    PluralName="Tank Crewmen"
    InfoText="The tank crewman is a composite role tasked with a variety of operations including gunner, hull gunner and driver. each position has a specific view sector out of the tank and is responsible for keeping watch and reporting enemy movements in that direction, as well as performing their primary function."
    menuImage=Texture'InterfaceArt_tex.SelectMenus.Ekipazhtanka'
    SleeveTexture=Texture'Weapons1st_tex.Arms.RussianTankerSleeves'
    DetachedArmClass=Class'ROEffects.SeveredArmSovTanker'
    DetachedLegClass=class'ROEffects.SeveredLegSovTanker'
    SecondaryWeapons(0)=(Item=class'DH_ROWeapons.DH_TT33Weapon',Amount=1)
    Headgear(0)=class'ROInventory.ROSovietTankerHat'
    RolePawnClass="DH_ROPlayers.DH_RUTankerPawn"
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=True
    bCanBeTankCrew=True
    limit=3
}
