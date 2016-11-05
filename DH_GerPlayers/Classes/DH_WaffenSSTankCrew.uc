//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WaffenSSTankCrew extends DH_German_Units
    abstract;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_GermanTankCrewSSPawn',Weight=1.0)
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
    DetachedArmClass=class'ROEffects.SeveredArmGerTanker'
    DetachedLegClass=class'ROEffects.SeveredLegGerTanker'
    MyName="Tank Crewman"
    AltName="Panzerbesatzung"
    Article="a "
    PluralName="Tank Crewmen"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_C96Weapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItem"
    Headgear(0)=class'DH_GerPlayers.DH_WSSHatPanzerA'
    Headgear(1)=class'DH_GerPlayers.DH_WSSHatPanzerB'
    bCanBeTankCrew=true
    Limit=3
}
