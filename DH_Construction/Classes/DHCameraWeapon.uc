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

delegate float FovInterpFunction(float T, float A, float B);

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    FovInterpFunction = class'UInterp'.static.Deceleration;
}

simulated function bool (int Mode)
{
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
    FovAngle = FovInterpFunction(DeltaTime * FovInterpStrength, FovAngle, FovAngleTarget);

    // TODO: set the player's FOV
    Instigator.Controller.FovAngle = FovAngle;
}

exec function SetFovZoomSpeed(float F)
{
    if (F == 0.0)
    {
        F = default.FovZoomSpeed;
    }

    FovZoomSpeed = F;
}

exec function SetFovInterpStrength(float F)
{
    if (F == 0.0)
    {
        F = default.FovInterpStrength;
    }

    FovInterpStrength = F;
}

exec function SetFovInterpFunction(string F)
{
    switch (Caps(F))
    {
        case "DECEL":
            FovInterpFunction = class'UInterp'.static.Deceleration;
            break;
        case "ACCEL":
            FovInterpFunction = class'UInterp'.static.Acceleration;
            break;
        case "SMOOTH":
            FovInterpFunction = class'UInterp'.static.SmoothStep;
            break;
        case "COSINE":
            FovInterpFunction = class'UInterp'.static.Cosine;
            break;
        case "LINEAR":
            FovInterpFunction = class'UInterp'.static.Linear;
            break;
        case "STEP":
            FovInterpFunction = class'UInterp'.static.Step;
            break;
        default:
            FovInterpFunction = class'UInterp'.static.Deceleration;
            break;
    }
}

defaultproperties
{
    FovInterpStrength=5.0
    FovAngleTarget=90.0
    FovAngle=90.0
    FovZoomSpeed=20.0
    ItemName="Camera"
    InventoryGroup=1
    PlayerViewOffset=(Z=1000000.0)
}
