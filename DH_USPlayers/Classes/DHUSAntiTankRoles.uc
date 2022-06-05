//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHUSAntiTankRoles extends DHAlliedAntiTankRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M1GarandWeapon')
    Grenades(0)=(Item=class'DH_Equipment.DH_USSmokeGrenadeWeapon')
    GivenItems(0)="DH_Weapons.DH_BazookaWeapon"
    VoiceType="DH_USPlayers.DHUSVoice"
    AltVoiceType="DH_USPlayers.DHUSVoice"
    SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
    GlovedHandTexture=Texture'DHUSCharactersTex.Gear.hands_USgloves'
    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.8
}
