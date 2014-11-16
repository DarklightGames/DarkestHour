//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ProjectileFire extends ROWeaponFire;

//=============================================================================
// Variables
//=============================================================================

var()           int         ProjPerFire;                // How many projectiles are spawn each fire, set to 1
var()           vector      ProjSpawnOffset;            // +x forward, +y right, +z up
var()           vector      FAProjSpawnOffset;          // ProjSpawnOffset for free-aim mode +x forward, +y right, +z up

var(DH_ProjectileFire) int  AddedPitch;                 // Additional pitch to add to firing calculations. Primarily used for rockect launchers

var             bool        bUsePreLaunchTrace;         // Use the pre-projectile spawn trace to see if anything close is hit before launching projectile. Saves CPU and Net usuage
var             float       PreLaunchTraceDistance;     // How long of a pre launch trace to use. Shorter for SMGs and pistols, longer for rifles and MGs.

var             float       SnapTraceDistance;          // Essentially the distance before which no supersonic crack is heard from a bullet

// Tracer stuff
var()           bool        bUsesTracers;               // true if the weapon uses tracers in it's ammo loadout
var()           int         TracerFrequency;            // how often a tracer is loaded in.  Assume to be 1 in valueof(TracerFrequency)
var             byte        NextTracerCounter;
var() class<ROClientTracer> DummyTracerClass;           // class for the dummy offline only tracer for this weapon (does no damage)


// Weapon spread/innaccuracy variables
var             float       AppliedSpread;              // spread applied to the projectile
var()           float       CrouchSpreadModifier;       // Modifier applied when player is crouched
var()           float       ProneSpreadModifier;        // Modifier applied when player is prone
var()           float       BipodDeployedSpreadModifier;// Modifier applied when player is using a bipod deployed weapon
var()           float       RestDeploySpreadModifier;   // Modifier applied when players weapon is rest deployed
var()           float       HipSpreadModifier;          // Modifier applied when player is firing from the hip
var()           float       LeanSpreadModifier;         // Modifier applied when player is firing while leaning

var(FireAnims)  name        FireIronAnim;               // Firing animation for firing in ironsights
var(FireAnims)  name        FireIronLoopAnim;           // Looping Fire animation for firing in ironsights
var(FireAnims)  name        FireIronEndAnim;            // End anim for firing in ironsights

var             float       BlurTime;
var             float       BlurTimeIronsight;
var             float       BlurScale;
var             float       BlurScaleIronsight;

//=============================================================================
// functions
//=============================================================================

function float MaxRange()
{
    return 25000; // about 300 meters
}

function DoFireEffect()
{
    local vector StartProj, StartTrace, X,Y,Z;
    local Rotator R, Aim;
    local vector HitLocation, HitNormal;
    local Actor Other;
    local int projectileID;
    local int SpawnCount;
    local float theta;
    local coords MuzzlePosition;

    Instigator.MakeNoise(1.0);
    Weapon.GetViewAxes(X,Y,Z);

    //log("Projectile Firing, location of muzzle is "$Weapon.GetBoneCoords('Muzzle').Origin);
    //if (ROProjectileWeapon(Instigator.weapon) != none)
    //  log("MuzzleCoords location = "$ROProjectileWeapon(Instigator.weapon).GetMuzzleCoords().Origin);
    // if weapon in iron sights, spawn at eye position, otherwise spawn at muzzle tip
    // Temp commented out until we add the free-aim system in
    if (Instigator.Weapon.bUsingSights || Instigator.bBipodDeployed)
    {
        StartTrace = Instigator.Location + Instigator.EyePosition();
        StartProj = StartTrace + X * ProjSpawnOffset.X;

        // check if projectile would spawn through a wall and adjust start location accordingly
        Other = Trace(HitLocation, HitNormal, StartProj, StartTrace, false);
        if (Other != none)
        {
            StartProj = HitLocation;
        }
    }
    else
    {
        MuzzlePosition = Weapon.GetMuzzleCoords();

        // Get the muzzle position and scale it down 5 times (since the model is scaled up 5 times in the editor)
        StartTrace = MuzzlePosition.Origin - Weapon.Location;
        StartTrace = StartTrace * 0.2;
        StartTrace = Weapon.Location + StartTrace;

        //Spawn(class 'ROEngine.RODebugTracer',Instigator,,StartTrace,rotator(MuzzlePosition.XAxis));

        StartProj = StartTrace + MuzzlePosition.XAxis * FAProjSpawnOffset.X;

        //Spawn(class 'ROEngine.RODebugTracer',Instigator,,StartProj,rotator(MuzzlePosition.XAxis));

        Other = Trace(HitLocation, HitNormal, StartTrace, StartProj, true);// was false to only trace worldgeometry

        // Instead of just checking walls, lets check all actors. That way we won't have rounds
        // spawning on the other side of players and missing them altogether - Ramm 10/14/04
        if (Other != none)
        {
            StartProj = HitLocation;
        }
    }
    Aim = AdjustAim(StartProj, AimError);

    // for free-aim, just use where the muzzlebone is pointing
    if (!Instigator.Weapon.bUsingSights && !Instigator.bBipodDeployed && Instigator.Weapon.bUsesFreeAim
        && Instigator.IsHumanControlled())
    {
        Aim = rotator(MuzzlePosition.XAxis);
    }

    //log("Weapon fire Aim = "$Aim$" Startproj = "$Startproj);
    //PlayerController(Instigator.Controller).ClientMessage("Weapon fire Aim = "$Aim$" Startproj = "$Startproj);

//    Instigator.ClearStayingDebugLines();
//    Instigator.DrawStayingDebugLine(StartProj, StartProj+65535* MuzzlePosition.XAxis, 0,0,255);
//    Instigator.DrawStayingDebugLine(StartProj, StartProj+65535* vector(Aim), 0,255,0);

    SpawnCount = Max(1, ProjPerFire * int(Load));

    CalcSpreadModifiers();

    if ((DH_MGBase(Owner) != none) && DH_MGBase(Owner).bBarrelDamaged)
    {
        AppliedSpread = 4 * Spread;
    }
    else
    {
        AppliedSpread = Spread;
    }

    switch (SpreadStyle)
    {
        case SS_Random:
            X = vector(Aim);
            for (projectileID = 0; projectileID < SpawnCount; projectileID++)
            {
                R.Yaw = AppliedSpread * ((FRand()-0.5)/1.5);
                R.Pitch = AppliedSpread * (FRand()-0.5);
                R.Roll = AppliedSpread * (FRand()-0.5);
                SpawnProjectile(StartProj, Rotator(X >> R));
            }
            break;

        case SS_Line:
            for (projectileID = 0; projectileID < SpawnCount; projectileID++)
            {
                theta = AppliedSpread*PI/32768*(projectileID - float(SpawnCount-1)/2.0);
                X.X = Cos(theta);
                X.Y = Sin(theta);
                X.Z = 0.0;
                SpawnProjectile(StartProj, Rotator(X >> Aim));
            }
            break;

        default:
            SpawnProjectile(StartProj, Aim);
    }
}

function CalcSpreadModifiers()
{
    local float MovementPctModifier;
    local float PlayerSpeed;
    local ROPawn ROP;

    ROP = ROPawn(Instigator);

    if (ROP == none)
        return;

    PlayerSpeed = VSize(ROP.Velocity);

    /* Calc spread based on movement speed */
    MovementPctModifier = PlayerSpeed / ROP.default.GroundSpeed;
    Spread = default.Spread + default.Spread * MovementPctModifier;

    /* Reduce the spread if player is crouched and not moving */
    if (ROP.bIsCrouched && PlayerSpeed == 0)
    {
        Spread *= CrouchSpreadModifier;
    }
    else if (ROP.bIsCrawling)
    {
        Spread *= ProneSpreadModifier;
    }

    if (ROP.bRestingWeapon)
    {
        Spread *= RestDeploySpreadModifier;
    }

    // Make the spread crazy if your jumping
    if (Instigator.Physics == PHYS_Falling)
    {
        Spread *= 500;
    }

    if (!Instigator.Weapon.bUsingSights  && !Instigator.bBipodDeployed)
    {
        Spread *= HipSpreadModifier;
    }

    if (Instigator.bBipodDeployed)
    {
        Spread *= BipodDeployedSpreadModifier;
    }

    if (ROP.LeanAmount != 0)
    {
        Spread *= LeanSpreadModifier;
    }
}


/* =================================================================================== *
* SpawnProjectile()
*   Launches the projectile and tracers. Also performs a prelaunch trace to see if
*   we would hit something close before spawning a bullet. This way we don't ever
*   spawn a bullet if we would hit something so close that the ballistics wouldn't
*   matter anyway. Don't use pre-launch trace for things like rocket launchers
*
* modified by: Ramm 10/13/04
* =================================================================================== */
function projectile SpawnProjectile(vector Start, Rotator Dir)
{
    local Projectile spawnedprojectile;
    local vector ProjectileDir, End, HitLocation, HitNormal, SnapTraceEnd;
    local Actor Other;
    local ROPawn HitPawn;
    local DHWeaponAttachment WeapAttach;
    local array<int>    HitPoints;

     // do any additional pitch changes before launching the projectile
    Dir.Pitch += AddedPitch;

    // Perform prelaunch trace
    if (bUsePreLaunchTrace)
    {
        ProjectileDir = vector(Dir);
        End = Start + PreLaunchTraceDistance * ProjectileDir;
        SnapTraceEnd = Start + SnapTraceDistance * ProjectileDir;

        // Lets avoid all that casting
        WeapAttach =   DHWeaponAttachment(Weapon.ThirdPersonActor);

        // Do precision hit point pre-launch trace to see if we hit a player or something else
        Other = Instigator.HitPointTrace(HitLocation, HitNormal, End, HitPoints, Start,, 0);  // WhizType was 1, set to 0 to prevent sound triggering

        //Instigator.DrawStayingDebugLine(Start, End, 255,0,0);
        // This is a bit of a hack, but it prevents bots from killing other players in most instances
        if (!Instigator.IsHumanControlled() && Pawn(Other) != none && Instigator.Controller.SameTeamAs(Pawn(Other).Controller))
        {
            //log(Instigator$"'s shot would hit "$Other$" who is on the same team");
            return none;
        }

        if (Other != none && Other != Instigator && Other.Base != Instigator)
        {
            if (!Other.bWorldGeometry)
            {
                // Update hit effect except for pawns (blood) other than vehicles.
                if (Other.IsA('Vehicle') || (!Other.IsA('Pawn') && !Other.IsA('HitScanBlockingVolume') &&
                 !Other.IsA('ROVehicleWeapon')))
                {
                    WeapAttach.UpdateHit(Other, HitLocation, HitNormal);
                }

                if (Other.IsA('ROVehicleWeapon') && !ROVehicleWeapon(Other).HitDriverArea(HitLocation, ProjectileDir))
                {
                    WeapAttach.UpdateHit(Other, HitLocation, HitNormal);
                }

                if (Other.IsA('ROVehicle'))
                {
                    Other.TakeDamage(ProjectileClass.default.Damage, Instigator, HitLocation, ProjectileClass.default.MomentumTransfer*Normal(ProjectileDir),class<DH_Bullet>(ProjectileClass).default.MyVehicleDamage);
                }
                else
                {
                    HitPawn = DH_Pawn(Other);

                    if (HitPawn != none)
                    {
                        if (!HitPawn.bDeleteMe)
                            HitPawn.ProcessLocationalDamage(ProjectileClass.default.Damage, Instigator, HitLocation, ProjectileClass.default.MomentumTransfer*Normal(ProjectileDir),ProjectileClass.default.MyDamageType,HitPoints);
                    }
                    else
                    {
                        Other.TakeDamage(ProjectileClass.default.Damage, Instigator, HitLocation, ProjectileClass.default.MomentumTransfer*Normal(ProjectileDir),ProjectileClass.default.MyDamageType);
                    }
                }
            }
            else
            {
                if (WeapAttach != none)
                {
                    WeapAttach.UpdateHit(Other,HitLocation,HitNormal);
                }

                if (RODestroyableStaticMesh(Other) != none)
                {
                    Other.TakeDamage(ProjectileClass.default.Damage, Instigator, HitLocation, ProjectileClass.default.MomentumTransfer*Normal(ProjectileDir),ProjectileClass.default.MyDamageType);
                    if (RODestroyableStaticMesh(Other).bWontStopBullets)
                    {
                        Other = none;
                    }
                }
            }
        }

        // Return because we already hit something
        if (Other != none)
            return none;
    }

    if (ProjectileClass != none)
        spawnedprojectile = Spawn(ProjectileClass,,, Start, Dir);

    if (Level.NetMode == NM_Standalone && bUsesTracers && DummyTracerClass != none)
    {
        NextTracerCounter++;

        if (NextTracerCounter == TracerFrequency)
        {
                // If the person is looking at themselves in third person, spawn the tracer from the tip of the 3rd person weapon
                if (WeapAttach != none && !Instigator.IsFirstPerson())
                {
                    Other = WeapAttach.Trace(HitLocation, HitNormal, Start + vector(Dir) * 65525, Start, true);

                    if (Other != none)
                    {
                        Start = WeapAttach.GetBoneCoords(WeapAttach.MuzzleBoneName).Origin;
                        Dir = rotator(Normal(HitLocation - Start));
                    }
                }

                Spawn(DummyTracerClass,,, Start, Dir);
                NextTracerCounter = 0;          // reset for next tracer spawn
        }
    }

    if (spawnedprojectile == none)
        return none;

    return spawnedprojectile;
}

function PlayFiring()
{
    if (Weapon.Mesh != none)
    {
        if (FireCount > 0)
        {
            if (Weapon.bUsingSights && Weapon.HasAnim(FireIronLoopAnim))
            {
                Weapon.PlayAnim(FireIronLoopAnim, FireAnimRate, 0.0);
            }
            else
            {
                if (Weapon.HasAnim(FireLoopAnim))
                {
                    Weapon.PlayAnim(FireLoopAnim, FireLoopAnimRate, 0.0);
                }
                else
                {
                    Weapon.PlayAnim(FireAnim, FireAnimRate, FireTweenTime);
                }
            }
        }
        else
        {
            if (Weapon.bUsingSights)
            {
                Weapon.PlayAnim(FireIronAnim, FireAnimRate, FireTweenTime);
            }
            else
            {
                Weapon.PlayAnim(FireAnim, FireAnimRate, FireTweenTime);
            }
        }
    }

    if (FireSounds.Length > 0)
        Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)], SLOT_None, FireVolume,,,, false);

    ClientPlayForceFeedback(FireForce);

    FireCount++;
}

function PlayFireEnd()
{
    if (Weapon.bUsingSights && Weapon.HasAnim(FireIronEndAnim))
    {
        Weapon.PlayAnim(FireIronEndAnim, FireEndAnimRate, FireTweenTime);
    }
    else if (Weapon.HasAnim(FireEndAnim))
    {
        Weapon.PlayAnim(FireEndAnim, FireEndAnimRate, FireTweenTime);
    }
}

simulated function HandleRecoil()
{
    super.HandleRecoil();

    if (Level.NetMode != NM_DedicatedServer && Instigator != none && ROPlayer(Instigator.Controller) != none)
    {
        if (Weapon.bUsingSights)
        {
            ROPlayer(Instigator.Controller).AddBlur(BlurTimeIronsight, BlurScaleIronsight);
        }
        else
        {
            ROPlayer(Instigator.Controller).AddBlur(BlurTime, BlurScale);
        }
    }
}

defaultproperties
{
    ProjPerFire=1
    bUsePreLaunchTrace=true
    PreLaunchTraceDistance=2624.000000
    SnapTraceDistance=1200.000000
    CrouchSpreadModifier=0.850000
    ProneSpreadModifier=0.700000
    BipodDeployedSpreadModifier=0.500000
    RestDeploySpreadModifier=0.750000
    HipSpreadModifier=2.000000
    LeanSpreadModifier=1.350000
    PctBipodDeployRecoil=0.050000
    bLeadTarget=true
    bInstantHit=false
    NoAmmoSound=Sound'Inf_Weapons_Foley.Misc.dryfire_rifle'
    FireForce="AssaultRifleFire"
    WarnTargetPct=0.500000
    BlurTime=0.1
    BlurTimeIronsight=0.1
    BlurScale=0.01
    BlurScaleIronsight=0.1
}
