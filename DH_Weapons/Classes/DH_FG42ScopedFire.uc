//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_FG42ScopedFire extends DH_FG42Fire;

defaultproperties
{
    FireIronAnim="iron_shoot_scoped"
    FireIronLoopAnim="iron_shoot_scoped"
    FireIronLastAnim="iron_shoot_last_scoped"

    //spread
    AddedPitch=13 //scope zero found experimentally with debugaddedpitch function, scope zeroed to 100m
    
    BipodDeployFireAnim="deploy_shoot_scoped"
    BipodDeployFireLoopAnim="deploy_shoot_scoped"
    BipodDeployFireLastAnim="deploy_shoot_last_scoped"
}
