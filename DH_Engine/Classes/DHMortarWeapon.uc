//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMortarWeapon extends DHWeapon
    abstract;

var     class<DHMortarVehicle>  VehicleClass;

// Deploying
var     bool    bDeploying;
var     name    DeployAnimation;
var     float   DeployRadius;
var     float   DeployAngleMaximum;

// Ammo
var     int     HighExplosiveMaximum;
var     int     HighExplosiveResupplyCount;
var     int     SmokeMaximum;
var     int     SmokeResupplyCount;

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerDeployEnd;
}

simulated function bool HasAmmo()
{
    return true;
}

simulated function bool WeaponCanSwitch()
{
    //-------------------------------------------------
    //No weapon switching, these  things are too heavy.
    return false;
}

simulated function bool WeaponAllowCrouchChange()
{
    //-------------------------------------------------
    //Not if we're deploying, homie.
    if (bDeploying)
    {
        return false;
    }

    return super.WeaponAllowCrouchChange();
}

simulated function bool WeaponAllowProneChange()
{
    //---------------------------------------------------
    //You won't be dragging these things through the mud.
    return false;
}

simulated function bool WeaponAllowMantle()
{
    //--------------------------------------------------------------------
    //You can barely get yourself over the wall let alone this thing, too.
    return false;
}

simulated event AnimEnd(int Channel)
{
    local DHPawn P;

    P = DHPawn(Instigator);

    //-----------------------------------------------------------------------
    //If the deploy animation ended, then let's let the server know about it.
    if (bDeploying)
    {
        P.bIsDeployingMortar = false;
        P.SetLockViewRotation(false);

        ServerDeployEnd();
    }
}

simulated function Fire(float F) { return; }
simulated function AltFire(float F) { return; }
simulated function bool WeaponAllowSprint() { return false; }
simulated function ROIronSights() { return; }
simulated event ClientStartFire(int Mode) { return; }
simulated event StopFire(int Mode) { return; }
simulated exec function ROManualReload() { return; }

simulated exec function Deploy()
{
    if (!bDeploying)
    {
        ClientDeploy();
    }
}

//------------------------------
//Client side attempt to deploy.
simulated function ClientDeploy()
{
    local DHPawn P;
    local rotator R;

    P = DHPawn(Instigator);

    if (IsBusy() || !CanDeploy() || P == none)
    {
        return;
    }

    PlayAnim(DeployAnimation);
    bDeploying = true;

    //-------------------------------------------------
    //This is so the pawn knows to limit pitch and yaw.
    R = P.Rotation;
    R.Pitch = 0;

    P.bIsDeployingMortar = true;
    P.SetLockViewRotation(true, R);
}

function ServerDeployEnd()
{
    local DHMortarVehicle V;
    local vector HitLocation, HitNormal, TraceEnd, TraceStart;
    local rotator SpawnRotation;
    local DHPawn P;

    P = DHPawn(Instigator);

    TraceStart = P.Location + vect(0.0, 0.0, 1.0) * P.CollisionHeight;
    TraceEnd = TraceStart + vect(0.0, 0.0, -128.0);

    SpawnRotation = P.Rotation;
    SpawnRotation.Pitch = 0;
    SpawnRotation.Roll = 0;

    if (Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true) == none)
    {
        GotoState('Idle');

        return;
    }

    V = Spawn(VehicleClass, Instigator,, HitLocation, SpawnRotation);
    V.SetTeamNum(VehicleClass.default.VehicleTeam);
    V.TryToDrive(P);

    Destroy();
}

simulated function bool CanDeploy()
{
    local DHPawn P;
    local Actor HitActor;
    local vector HitLocation, HitNormal, TraceEnd, TraceStart;
    local Material Material;
    local rotator TraceRotation;
    local DHVolumeTest VolumeTest;

    P = DHPawn(Instigator);

    VolumeTest = Spawn(class'DHVolumeTest',,, P.Location);

    if (VolumeTest.IsInNoArtyVolume())
    {
        Instigator.ReceiveLocalizedMessage(class'DHMortarMessage', 11);
        VolumeTest.Destroy();
        return false;
    }

    VolumeTest.Destroy();

    //-----------------------------
    //If we're busy, don't bother.  Check 'RaisingWeapon' state.  Before this,
    //not checking this state was allowing the player to almost instantaneously
    //redeploy a mortar after undeploying.
    if (IsBusy() || IsInState('RaisingWeapon'))
    {
        return false;
    }

    //-----------------------------
    //Check that we're not in water
    if (Instigator.PhysicsVolume.bWaterVolume || Instigator.PhysicsVolume.bPainCausing)
    {
        Instigator.ReceiveLocalizedMessage(class'DHMortarMessage', 7);
        return false;
    }

    //---------------------------
    //Check that we're crouching.
    if (!P.bIsCrouched)
    {
        Instigator.ReceiveLocalizedMessage(class'DHMortarMessage', 1);
        return false;
    }

    //---------------------------
    //Check that we're not moving
    if (P.Velocity != vect(0.0, 0.0, 0.0))
    {
        Instigator.ReceiveLocalizedMessage(class'DHMortarMessage', 3);
        return false;
    }

    //----------------------------
    //Check that we're not leaning
    if (P.bLeaningLeft || P.bLeaningRight)
    {
        Instigator.ReceiveLocalizedMessage(class'DHMortarMessage', 6);
        return false;
    }

    //-------------------------------------------------------
    //Trace straight downwards and see what we're standing on
    TraceStart = P.Location;
    TraceEnd = TraceStart - vect(0.0, 0.0, 128.0);

    HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true,, Material);

    //----------------------------------------------
    //Check that our surface exists and it is static
    if (HitActor == none || !HitActor.bStatic)
    {
        Instigator.ReceiveLocalizedMessage(class'DHMortarMessage', 4);
        return false;
    }

    //------------------------------------------------------------------
    //Check that the surface angle is less than our deploy angle maximum
    if (Acos(HitNormal dot vect(0.0, 0.0, 1.0)) > DeployAngleMaximum)
    {
        Instigator.ReceiveLocalizedMessage(class'DHMortarMessage', 4);
        return false;
    }

    //-----------------------
    //Now check all around us
    for (TraceRotation.Yaw = 0; TraceRotation.Yaw < 65535; TraceRotation.Yaw += 8192)
    {
        //----------------------------------
        //Trace outwards along the X/Y plane
        TraceEnd = P.Location + vector(TraceRotation) * DeployRadius;

        HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true);

        //-----------------------------------------------------------
        //Check that we haven't hit anything static along this trace.
        if (HitActor != none && HitActor.bStatic)
        {
            //--------------------------
            //Not enough toom to deploy.
            Instigator.ReceiveLocalizedMessage(class'DHMortarMessage', 5);
            return false;
        }

        //-----------------------------------------------------------
        //Now trace downwards from the end point of our previous trace
        TraceStart = TraceEnd;
        TraceEnd = TraceStart - (vect(0.0, 0.0, 128.0));

        HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true);

        //----------------------------------------------
        //Check that our surface exists and it is static
        if (HitActor == none || !HitActor.bStatic)
        {
            //------------------------------
            //Cannot deploy on this surface.
            Instigator.ReceiveLocalizedMessage(class'DHMortarMessage', 4);
            return false;
        }
        //------------------------------------------------------------------
        //Check that the surface angle is less than our deploy angle maximum
        if (Acos(HitNormal dot vect(0.0, 0.0, 1.0)) > DeployAngleMaximum)
        {
            //------------------------------
            //Cannot deploy on this surface.
            Instigator.ReceiveLocalizedMessage(class'DHMortarMessage', 4);
            return false;
        }
    }

    return true;
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    if (DHPlayer(Instigator.Controller) != none)
    {
        DHPlayer(Instigator.Controller).QueueHint(6, false);
    }
}

function bool ResupplyAmmo()
{
    local DHPawn P;

    P = DHPawn(Instigator);

    if (P == none)
    {
        return false;
    }

    return P.ResupplyMortarAmmunition();
}

function bool FillAmmo()
{
    local DHPawn P;
    local bool bReturn;

    P = DHPawn(Instigator);

    if (P != none)
    {


        if (P.MortarHEAmmo < HighExplosiveMaximum)
        {
            P.MortarHEAmmo = HighExplosiveMaximum;
            bReturn = true;
        }

        if (P.MortarSmokeAmmo < SmokeMaximum)
        {
            P.MortarSmokeAmmo = SmokeMaximum;
            bReturn = true;
        }
    }

    return bReturn;
}

defaultproperties
{
    SelectAnim="Draw"
    PutDownAnim="putaway"
    DeployAnimation="Deploy"
    DeployRadius=32.0
    DeployAngleMaximum=0.349066
    FireModeClass(0)=class'DH_Engine.DHMortarWeaponFire'
    FireModeClass(1)=class'DH_Engine.DHMortarWeaponFire'
    AIRating=1.0
    CurrentRating=1.0
    bCanThrow=false
    bCanSway=false
    InventoryGroup=9
    BobDamping=1.6
}
