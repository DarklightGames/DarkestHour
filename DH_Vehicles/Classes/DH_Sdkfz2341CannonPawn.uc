//==============================================================================
// DH_Sdkfz2341CannonPawn
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// Sdkfz 234/1 German Armored Reconnaisance Car
//==============================================================================
class DH_Sdkfz2341CannonPawn extends DH_GermanTankCannonPawn;

var   bool    bMustBeReconCrew;

replication
{

    // Red Orchestra replication
	reliable if (bNetInitial && Role==ROLE_Authority)
		bMustBeReconCrew;
}

simulated exec function SwitchFireMode()
{
	if (Gun != none && ROTankCannon(Gun) != none && ROTankCannon(Gun).bMultipleRoundTypes)
	{
		if (Controller != none && ROPlayer(Controller) != none)
			ROPlayer(Controller).ClientPlaySound(sound'ROMenuSounds.msfxMouseClick',false,,SLOT_Interface);

		ServerToggleExtraRoundType();
	}
}

function bool ResupplyAmmo()
{
	local bool bResupplied;
	local DH_Sdkfz2341Cannon G;

	if (Gun == none)
		return false;

	G = DH_Sdkfz2341Cannon(Gun);

	if (G == none)
		return false;

	if (G.NumMags != G.default.NumMags || G.NumSecMags != G.default.NumSecMags || G.NumAltMags != G.default.NumAltMags)
	{
		G.NumMags = G.default.NumMags;
		G.NumSecMags = G.default.NumSecMags;
		G.NumAltMags = G.default.NumAltMags;

		bResupplied = true;
	}

	return bResupplied;
}

function bool KDriverLeave(bool bForceLeave)
{
    local bool bSuperDriverLeave;

	if (!bForceLeave && (DriverPositionIndex < UnbuttonedPositionIndex || Instigator.IsInState('ViewTransition')))
	{
	    Instigator.ReceiveLocalizedMessage(class'DH_VehicleMessage', 4);
        return false;
 	}
    else
    {
	    DriverPositionIndex=InitialPositionIndex;
	    bSuperDriverLeave = super(VehicleWeaponPawn).KDriverLeave(bForceLeave);

	    ROVehicle(GetVehicleBase()).MaybeDestroyVehicle();
	    return bSuperDriverLeave;
	}
}

function bool TryToDrive(Pawn P)
{

    local DH_RoleInfo DHRI;
    local DH_Pawn DHP;

    DHP = DH_Pawn(P);
    DHRI = DH_RoleInfo(DHPlayerReplicationInfo(P.PlayerReplicationInfo).RoleInfo);

    if (VehicleBase != none)
	{
		if (VehicleBase.NeedsFlip())
		{
			VehicleBase.Flip(vector(P.Rotation), 1);
			return false;
		}

		if (P.GetTeamNum() != Team)
		{
			if (VehicleBase.Driver == none)
				return VehicleBase.TryToDrive(P);

			VehicleLocked(P);
			return false;
		}
	}

    if (bMustBeReconCrew && !DHRI.bCanBeReconCrew && P.IsHumanControlled())
    {
        DenyEntry(P, 0);
        return false;
    }

	return Super.TryToDrive(P);
}

function DriverDied()
{
	DriverPositionIndex=InitialPositionIndex;
	super.DriverDied();
	ROVehicle(GetVehicleBase()).MaybeDestroyVehicle();

	// Kill the rotation sound if the driver dies but the vehicle doesnt
    if (GetVehicleBase().Health > 0)
		SetRotatingStatus(0);
}

// 1.0 = 0% reloaded, 0.0 = 100% reloaded (e.g. finished reloading)
function float getAmmoReloadState()
{
    local ROTankCannon cannon;

    cannon = ROTankCannon(gun);

    if (cannon == none)
        return 0.0;

    switch (cannon.CannonReloadState)
    {
        case CR_ReadyToFire:    return 0.00;
        case CR_Waiting:
        case CR_Empty:
        case CR_ReloadedPart1:  return 1.00;
        case CR_ReloadedPart2:  return 0.60;
        case CR_ReloadedPart3:  return 0.50;
        case CR_ReloadedPart4:  return 0.40;
    }

    return 0.0;
}

defaultproperties
{
     bMustBeReconCrew=true
     ScopeCenterScale=0.635000
     ScopeCenterRotator=TexRotator'DH_VehicleOptics_tex.German.20mmFlak_sight_center'
     CenterRotationFactor=2048
     OverlayCenterSize=0.733330
     UnbuttonedPositionIndex=1
     DestroyedScopeOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.PZ4_sight_destroyed'
     PoweredRotateSound=Sound'Vehicle_Weapons.Turret.manual_turret_traverse'
     PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
     PoweredRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_traverse'
     CannonScopeCenter=Texture'DH_VehicleOptics_tex.German.tiger_sight_graticule'
     ScopePositionX=0.237000
     ScopePositionY=0.150000
     BinocPositionIndex=2
     WeaponFov=30.000000
     AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag'
     AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag_reload'
     DriverPositions(0)=(ViewLocation=(X=40.000000,Y=12.000000,Z=3.000000),ViewFOV=30.000000,PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_turret_ext',TransitionUpAnim="com_open",DriverTransitionAnim="VSU76_com_close",ViewPitchUpLimit=12743,ViewPitchDownLimit=64443,bDrawOverlays=true)
     DriverPositions(1)=(ViewFOV=85.000000,PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="VSU76_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
     DriverPositions(2)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_turret_ext',ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
     bMustBeTankCrew=false
     FireImpulse=(X=-15000.000000)
     GunClass=Class'DH_Vehicles.DH_Sdkfz2341Cannon'
     bHasFireImpulse=false
     CameraBone="Gun"
     bPCRelativeFPRotation=true
     bFPNoZFromCameraPitch=true
     DrivePos=(X=4.000000,Y=-2.000000)
     DriveAnim="VSU76_com_idle_close"
     ExitPositions(0)=(Y=-100.000000,Z=160.000000)
     ExitPositions(1)=(Y=100.000000,Z=160.000000)
     EntryRadius=130.000000
     FPCamPos=(X=50.000000,Y=-30.000000,Z=11.000000)
     TPCamDistance=300.000000
     TPCamLookat=(X=-25.000000,Z=0.000000)
     TPCamWorldOffset=(Z=120.000000)
     VehiclePositionString="in a Sdkfz 234/1 Armored Car cannon"
     VehicleNameString="Sdkfz 234/1 Armored Car cannon"
     PitchUpLimit=6000
     PitchDownLimit=64000
     SoundVolume=130
}
