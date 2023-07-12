//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHCanisterShotDamageType extends DHLargeCaliberDamageType
    abstract;

defaultproperties
{
    HUDIcon=Texture'DH_InterfaceArt_tex.deathicons.canisterkill'
    DeathString="%o was filled with holes by %k's canister shot."
    MaleSuicide="%o was filled with holes by his own canister shot."
    FemaleSuicide="%o was filled with holes by her own canister shot."
    KDamageImpulse=2250.0
}
