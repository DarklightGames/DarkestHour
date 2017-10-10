//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHCameraWeapon extends DHBinocularsItem;

var float FovAngleTarget;
var float FovAngle;
var float FovInterpStrength;
var float FovZoomSpeed;
var float FovZoomDirection;

simulated function bool (int Mode)
{
    Log("StartFire" @ Mode);

    switch (Mode)
    {
        case 0:
            FovZoomDirection = 1.0;
            break;
        case 1:
            FovZoomDirection = -1.0;
            break;
    }
}

simulated function bool WeaponLeanLeft()
{
    FovZoomDirection = -1.0;
    return true;
}

simulated function bool WeaponLeanRight()
{
    FovZoomDirection = 1.0;
    return true;
}

simulated function WeaponLeanLeftReleased()
{
    FovZoomDirection = 0.0;
}

simulated function WeaponLeanRightReleased()
{
    FovZoomDirection = 0.0;
}

simulated function ROIronSights()
{
    FovAngleTarget = default.FovAngleTarget;
}

simulated event WeaponTick(float DeltaTime)
{
    FovAngleTarget += (DeltaTime * FovZoomDirection * FovZoomSpeed);
    FovAngleTarget = FClamp(FovAngleTarget, 10.0, 120.0);
    FovAngle = class'UInterp'.static.Deceleration(DeltaTime * FovInterpStrength, FovAngle, FovAngleTarget);

    // TODO: set the player's FOV
    Instigator.Controller.FovAngle = FovAngle;
}

defaultproperties
{
    FovInterpStrength=5.0
    FovAngleTarget=90.0
    FovAngle=90.0
    FovZoomSpeed=20.0
    ItemName="Camera"
    InventoryGroup=1
}
