//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_RKKA_TankCrewman extends DH_Soviet_Units;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietTankCrewPawn',Weight=1.0)
    MyName="Tank Crewman"
    AltName="Ekipazh tanka"
    Article="a "
    PluralName="Tank Crewmen"
    SleeveTexture=texture'Weapons1st_tex.Arms.RussianTankerSleeves'
    DetachedArmClass=class'ROEffects.SeveredArmSovTanker'
    DetachedLegClass=class'ROEffects.SeveredLegSovTanker'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_PPSH41Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_TT33Weapon',Amount=1)
    GivenItems(0)="DH_Equipment.DHBinocularsItem"
    Headgear(0)=class'ROInventory.ROSovietTankerHat'
    bCanBeTankCrew=true
    bCanBeTankCommander=true
    Limit=1
}
