//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_IS2Cannon_Late extends DH_IS2Cannon;

defaultproperties
{
    SecondaryProjectileClass=Class'DH_IS2CannonShell_Late'

    ReloadStages(0)=(Sound=Sound'Vehicle_reloads.Tiger_reload_01') //Historical Practical RoF - 4-5 rpm; Improved breech
    ReloadStages(1)=(Sound=Sound'Vehicle_reloads.Tiger_reload_02')
    ReloadStages(2)=(Sound=Sound'Vehicle_reloads.IS2_reload_03')
    ReloadStages(3)=(Sound=Sound'Vehicle_reloads.Tiger_reload_04')

    ProjectileDescriptions(1)="APBC"
    nProjectileDescriptions(1)="BR-471B" // APBC round available from late '44
}
