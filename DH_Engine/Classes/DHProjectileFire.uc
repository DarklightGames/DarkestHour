//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHProjectileFire extends ROWeaponFire;

// Projectile spawning & pre-launch trace
var     int             ProjPerFire;                 // how many projectiles are spawned each fire (normally 1)
var     vector          ProjSpawnOffset;             // positional offset to spawn projectile
var     vector          FAProjSpawnOffset;           // positional offset to spawn projectile for free-aim mode
var     int             AddedPitch;                  // additional pitch to add to firing calculations (primarily used for rocket launchers)
var     bool            bUsePreLaunchTrace;          // use pre-projectile spawn trace to see if we hit anything close before launching projectile (saves CPU and net usage)
var     float           PreLaunchTraceDistance;      // how long of a pre launch trace to use (shorter for SMGs and pistols, longer for rifles and MGs)

// Weapon spread/inaccuracy
var     float           AppliedSpread;               // spread applied to the projectile
var     float           CrouchSpreadModifier;        // modifier applied when player is crouched
var     float           ProneSpreadModifier;         // modifier applied when player is prone
var     float           BipodDeployedSpreadModifier; // modifier applied when player is using a bipod deployed weapon
var     float           RestDeploySpreadModifier;    // modifier applied when players weapon is rest deployed
var     float           HipSpreadModifier;           // modifier applied when player is firing from the hip
var     float           LeanSpreadModifier;          // modifier applied when player is firing while leaning

// Tracers
var     bool            bUsesTracers;                // true if the weapon uses tracers
var     int             TracerFrequency;             // how often a tracer is loaded in (as in, 1 in TracerFrequency)
var     byte            NextTracerCounter;           // count up shots fired, so we know when it's time to fire a tracer round
var class<Projectile>   TracerProjectileClass;       // class for the tracer bullet for this weapon (now a real bullet that does damage, as well as tracer effects)

// Ironsight animations
var     name            FireIronAnim;                // firing animation for firing in ironsights
var     name            FireIronLoopAnim;            // looping fire animation for firing in ironsights
var     name            FireIronEndAnim;             // end anim for firing in ironsights

// Screen blur when firing
var     bool            bShouldBlurOnFire;           // whether or not to add slight screen blur upon firing
var     float           BlurTime;                    // how long to blur when firing non-ironsighted
var     float           BlurTimeIronsight;           // how long to blur when firing ironsighted
var     float           BlurScale;                   // blur effect scale when firing non-ironsighted
var     float           BlurScaleIronsight;          // blur effect scale when firing ironsighted

function float MaxRange()
{
    return 25000.0; // about 415 meters
}

function DoFireEffect()
{
    local vector  StartProj, StartTrace, X,Y,Z;
    local Rotator R, Aim;
    local vector  HitLocation, HitNormal;
    local Actor   Other;
    local int     ProjectileID;
    local int     SpawnCount;
    local float   Theta;
    local coords  MuzzlePosition;

    if (Instigator != none)
    {
        Instigator.MakeNoise(1.0);
    }

    Weapon.GetViewAxes(X, Y, Z);

    // Check if projectile would spawn through something like a wall and adjust start location accordingly
    if (Instigator != none && (Instigator.Weapon.bUsingSights || Instigator.bBipodDeployed))
    {
        StartTrace = Instigator.Location + Instigator.EyePosition();
        StartProj = StartTrace + X * ProjSpawnOffset.X;

        Other = Trace(HitLocation, HitNormal, StartProj, StartTrace, false); // false means only trace world geometry
    }
    else
    {
        MuzzlePosition = Weapon.GetMuzzleCoords();
        StartTrace = MuzzlePosition.Origin - Weapon.Location;
        StartTrace = StartTrace * 0.2; // scale the muzzle position down 5 times, since the model is scaled up 5 times in the editor
        StartTrace = Weapon.Location + StartTrace;
        StartProj = StartTrace + MuzzlePosition.XAxis * FAProjSpawnOffset.X;

        Other = Trace(HitLocation, HitNormal, StartTrace, StartProj, true);
    }

    if (Other != none)
    {
        StartProj = HitLocation;
    }

    Aim = AdjustAim(StartProj, AimError);

    // For free-aim, just use where the muzzle bone is pointing
    if (Instigator != none && !Instigator.Weapon.bUsingSights && !Instigator.bBipodDeployed && Instigator.IsHumanControlled() && Instigator.Weapon.bUsesFreeAim)
    {
        Aim = rotator(MuzzlePosition.XAxis);
    }

    SpawnCount = Max(1, ProjPerFire * Int(Load));

    CalcSpreadModifiers();

    if (DHProjectileWeapon(Owner) != none && DHProjectileWeapon(Owner).bBarrelDamaged)
    {
        AppliedSpread = 4.0 * Spread;
    }
    else
    {
        AppliedSpread = Spread;
    }

    switch (SpreadStyle)
    {
        case SS_Random:

            X = vector(Aim);

            for (ProjectileID = 0; ProjectileID < SpawnCount; ++ProjectileID)
            {
                R.Yaw = AppliedSpread * ((FRand() - 0.5) / 1.5);
                R.Pitch = AppliedSpread * (FRand() - 0.5);
                R.Roll = AppliedSpread * (FRand() - 0.5);
                SpawnProjectile(StartProj, rotator(X >> R));
            }

            break;

        case SS_Line:

            for (ProjectileID = 0; ProjectileID < SpawnCount; ++ProjectileID)
            {
                Theta = AppliedSpread * PI / 32768.0 * (ProjectileID - Float(SpawnCount - 1) / 2.0);
                X.X = Cos(Theta);
                X.Y = Sin(Theta);
                X.Z = 0.0;
                SpawnProjectile(StartProj, rotator(X >> Aim));
            }

            break;

        default:
            SpawnProjectile(StartProj, Aim);
    }
}

function CalcSpreadModifiers()
{
    local ROPawn ROP;
    local float  PlayerSpeed, MovementPctModifier;

    ROP = ROPawn(Instigator);

    if (ROP == none)
    {
        return;
    }

    // Calc spread based on movement speed
    PlayerSpeed = VSize(ROP.Velocity);
    MovementPctModifier = PlayerSpeed / ROP.default.GroundSpeed;
    Spread = default.Spread + default.Spread * MovementPctModifier;

    // Reduce the spread if player is crouched and not moving
    if (ROP.bIsCrouched && PlayerSpeed == 0.0)
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

    // Make the spread crazy if you're jumping
    if (ROP.Physics == PHYS_Falling)
    {
        Spread *= 500.0;
    }

    if (!ROP.Weapon.bUsingSights && !ROP.bBipodDeployed)
    {
        Spread *= HipSpreadModifier;
    }

    if (ROP.bBipodDeployed)
    {
        Spread *= BipodDeployedSpreadModifier;
    }

    if (ROP.LeanAmount != 0.0)
    {
        Spread *= LeanSpreadModifier;
    }
}

// Launches/spawns a projectile, including option to do a pre-launch trace to see if we would hit something close before spawning a bullet
// If we do then we can avoid spawning the projectile if we'd hit something so close that the ballistics wouldn't matter anyway (don't use this for things like rocket launchers)
function Projectile SpawnProjectile(vector Start, rotator Dir)
{
    local Projectile         SpawnedProjectile;
    local ROWeaponAttachment WeapAttach;
    local Actor              Other;
    local vector             HitLocation, HitNormal;
    local bool               bPreLaunchTraceHitSomething;

    // Do any additional pitch changes before launching the projectile
    Dir.Pitch += AddedPitch;

    // Perform pre-launch trace (if enabled) & exit without spawning projectile if it hits something valid & handles damage & effects here
    // Matt: temporarily make Instigator use same bUseCollisionStaticMesh setting as projectile (normally means switching to true), meaning trace uses col meshes on vehicles
    if (bUsePreLaunchTrace && Instigator != none)
    {
        Instigator.bUseCollisionStaticMesh = ProjectileClass.default.bUseCollisionStaticMesh;
        bPreLaunchTraceHitSomething = PreLaunchTrace(Start, vector(Dir));
        Instigator.bUseCollisionStaticMesh = Instigator.default.bUseCollisionStaticMesh; // reset Instigator collision properties

        if (bPreLaunchTraceHitSomething)
        {
            return none;
        }
    }

    // Spawn a tracer projectile if one is due (but not on a net client if our weapon uses a DHHighROFWeaponAttachment, as that handles tracers independently on clients)
    if (bUsesTracers && (Level.NetMode == NM_Standalone || DHHighROFWeaponAttachment(Weapon.ThirdPersonActor) == none) && TracerProjectileClass != none)
    {
        NextTracerCounter++;

        if (NextTracerCounter >= TracerFrequency)
        {
            // If the person is looking at themselves in third person, spawn the tracer from the tip of the 3rd person weapon
            if (Instigator != none && !Instigator.IsFirstPerson())
            {
                WeapAttach = ROWeaponAttachment(Weapon.ThirdPersonActor);

                if (WeapAttach != none)
                {
                    Other = WeapAttach.Trace(HitLocation, HitNormal, Start + vector(Dir) * 65535.0, Start, true);

                    if (Other != none)
                    {
                        Start = WeapAttach.GetBoneCoords(WeapAttach.MuzzleBoneName).Origin;
                        Dir = rotator(Normal(HitLocation - Start));
                    }
                }
            }

            SpawnedProjectile = Spawn(TracerProjectileClass,,, Start, Dir);

            NextTracerCounter = 0; // reset for next tracer spawn
        }
    }

    // Spawn a normal projectile if we didn't spawn a tracer
    if (SpawnedProjectile == none && ProjectileClass != none)
    {
        SpawnedProjectile = Spawn(ProjectileClass,,, Start, Dir);
    }

    return SpawnedProjectile;
}

// New function to perform a pre-launch trace to see if we hit something fairly close, where ballistics aren't a factor & a simple trace will give an accurate hit result
// If we do hit something valid, we handle the damage & hit effects here, meaning we can avoid spawning the projectile (& replicating it on a server)
// We have to use our Instigator pawn to do traces, because we aren't an actor & so can't access trace functions
function bool PreLaunchTrace(vector Start, vector Direction)
{
    local Actor        Other, A;
    local array<Actor> SavedColMeshes;
    local ROPawn       HitPlayer;
    local vector       End, HitLocation, TempHitLocation, HitNormal, TempHitNormal, Momentum;
    local int          Damage, i;
    local array<int>   HitPoints;

    // Start with a special HitPointTrace to see if we hit a player pawn, including a vehicle occupant who won't have collision & so won't be caught by a normal Trace
    // HitPointTraces don't work well with short traces, so we have to do a long trace first, then check whether any player we hit was within PreLaunchTraceDistance
    End = Start + (65535.0 * Direction);

    // Maximum of 3 traces - but we only ever repeat the trace if we hit an invalid col mesh actor, which is very rare, so nearly always only 1 trace will be done
    for (i = 0; i < 3; ++i)
    {
        A = Instigator.HitPointTrace(HitLocation, HitNormal, End, HitPoints, Start,, 0); // WhizType 0 to prevent sound triggering, as it's close

        // We're primarily interested if we hit a player, but also need to check if hit an invalid collision mesh that doesn't stop bullets (as would need to repeat trace)
        if (ROPawn(A) != none || (DHCollisionMeshActor(A) != none && DHCollisionMeshActor(A).bWontStopBullet))
        {
            // Make sure hit actor is within trace range
            if (VSizeSquared(HitLocation - Start) <= (PreLaunchTraceDistance ** 2.0))
            {
                // We hit a player, so record it & limit length of confirmation trace that gets done next, as no point checking beyond the player
                if (ROPawn(A) != none)
                {
                    HitPlayer = ROPawn(A);
                    End = HitLocation;
                }
                // Otherwise, must have hit an invalid collision mesh, so we temporarily disable its collision & re-run the trace
                // Matt: this is a hack, but I can't think of another solution - the disabled collision is only for a split second & it seems harmless & effective
                else
                {
                    SavedColMeshes[SavedColMeshes.Length] = A; // save reference to col mesh so we can re-enable its collision after tracing
                    A.SetCollision(false, A.bBlockActors);
                    continue; // re-run the trace
                }
            }
        }

        break; // generally we're going to exit the for loop after the 1st pass, except in the rare event where we hit an invalid collision mesh
    }

    // Reset any temporarily disabled collision mesh collision as soon as we finish tracing
    for (i = 0; i < SavedColMeshes.Length; ++i)
    {
        SavedColMeshes[i].SetCollision(true, SavedColMeshes[i].bBlockActors);
    }

    // If didn't hit a player, set a standard length for normal trace that gets done next
    if (HitPlayer == none)
    {
        End = Start + (PreLaunchTraceDistance * Direction);
    }

    // Now do a normal trace to see if we hit another blocking actor 
    // Have to do this even if we have a HitPlayer, because HitPointTrace is unreliable & often passes through a blocking vehicle, hitting a shielded player
    foreach Instigator.TraceActors(class'Actor', A, TempHitLocation, TempHitNormal, End, Start)
    {
        // We hit a blocking actor, so now check if it's a valid 'stopper'
        if ((A.bBlockActors || A.bWorldGeometry) && A.bBlockHitPointTraces)
        {
            // If we hit a collision mesh actor, switch hit actor to col mesh's owner & proceed as if we'd hit that actor
            if (A.IsA('DHCollisionMeshActor'))
            {
                // But if col mesh doesn't stop bullets, we ignore it & continue the trace iteration
                if (DHCollisionMeshActor(A).bWontStopBullet)
                {
                    continue;
                }

                A = A.Owner;
            }

            // Register a hit on the blocking actor, providing it isn't anything ProcessTouch would normally ignore
            if (A != Instigator && A.Base != Instigator && A.Owner != Instigator && !A.bDeleteMe && (!A.IsA('Projectile') || A.bProjTarget) && A != HitPlayer)
            {
                Other = A;
                HitLocation = TempHitLocation;
                HitNormal = TempHitNormal;
                HitPlayer = none; // clear any hit that HitPointTrace registered on a player, as our blocking actor is in the way
                break;
            }
        }
    }

    // Hit nothing close, so return false & spawn projectile as normal
    if (Other == none && HitPlayer == none)
    {
        return false;
    }

    // We hit a destroyable static mesh actor, but it doesn't stop bullets, which complicates the trace as it ought to continue
    // This is a rare event, so simplest solution is to return false & spawn projectile as normal (it will smash the destro mesh & continue its flight)
    // (We could return PreLaunchTrace(HitLocation, Direction), to continue tracing from where we hit, but we'd have to build in a trace count to guard against a recursive loop)
    if (RODestroyableStaticMesh(Other) != none && RODestroyableStaticMesh(Other).bWontStopBullets)
    {
        return false;
    }

    // This is a bit of a hack, but it prevents bots from killing other players in most instances
    if (!Instigator.IsHumanControlled() && Pawn(Other) != none && Instigator.Controller.SameTeamAs(Pawn(Other).Controller))
    {
        return true;
    }

    // Update hit effect (not if we hit a player, as blood effects etc get handled in ProcessLocationalDamage/TakeDamage)
    if (HitPlayer == none && ROWeaponAttachment(Weapon.ThirdPersonActor) != none && (Other.bWorldGeometry || Other.IsA('Vehicle') || Other.IsA('VehicleWeapon')))
    {
        ROWeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other, HitLocation, HitNormal);
    }

    // Finally handle damage on whatever we've hit
    Damage = ProjectileClass.default.Damage;
    Momentum = ProjectileClass.default.MomentumTransfer * Direction;

    if (HitPlayer != none)
    {
        HitPlayer.ProcessLocationalDamage(Damage, Instigator, HitLocation, Momentum, ProjectileClass.default.MyDamageType, HitPoints);
    }
    else if (Other.IsA('ROVehicle') && class<ROBullet>(ProjectileClass) != none)
    {
        Other.TakeDamage(Damage, Instigator, HitLocation, Momentum, class<ROBullet>(ProjectileClass).default.MyVehicleDamage); // only difference is using special vehicle DamageType
    }
    else if (!Other.bWorldGeometry || Other.IsA('RODestroyableStaticMesh'))
    {
        Other.TakeDamage(Damage, Instigator, HitLocation, Momentum, ProjectileClass.default.MyDamageType);
    }

    return true;
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
    {
        Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)], SLOT_None, FireVolume,,,, false);
    }

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

    if (Level.NetMode != NM_DedicatedServer && default.bShouldBlurOnFire && Instigator != none && ROPlayer(Instigator.Controller) != none)
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
    bUsePreLaunchTrace=false // TEMP TEST (Matt: to see what difference it makes if we skip the PLT and let DHBullet handle things)
    PreLaunchTraceDistance=2624.0 // 43.5m
    CrouchSpreadModifier=0.85
    ProneSpreadModifier=0.7
    BipodDeployedSpreadModifier=0.5
    RestDeploySpreadModifier=0.75
    HipSpreadModifier=3.5
    LeanSpreadModifier=1.35
    PctBipodDeployRecoil=0.05
    bLeadTarget=true
    bInstantHit=false
    NoAmmoSound=sound'Inf_Weapons_Foley.Misc.dryfire_rifle'
    FireForce="AssaultRifleFire"
    WarnTargetPct=0.5
    bShouldBlurOnFire=true
    BlurTime=0.1
    BlurTimeIronsight=0.1
    BlurScale=0.01
    BlurScaleIronsight=0.1
}
