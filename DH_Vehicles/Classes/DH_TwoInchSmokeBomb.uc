//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_TwoInchSmokeBomb extends DHSmokeLauncherProjectile; // white phosphorus smoke bomb for British 2 inch bomb thrower

defaultproperties
{
    bHasSmokeTrail=false // this is a 2-inch mortar shell Mk III which disperses smoke upon impact
    StaticMesh=StaticMesh'DH_Mortars_stc.M302_WP' //PLACEHOLDER
    DrawScale=1.0

    RotationRate=(Pitch=-5000)
    DesiredRotation=(Pitch=-3000) //30000

    MaxSpeed=1895.0 // lands approx 110 yards away
    Speed=1895.0
}
