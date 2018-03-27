//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHVehicleExplosionDamageType extends DHDamageType;

defaultproperties
{
    DeathString="%k took out %o with a vehicle explosion."
    MaleSuicide="%o was a little too close to the vehicle he blew up."
    FemaleSuicide="%o was a little too close to the vehicle she blew up."

    HUDIcon=Texture'InterfaceArt_tex.deathicons.artkill'

    GibModifier=6.0

    bDetonatesGoop=true
    VehicleMomentumScaling=1.3
    bThrowRagdoll=true
    GibPerterbation=0.15
    bFlaming=true
    bDelayedDamage=true
    bLocationalHit=false
    KDamageImpulse=3000
    KDeathVel=150
    KDeathUpKick=50
    bExtraMomentumZ=true

    DeathOverlayMaterial=Material'Effects_Tex.PlayerDeathOverlay'
    DeathOverlayTime=999
}
