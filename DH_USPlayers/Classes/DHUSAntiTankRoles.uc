//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHUSAntiTankRoles extends DHAlliedAntiTankRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M1CarbineWeapon',AssociatedAttachment=class'DH_Weapons.DH_M1CarbineAmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_M1GarandWeapon',AssociatedAttachment=class'DH_Weapons.DH_M1GarandAmmoPouch')
    Grenades(0)=(Item=class'DH_Equipment.DH_USSmokeGrenadeWeapon')
    GivenItems(0)="DH_Weapons.DH_BazookaWeapon"
    VoiceType="DH_USPlayers.DHUSVoice"
    AltVoiceType="DH_USPlayers.DHUSVoice"
    SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
    GlovedHandTexture=Texture'DHUSCharactersTex.Gear.hands_USgloves'
    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.8
}
