//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Cromwell95mmCannonPawn extends DH_CromwellCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_Cromwell95mmCannon'
//  CannonScopeOverlay=texture'DH_VehicleOptics_tex.Allied.Cromwell95mm_sight_background' // TODO - make gunsight overlay for 95mm howitzer (see notes below)
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.JagdTiger_shell'                // TODO - make ammo icon for 95mm shell ('Cromwell95mmShell')
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.JagdTiger_shell_reload'   // TODO - make reload icon for 95mm shell ('Cromwell95mmShell_reload')
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Cromwell_anm.Cromwell95mm_turret_int')
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Cromwell_anm.Cromwell95mm_turret_int')
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Cromwell_anm.Cromwell95mm_turret_int')
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_Cromwell_anm.Cromwell95mm_turret_int')

//  Gunsight is British no.48 x3 Mk.I, used for 95mm howitzer mounted with Besa MG
//  Only one col, which is on the right side & indexed for Besa MG for 400, 800, 1200 & 1600 yards
//  No indexing for 95mm howitzer, simply a cross hair & some 'range posts' (?) as it was a relatively short ranged weapon
}
