//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_MortarWeapon extends DHWeapon
    abstract;

replication
{
    reliable if (Role < ROLE_Authority)
        ServerDeployEnd, ServerDeployBegin;
}

var bool bDeploying;

//---------------
//Animation names
var name DeployAnimation;

//-----------------
//Deploy attributes
var() float DeployRadius;
var() float DeployAngleMaximum;

var() class<DH_MortarVehicle> VehicleClass;

var int HighExplosiveMaximum;
var int HighExplosiveResupplyCount;
var int SmokeMaximum;
var int SmokeResupplyCount;

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
        return false;

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
    //-----------------------------------------------------------------------
    //If the deploy animation ended, then let's let the server know about it.
    if (bDeploying)
    {
        DH_Pawn(Instigator).bDeployingMortar = false;
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
        ClientDeploy();
}

//------------------------------
//Client side attempt to deploy.
simulated function ClientDeploy()
{
    local DH_Pawn P;

    P = DH_Pawn(Instigator);

    if (IsBusy() || !CanDeploy() || P == none)
        return;

    PlayAnim(DeployAnimation);
    bDeploying = true;

    //-------------------------------------------------
    //This is so the pawn knows to limit pitch and yaw.
    P.bDeployingMortar = true;
    P.MortarDeployYaw = P.Rotation.Yaw;

    //--------------------
    //Let's start
    ServerDeployBegin();
}

simulated function ServerDeployBegin()
{
    //TODO: Test that we'll be able to get off of this.
}

simulated function ServerDeployEnd()
{
    local DH_MortarVehicle V;
    local vector HitLocation, HitNormal, TraceEnd, TraceStart;
    local rotator SpawnRotation;
    local DH_Pawn P;

    P = DH_Pawn(Instigator);

    TraceStart = P.Location + vect(0, 0, 1) * P.CollisionHeight;
    TraceEnd = TraceStart + vect(0, 0, -128);

    SpawnRotation = P.Rotation;
    SpawnRotation.Pitch = 0;
    SpawnRotation.Roll = 0;

    if (Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true) == none)
    {
        GotoState('Idle');

        return;
    }

    V = Spawn(VehicleClass, Instigator,, HitLocation, SpawnRotation);
    V.TryToDrive(P);

    Destroy();
}

simulated function bool CanDeploy()
{
    local DH_Pawn P;
    local Actor HitActor;
    local vector HitLocation, HitNormal, TraceEnd, TraceStart;
    local Material Material;
    local rotator TraceRotation;
    local ROVolumeTest VolumeTest;

    P = DH_Pawn(Instigator);

    VolumeTest = Spawn(class'ROVolumeTest',, , P.Location);

    if (VolumeTest.IsInNoArtyVolume())
    {
        Instigator.ReceiveLocalizedMessage(class'DH_MortarMessage', 11);
        VolumeTest.Destroy();
        return false;
    }

    VolumeTest.Destroy();

    //-----------------------------
    //If we're busy, don't bother.  Check 'RaisingWeapon' state.  Before this,
    //not checking this state was allowing the player to almost instantaneously
    //redeploy a mortar after undeploying.
    if (IsBusy() || IsInState('RaisingWeapon'))
        return false;

    //-----------------------------
    //Check that we're not in water
    if (Instigator.PhysicsVolume.bWaterVolume)
    {
        Instigator.ReceiveLocalizedMessage(class'DH_MortarMessage', 7);
        return false;
    }

    //---------------------------
    //Check that we're crouching.
    if (!P.bIsCrouched)
    {
        Instigator.ReceiveLocalizedMessage(class'DH_MortarMessage', 1);
        return false;
    }

    //---------------------------
    //Check that we're not moving
    if (P.Velocity != vect(0, 0, 0))
    {
        Instigator.ReceiveLocalizedMessage(class'DH_MortarMessage', 3);
        return false;
    }

    //----------------------------
    //Check that we're not leaning
    if (P.bLeaningLeft || P.bLeaningRight)
    {
        Instigator.ReceiveLocalizedMessage(class'DH_MortarMessage', 6);
        return false;
    }

    //-------------------------------------------------------
    //Trace straight downwards and see what we're standing on
    TraceStart = P.Location;
    TraceEnd = TraceStart - vect(0, 0, 128);

    HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true,, Material);

    //----------------------------------------------
    //Check that our surface exists and it is static
    if (HitActor == none || !HitActor.bStatic)
    {
        Instigator.ReceiveLocalizedMessage(class'DH_MortarMessage', 4);
        return false;
    }

    //------------------------------------------------------------------
    //Check that the surface angle is less than our deploy angle maximum
    if (Acos(HitNormal dot vect(0, 0, 1)) > DeployAngleMaximum)
    {
        Instigator.ReceiveLocalizedMessage(class'DH_MortarMessage', 4);
        return false;
    }

    //-----------------------
    //Now check all around us
    for(TraceRotation.Yaw = 0; TraceRotation.Yaw < 65535; TraceRotation.Yaw += 8192)
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
            Instigator.ReceiveLocalizedMessage(class'DH_MortarMessage', 5);
            return false;
        }

        //-----------------------------------------------------------
        //Now trace downards from the end point of our previous trace
        TraceStart = TraceEnd;
        TraceEnd = TraceStart - (vect(0, 0, 128));

        HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true);

        //----------------------------------------------
        //Check that our surface exists and it is static
        if (HitActor == none || !HitActor.bStatic)
        {
            //------------------------------
            //Cannot deploy on this surface.
            Instigator.ReceiveLocalizedMessage(class'DH_MortarMessage', 4);
            return false;
        }
        //------------------------------------------------------------------
        //Check that the surface angle is less than our deploy angle maximum
        if (Acos(HitNormal dot vect(0, 0, 1)) > DeployAngleMaximum)
        {
            //------------------------------
            //Cannot deploy on this surface.
            Instigator.ReceiveLocalizedMessage(class'DH_MortarMessage', 4);
            return false;
        }
    }

    return true;
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    if (DHPlayer(Instigator.Controller) != none)
        DHPlayer(Instigator.Controller).QueueHint(6, false);
}

simulated function bool IsMortarWeapon()
{
    return true;
}

function bool ResupplyAmmo()
{
    local DH_Pawn P;

    P = DH_Pawn(Instigator);

    if (P == none)
        return false;

    return P.ResupplyMortarAmmunition();
}

function bool FillAmmo()
{
    //------------------------------------------------
    //Give the ammunition to the pawn, not the weapon.
    DH_Pawn(Instigator).MortarHEAmmo = HighExplosiveMaximum;
    DH_Pawn(Instigator).MortarSmokeAmmo = SmokeMaximum;

    return true;
}

defaultproperties
{
     DeployRadius=32.000000
     DeployAngleMaximum=0.349066
     FireModeClass(0)=class'DH_Mortars.DH_MortarWeaponFire'
     FireModeClass(1)=class'DH_Mortars.DH_MortarWeaponFire'
     AIRating=1.000000
     CurrentRating=1.000000
     bCanThrow=false
     bCanSway=false
     InventoryGroup=9
     BobDamping=1.600000
}
