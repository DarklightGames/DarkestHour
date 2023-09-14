//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_IS2Cannon_Late extends DH_IS2Cannon;

defaultproperties
{
    PrimaryProjectileClass=class'DH_Vehicles.DH_IS2CannonShell_Late'

    ReloadStages(0)=(Sound=Sound'Vehicle_reloads.Reloads.Tiger_reload_01') //Historical Practical RoF - 4-5 rpm; Improved breech
    ReloadStages(1)=(Sound=Sound'Vehicle_reloads.Reloads.Tiger_reload_02')
    ReloadStages(2)=(Sound=Sound'Vehicle_reloads.Reloads.IS2_reload_03')
    ReloadStages(3)=(Sound=Sound'Vehicle_reloads.Reloads.Tiger_reload_04')

    ProjectileDescriptions(0)="APBC"
    nProjectileDescriptions(0)="BR-471B" // APBC round available from late '44
}
