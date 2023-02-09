//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHUSTankCrewmanRoles extends DHAlliedTankCrewmanRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_GreaseGunWeapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_ColtM1911Weapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItemAllied"
    Headgear(0)=class'DH_USPlayers.DH_USTankerHat'
    VoiceType="DH_USPlayers.DHUSVoice"
    AltVoiceType="DH_USPlayers.DHUSVoice"
    SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
}
