//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHProjectileFire extends DHWeaponFire;

struct WhizInfo
{
    var DHPawn  Player;
    var vector  SoundLocation;
    var byte    Type;
};

// Projectile spawning & pre-launch trace
var     int             ProjPerFire;                 // how many projectiles are spawned each fire (normally 1)
var     vector          ProjSpawnOffset;             // positional offset to spawn projectile
var     vector          FAProjSpawnOffset;           // positional offset to spawn projectile for free-aim mode
var     int             AddedPitch;                  // additional pitch to add to firing calculations (primarily used for rocket launchers)
var     bool            bUsePreLaunchTrace;          // use pre-projectile spawn trace to see if we hit anything close before launching projectile (saves CPU and net usage)
var     float           PreLaunchTraceDistance;      // length of a pre-launch trace, in Unreal units (calculated automatically, based on bullet's maximum speed)
var     float           PreLaunchTraceLengthFactor;  // determines pre launch trace length, as a factor to be multiplied by the bullet's speed
var     bool            bTraceHitBulletProofColMesh; // bullet has hit a collision mesh actor that is bullet proof, so we can handle vehicle hits accordingly

// Weapon spread/inaccuracy
var     float           CrouchSpreadModifier;        // modifier applied when player is crouched
var     float           ProneSpreadModifier;         // modifier applied when player is prone
var     float           BipodDeployedSpreadModifier; // modifier applied when player is using a bipod deployed weapon
var     float           RestDeploySpreadModifier;    // modifier applied when players weapon is rest deployed
var     float           HipSpreadModifier;           // modifier applied when player is firing from the hip
var     float           LeanSpreadModifier;          // modifier applied when player is firing while leaning
var     bool            bDebugSpread;                // debug option to show limits of spread as red lines

// Recoil system
var     InterpCurve     RecoilCurve;                 // A curve to determine the recoil modifier for RecoilGain (shots fired recently)
var     float           RecoilGain;                  // The input for the RecoilCurve, RecoilGain is higher if a lot of rounds have been fired recently
var     float           RecoilGainIncrementAmount;   // The value to increase RecoilGain by every time recoil happens
var     float           RecoilFallOffFactor;         // (TimeSinceLastRecoil ^ RecoilFallOffExponent) * RecoilFallOffFactor
var     float           RecoilFallOffExponent;
var     float           PctHipMGPenalty;             // Amount of recoil to add when the player firing an MG from the hip

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

// Different firing animations if the weapon is firing its last round
var     name    FireLastAnim;
var     name    FireIronLastAnim;

// Modified to set pre-launch trace distance, based on bullet's maximum speed, so slower bullets that drop sooner use a shorter trace
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (bUsePreLaunchTrace)
    {
        PreLaunchTraceDistance = PreLaunchTraceLengthFactor * ProjectileClass.default.Speed;
    }
}

function float MaxRange()
{
    return 25000.0; // about 415 meters
}

function DoFireEffect()
{
    local Actor   TracedActor;
    local coords  MuzzlePosition;
    local vector  StartTrace, FireLocation, HitLocation, HitNormal, FireDirection, X, Y, Z;
    local rotator RandomSpread;
    local float   AppliedSpread;
    local int     NumProjectiles, i, j, k;

    if (Weapon == none)
    {
        return;
    }

    if (Instigator != none)
    {
        Instigator.MakeNoise(1.0);
    }

    // Get FireLocation to spawn projectile, & do a trace to check if projectile would spawn through something like a wall (due to ProjSpawnOffset)
    // If hip firing, spawn projectile at muzzle tip plus FAProjSpawnOffset
    // Have to calculate the the muzzle offset & then scale it down 5 times, as the 1st person model is scaled up 5 times in the editor
    if (Instigator != none && IsPlayerHipFiring())
    {
        MuzzlePosition = Weapon.GetMuzzleCoords();
        StartTrace = Weapon.Location + (0.2 * (MuzzlePosition.Origin - Weapon.Location));
        FireLocation = StartTrace + (MuzzlePosition.XAxis * FAProjSpawnOffset.X);
        TracedActor = Trace(HitLocation, HitNormal, StartTrace, FireLocation, true);
    }
    // Otherwise if weapon is iron sighted or bipod deployed, spawn at eye position plus ProjSpawnOffset
    else
    {
        Weapon.GetViewAxes(X, Y, Z);
        StartTrace = Instigator.Location + Instigator.EyePosition();
        FireLocation = StartTrace + (X * ProjSpawnOffset.X);
        TracedActor = Trace(HitLocation, HitNormal, FireLocation, StartTrace, false); // false means only trace world geometry
    }

    if (TracedActor != none)
    {
        FireLocation = HitLocation; // adjust spawn location to traced HitLocation if we traced something in the way
    }

    // Get the direction for the projectile
    // If player is hip firing (& is the default free-aim type), use where the muzzle bone is pointing
    if (IsPlayerHipFiring() && Instigator != none && Instigator.IsHumanControlled() && Weapon != none && Weapon.bUsesFreeAim)
    {
        FireDirection = MuzzlePosition.XAxis;
    }
    // Otherwise we call AdjustAim to confirm our aimed direction, but for human players that simply returns where the player is looking
    else
    {
        FireDirection = vector(AdjustAim(FireLocation, AimError));
    }

    // Calculate random spread
    CalcSpreadModifiers();

    if (Weapon.IsA('DHProjectileWeapon') && DHProjectileWeapon(Weapon).bBarrelDamaged)
    {
        AppliedSpread = 4.0 * Spread;
    }
    else
    {
        AppliedSpread = Spread;
    }

    // Finally spawn the projectile (or multiple), applying random spread
    NumProjectiles = Max(1, ProjPerFire * int(Load));

    for (i = 0; i < NumProjectiles; ++i)
    {
        if (SpreadStyle == SS_Random)
        {
            RandomSpread.Yaw = AppliedSpread * ((FRand() - 0.5) / 1.5);
            RandomSpread.Pitch = AppliedSpread * (FRand() - 0.5);
            RandomSpread.Roll = AppliedSpread * (FRand() - 0.5);
        }

        SpawnProjectile(FireLocation, rotator(FireDirection >> RandomSpread));
    }

    // Debug option to show limits of spread as red lines
    if (bDebugSpread && SpreadStyle == SS_Random)
    {
        Weapon.ClearStayingDebugLines();

        for (i = 0; i < 3; ++i)
        {
            for (j = 0; j < 3; ++j)
            {
                for (k = 0; k < 3; ++k)
                {
                    RandomSpread.Yaw = AppliedSpread * (((float(i) / 2.0) - 0.5) / 1.5);
                    RandomSpread.Pitch = AppliedSpread * ((float(j) / 2.0) - 0.5);
                    RandomSpread.Roll = AppliedSpread * ((float(k) / 2.0) - 0.5);
                    Weapon.DrawStayingDebugLine(FireLocation, FireLocation + (25000.0 * (FireDirection >> RandomSpread)), 255, 0, 0);
                }
            }
        }
    }
}

simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
    Canvas.SetDrawColor(250,180,180);
    Canvas.DrawText("===FIREMODE===" @ Name @ "RecoilGain:" @ GetEffectiveRecoilGain() @ "IsFiring:" @ bIsFiring @ "In state:" @ GetStateName());
    YPos += YL;
    Canvas.SetPos(4,YPos);
}

// New helper function to check whether player is hip firing
// Allows easy subclassing, which avoids re-stating long functions just to change bUsingSights and/or bBipodDeployed
simulated function bool IsPlayerHipFiring()
{
    return !(Weapon != none && Weapon.bUsingSights) && !(Instigator != none && Instigator.bBipodDeployed);
}

simulated function bool IsInstigatorBipodDeployed()
{
    return Instigator != none && Instigator.bBipodDeployed;   
}

function CalcSpreadModifiers()
{
    local DHPawn P;
    local float  PlayerSpeed, MovementPctModifier;

    P = DHPawn(Instigator);

    if (P == none)
    {
        return;
    }

    // Calculate base spread based on movement speed
    PlayerSpeed = VSize(P.Velocity);
    MovementPctModifier = PlayerSpeed / P.default.GroundSpeed;
    Spread = (1.0 + MovementPctModifier) * default.Spread;

    if (P.bIsCrawling)
    {
        Spread *= ProneSpreadModifier;
    }
    else if (P.bIsCrouched && PlayerSpeed == 0.0) // crouching reduction only applied if player isn't moving
    {
        Spread *= CrouchSpreadModifier;
    }

    if (P.bRestingWeapon)
    {
        Spread *= RestDeploySpreadModifier;
    }

    if (P.bBipodDeployed)
    {
        Spread *= BipodDeployedSpreadModifier;
    }
    else if (!P.Weapon.bUsingSights)
    {
        Spread *= HipSpreadModifier;
    }

    if (P.LeanAmount != 0.0)
    {
        Spread *= LeanSpreadModifier;
    }

    // Make the spread crazy if you're jumping // TODO: think Spread should be capped, as a really high spread could result in shots going off at impossible angles
    if (P.Physics == PHYS_Falling)
    {
        Spread *= 500.0;
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

    // Do any additional pitch changes before launching the projectile
    Dir.Pitch += AddedPitch;

    // Perform pre-launch trace (if enabled) & exit without spawning projectile if it hits something valid & handles damage & effects here
    if (bUsePreLaunchTrace && Weapon != none && PreLaunchTrace(Start, vector(Dir)))
    {
        return none;
    }

    // Spawn a tracer projectile if one is due
    // But don't bother on a dedicated server if weapon uses the 'high ROF' system, as net clients will handle tracers independently
    if (bUsesTracers && !(Level.NetMode == NM_DedicatedServer && DHHighROFWeaponAttachment(Weapon.ThirdPersonActor) != none) && TracerProjectileClass != none)
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
// In multiplayer, this only happens on server, so have to record players that would have been whizzed & play whizzes after trace, if we are going to stop bullet spawning[
function bool PreLaunchTrace(vector Start, vector Direction)
{
    local Actor           Other, A;
    local DHPawn          HitPlayer, WhizzedPlayer;
    local vector          HitLocation, HitPlayerLocation, TempHitLocation, HitNormal;
    local int             WhizType, i;
    local array<int>      HitPoints;
    local array<WhizInfo> SavedWhizzes;

    bTraceHitBulletProofColMesh = false; // reset

    // We have to use an actor to do traces, because we aren't an actor & so can't access trace functions
    // Using Weapon as it's safe to temporarily change its bUseCollisionStaticMesh, meaning trace detects collision meshes on vehicles
    // Our Instigator pawn doesn't work, as it has bBlockHitPointTraces=false, meaning it won't detect hits on bullet whip attachments, which we need
    Weapon.bUseCollisionStaticMesh = ProjectileClass.default.bUseCollisionStaticMesh;

    foreach Weapon.TraceActors(class'Actor', A, HitLocation, HitNormal, Start + (PreLaunchTraceDistance * Direction), Start)
    {
        // Ignore this traced actor, as it's not something that would trigger HitWall or ProcessTouch for a bullet (i.e. a possible hit)
        if (!A.bWorldGeometry && A.Physics != PHYS_Karma && !((A.bBlockActors || A.bProjTarget) && A.bBlockHitPointTraces))
        {
            continue;
        }

        // If hit collision mesh actor, we switch hit actor to col mesh's owner & proceed as if we'd hit that actor
        if (A.IsA('DHCollisionMeshActor'))
        {
            // But if col mesh doesn't stop bullets, we ignore it & continue the trace iteration
            if (DHCollisionMeshActor(A).bWontStopBullet)
            {
                continue;
            }

            // If col mesh is bullet proof then set a flag, so we can handle vehicle hits accordingly
            if (DHCollisionMeshActor(A).bIsBulletProof)
            {
                bTraceHitBulletProofColMesh = true;
            }

            A = A.Owner;
        }

        // Ignore anything anything a bullet's ProcessTouch would normally ignore
        if (A == Instigator || A.Base == Instigator || A.Owner == Instigator || A.bDeleteMe || (A.IsA('Projectile') && !A.bProjTarget))
        {
            bTraceHitBulletProofColMesh = false; // reset
            continue;
        }

        // Hit bullet whip attachment around player, which isn't itself a valid hit actor, but now need to Trace to see if bullet actually hits one of player's various body hit points
        // We also need to handle whiz effects for the player
        if (A.IsA('ROBulletWhipAttachment'))
        {
            WhizzedPlayer = DHPawn(A.Base);

            // If we've already traced a player hit, ignore any further whip attachments, as their players must be further away & aren't going to be hit or whizzed
            // Also ignore any whip attachment that doesn't have a live DHPawn
            if (HitPlayer != none || WhizzedPlayer == none || WhizzedPlayer.bDeleteMe)
            {
                continue;
            }

            WhizType = 0; // reset for this player - WhizType 0 means no whiz (native code won't calculate WhizLocation or trigger PawnWhizzed)

            // Player needs to be whizzed, so determine WhizType to use in HitPointTrace
            // Passing 'true' means skip IsLocallyControlled check, as server also needs to do this so it can get whiz info to replicate to net client
            if (WhizzedPlayer.ShouldBeWhizzed(true))
            {
                // Get default WhizType for our projectile (1 is supersonic 'snap', 2 is subsonic whiz)
                if (class<DHBullet>(ProjectileClass) != none)
                {
                    WhizType = class<DHBullet>(ProjectileClass).default.WhizType;
                }
                else if (class<DHBullet_ArmorPiercing>(ProjectileClass) != none)
                {
                    WhizType = class<DHBullet_ArmorPiercing>(ProjectileClass).default.WhizType;
                }

                class'DHBullet'.static.GetWhizType(WhizType, WhizzedPlayer, Instigator, Start);

                // Server saves player & whiz info, to replicate to net client later if pre-launch trace is successful & we don't spawn a bullet
                // Server doesn't actually play whiz locally
                if (!WhizzedPlayer.IsLocallyControlled()) // doesn't include listen server whizzing the local player, i.e. the listen server operator
                {
                    i = SavedWhizzes.Length;
                    SavedWhizzes.Length = i + 1;
                    SavedWhizzes[i].Player = WhizzedPlayer;
                    SavedWhizzes[i].Type = byte(WhizType);
                    WhizType = 255; // special WhizType 255 makes native code trigger PawnWhizzed event, so we can grab its WhizLocation, but doesn't try to play whiz effects on server
                }
            }

            // Trace to see if bullet path will actually hit one of the player pawn's various body hit points
            // HitPointTraces don't work well with short traces, so we have to do long trace first, then if we hit player we check whether he was within the whip attachment
            A = Weapon.HitPointTrace(TempHitLocation, HitNormal, HitLocation + (65535.0 * Direction), HitPoints, HitLocation,, WhizType);

            // If we've set WhizType 255, server server needs to replicate whiz to owning net client
            // So as soon as we've done HitPointTracewe, we grab WhizLocation calculated by native code for 'dummy' PawnWhizzed event we triggered
            if (WhizType == 255)
            {
                SavedWhizzes[i].SoundLocation = WhizzedPlayer.LastWhizLocation;
            }

            // We're primarily interested if we hit a player, but also need to check if hit an awkward collision or destroyable mesh that doesn't stop a bullet
            if (DHPawn(A) != none || (DHCollisionMeshActor(A) != none && DHCollisionMeshActor(A).bWontStopBullet)
                || (RODestroyableStaticMesh(A) != none && RODestroyableStaticMesh(A).bWontStopBullets))
            {
                // Only count hit if traced actor is within extent of bullet whip (we had to do an artificially long HitPointTrace, so may have traced something far away)
                if (VSizeSquared(TempHitLocation - HitLocation) <= 180000.0) // 180k is square of max distance across whip 'diagonally'
                {
                    // We hit a player, so record it - but we'll let the TraceActors iteration continue so we can make sure there's no blocking actor in front of player
                    if (DHPawn(A) != none)
                    {
                        HitPlayer = DHPawn(A);
                        HitPlayerLocation = TempHitLocation;
                    }
                    // Otherwise, must have hit a special collision mesh or destroyable mesh (e.g. glass) that doesn't stop bullets
                    // This really complicates the trace as it ought to continue (in the case of glass, having broken it)
                    // These are very rare & cause too many complications to be worth handling in pre-launch trace, so we'll just exit & let bullet spawn & handle things
                    else
                    {
                        Other = A; // makes certain we'll return false & exit
                        break;
                    }
                }
            }
        }
        // We hit a valid actor, so that's what we'll register for our pre-launch trace result
        else
        {
            // Except if we've already recorded a possible player hit, we need to check whether that player is closer than this blocking actor
            if (HitPlayer != none)
            {
                // This actor is closer than previously traced player, so it's in front of player & will block the shot
                // Ignore false player hit & we'll register a pre-launch trace hit on this actor
                if (VSizeSquared(HitLocation - Start) < VSizeSquared(HitPlayerLocation - Start))
                {
                    HitPlayer = none;
                }
                // This actor is behind player, so player his is valid & we'll allow the pre-launch trace hit on player
                else
                {
                    break;
                }
            }

            Other = A;
            break;
        }
    }

    Weapon.bUseCollisionStaticMesh = Weapon.default.bUseCollisionStaticMesh; // reset, now we've finished using Weapon to do traces

    // We didn't trace a valid hit on anything within pre-launch trace range, so return false & spawn a projectile as normal
    if (Other == none && HitPlayer == none)
    {
        return false;
    }

    // We hit a special collision mesh or destroyable mesh (e.g. glass) that doesn't stop bullets
    // These are very rare & cause too many complications to be worth handling in pre-launch trace, so we'll just exit & let bullet spawn & handle things
    if ((DHCollisionMeshActor(A) != none && DHCollisionMeshActor(A).bWontStopBullet) || (RODestroyableStaticMesh(Other) != none && RODestroyableStaticMesh(Other).bWontStopBullets))
    {
        return false;
    }

    // This is a bit of a hack, but it prevents bots from killing other players in most instances (by preventing the shot from taking place)
    if (!Instigator.IsHumanControlled() && Pawn(Other) != none && Instigator.Controller.SameTeamAs(Pawn(Other).Controller))
    {
        return true;
    }

    // We traced a hit on something valid & aren't going to spawn bullet, so now loop through any SavedWhizzes and play the whiz effects for that player
    for (i = 0; i < SavedWhizzes.Length; ++i)
    {
        SavedWhizzes[i].Player.ClientPawnWhizzed(SavedWhizzes[i].SoundLocation, SavedWhizzes[i].Type);
    }

    // Update hit effect (not if we hit a player, as blood effects etc get handled in ProcessLocationalDamage/TakeDamage)
    if (HitPlayer == none && ROWeaponAttachment(Weapon.ThirdPersonActor) != none && (Other.bWorldGeometry || Other.IsA('Vehicle') || Other.IsA('VehicleWeapon')))
    {
        ROWeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other, HitLocation, HitNormal);
    }

    // Finally handle damage on whatever we've hit
    if (HitPlayer != none)
    {
        HitPlayer.ProcessLocationalDamage(ProjectileClass.default.Damage, Instigator, HitPlayerLocation,
            ProjectileClass.default.MomentumTransfer * Direction, ProjectileClass.default.MyDamageType, HitPoints);
    }
    else if ((!Other.bWorldGeometry || Other.IsA('RODestroyableStaticMesh')) && !bTraceHitBulletProofColMesh)
    {
        Other.TakeDamage(ProjectileClass.default.Damage, Instigator, HitLocation,
            ProjectileClass.default.MomentumTransfer * Direction, ProjectileClass.default.MyDamageType);
    }

    return true;
}

simulated function float GetFiringSoundPitch()
{
    local float                 Pitch;
    local DHProjectileWeapon    W;

    // Set default pitch
    Pitch = 1.0;

    W = DHProjectileWeapon(Weapon);

    if (W != none && W.bBarrelDamaged)
    {
        // 0.8125 is 64/52.0 (the value used for MG overheating (weapons with looping sounds)
        Pitch = FMax(0.8125, 1.0 - ((W.BarrelTemperature - W.default.BarrelClass.default.CriticalTemperature) / (W.default.BarrelClass.default.FailureTemperature - W.default.BarrelClass.default.CriticalTemperature)));
    }

    return Pitch;
}

// Modified to handle low pitch from barrels
function ServerPlayFiring()
{
    if (FireSounds.Length > 0)
    {
        Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)],SLOT_None,FireVolume,,, GetFiringSoundPitch(), false);
    }
}

// Modified to handle different firing animations when on sights
function PlayFiring()
{
    if (Weapon != none)
    {
        if (Weapon.Mesh != none)
        {
            if (FireCount > 0)
            {
                if (!IsPlayerHipFiring() && Weapon.HasAnim(FireIronLoopAnim))
                {
                    Weapon.PlayAnim(FireIronLoopAnim, FireLoopAnimRate, 0.0);
                }
                else if (Weapon.HasAnim(FireLoopAnim))
                {
                    Weapon.PlayAnim(FireLoopAnim, FireLoopAnimRate, 0.0);
                }
                else if (Weapon.HasAnim(FireAnim))
                {
                    Weapon.PlayAnim(FireAnim, FireAnimRate, FireTweenTime);
                }
            }
            else if (!IsPlayerHipFiring() && Weapon.HasAnim(FireIronAnim))
            {
                if (Weapon.AmmoAmount(ThisModeNum) < 1 && Weapon.HasAnim(FireIronLastAnim))
                {
                    Weapon.PlayAnim(FireIronLastAnim, FireAnimRate, FireTweenTime);
                }
                else
                {
                    Weapon.PlayAnim(FireIronAnim, FireAnimRate, FireTweenTime);
                }
            }
            else if (Weapon.HasAnim(FireAnim))
            {
                if (Weapon.AmmoAmount(ThisModeNum) < 1 && Weapon.HasAnim(FireLastAnim))
                {
                    Weapon.PlayAnim(FireLastAnim, FireAnimRate, FireTweenTime);
                }
                else
                {
                    Weapon.PlayAnim(FireAnim, FireAnimRate, FireTweenTime);
                }
            }
        }

        if (FireSounds.Length > 0)
        {
            Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)], SLOT_None, FireVolume,,, GetFiringSoundPitch(), false);
        }
    }

    ClientPlayForceFeedback(FireForce);
    FireCount++;
}

// Modified to handle different fire end animation when on sights
function PlayFireEnd()
{
    if (Weapon != none && Weapon.Mesh != none)
    {
        if (!IsPlayerHipFiring() && Weapon.HasAnim(FireIronEndAnim))
        {
            Weapon.PlayAnim(FireIronEndAnim, FireEndAnimRate, FireTweenTime);
        }
        else if (Weapon.HasAnim(FireEndAnim))
        {
            Weapon.PlayAnim(FireEndAnim, FireEndAnimRate, FireTweenTime);
        }
    }
}

// Function which allows a custom recoil modifier, without having to duplicate HandleRecoil entirely
simulated function float CustomHandleRecoil()
{
    return 1.0;
}

simulated function HandleRecoil()
{
    local rotator       NewRecoilRotation;
    local DHPlayer      PC;
    local DHPawn        P;

    if (Instigator != none)
    {
        PC = DHPlayer(Instigator.Controller);
        P = DHPawn(Instigator);
    }

    if (PC == none || P == none)
    {
        return;
    }

    if (!PC.bFreeCamera)
    {
        // Initial recoil values (random range from 75% of max to max)
        NewRecoilRotation.Pitch = RandRange(MaxVerticalRecoilAngle * 0.75, MaxVerticalRecoilAngle);
        NewRecoilRotation.Yaw = RandRange(MaxHorizontalRecoilAngle * 0.75, MaxHorizontalRecoilAngle);

        // Randomize the horizontal recoil (so it goes left or right)
        if (Rand(2) == 1)
        {
            NewRecoilRotation.Yaw *= -1;
        }

        // If falling, increase recoil significantly
        if (Instigator.Physics == PHYS_Falling)
        {
            NewRecoilRotation *= 3;
        }

        if (Instigator.bIsCrouched)
        {
            NewRecoilRotation *= PctCrouchRecoil;

            if (Weapon.bUsingSights)
            {
                NewRecoilRotation *= PctCrouchIronRecoil;
            }
        }
        else if (Instigator.bIsCrawling)
        {
            NewRecoilRotation *= PctProneRecoil;

            if (Weapon.bUsingSights)
            {
                NewRecoilRotation *= PctProneIronRecoil;
            }
        }
        else if (Weapon.bUsingSights)
        {
            NewRecoilRotation *= PctStandIronRecoil;
        }

        if (P.bRestingWeapon)
        {
            NewRecoilRotation *= PctRestDeployRecoil;
        }

        if (Instigator.bBipodDeployed)
        {
            NewRecoilRotation *= PctBipodDeployRecoil;
        }

        if (P.LeanAmount != 0)
        {
            NewRecoilRotation *= PctLeanPenalty;
        }

        // Custom recoil functionality
        NewRecoilRotation *= CustomHandleRecoil();

        // Falloff the RecoilGain based on how much time has passed since we last had recoil
        RecoilGain -= GetRecoilGainFalloff(Level.TimeSeconds - PC.LastRecoilTime);
        RecoilGain = FMax(0.0, RecoilGain); // Make sure RecoilGain is not below zero

        // This interps the recoil curve based on RecoilGain, which is based on # of shots fired recently
        NewRecoilRotation *= InterpCurveEval(RecoilCurve, RecoilGain);

        // Increment the RecoilGain as recoil has been handled
        RecoilGain += RecoilGainIncrementAmount;

        // Set the recoil in the DHPlayer
        PC.SetRecoil(NewRecoilRotation, RecoilRate);
    }

    // Handle blur from the recoil
    if (Level.NetMode != NM_DedicatedServer && default.bShouldBlurOnFire && Instigator != none && ROPlayer(Instigator.Controller) != none)
    {
        if (Weapon.bUsingSights)
        {
            PC.AddBlur(BlurTimeIronsight, BlurScaleIronsight);
        }
        else
        {
            PC.AddBlur(BlurTime, BlurScale);
        }
    }
}

// Function used for debugging RecoilGain
simulated function float GetEffectiveRecoilGain()
{
    local float EffectiveRecoilGain;

    EffectiveRecoilGain = RecoilGain - GetRecoilGainFalloff(Level.TimeSeconds - DHPlayer(Instigator.Controller).LastRecoilTime);
    EffectiveRecoilGain = FMax(0.0, EffectiveRecoilGain);

    return EffectiveRecoilGain;
}

simulated function float GetRecoilGainFalloff(float TimeSeconds)
{
    return (TimeSeconds ** RecoilFallOffExponent) * RecoilFallOffFactor;
}

// Modified to use the IsPlayerHipFiring() helper function, which makes this function generic & avoids re-stating in subclasses to make minor changes
simulated function EjectShell()
{
    local ROShellEject Shell;
    local coords       EjectBoneCoords;
    local vector       SpawnLocation, X, Y, Z;
    local rotator      ShellRotation;

    if (ShellEjectClass == none)
    {
        return;
    }

    // Get location & rotation to spawn ejected shell case
    if (IsPlayerHipFiring())
    {
        // Have to calculate the the shell ejection bone offset & then scale it down 5 times, as the 1st person model is scaled up 5 times in the editor
        EjectBoneCoords = Weapon.GetBoneCoords(ShellEmitBone);
        SpawnLocation = Weapon.Location + (0.2 * (EjectBoneCoords.Origin - Weapon.Location));
        SpawnLocation += (EjectBoneCoords.XAxis * ShellHipOffset.X) + (EjectBoneCoords.YAxis * ShellHipOffset.Y) + (EjectBoneCoords.ZAxis * ShellHipOffset.Z);
        ShellRotation = rotator(-EjectBoneCoords.YAxis);
        Shell = Weapon.Spawn(ShellEjectClass, none,, SpawnLocation, ShellRotation);
        ShellRotation = rotator(EjectBoneCoords.XAxis) + ShellRotOffsetHip;
    }
    else
    {
        Weapon.GetViewAxes(X, Y, Z);
        SpawnLocation = Instigator.Location + Instigator.EyePosition();
        SpawnLocation += (X * ShellIronSightOffset.X) + (Y * ShellIronSightOffset.Y) + (Z * ShellIronSightOffset.Z);
        ShellRotation = rotator(Y);
        ShellRotation.Yaw += 16384;
        Shell = Weapon.Spawn(ShellEjectClass, none,, SpawnLocation, ShellRotation);
        ShellRotation = rotator(Y) + ShellRotOffsetIron;
    }

    // Apply random direction & speed to ejected shell
    if (Shell != none)
    {
        ShellRotation.Yaw += Shell.RandomYawRange - Rand(Shell.RandomYawRange * 2);
        ShellRotation.Pitch += Shell.RandomPitchRange - Rand(Shell.RandomPitchRange * 2);
        ShellRotation.Roll += Shell.RandomRollRange - Rand(Shell.RandomRollRange * 2);

        Shell.Velocity = vector(ShellRotation) * (Shell.MinStartSpeed + (FRand() * (Shell.MaxStartSpeed - Shell.MinStartSpeed)));
    }
}

defaultproperties
{
    bInstantHit=false
    bUsePreLaunchTrace=true
    PreLaunchTraceLengthFactor=0.120704 // 50000 velocity = 100m trace
    ProjPerFire=1
    ProjSpawnOffset=(X=25.0)

    // Recoil
    PctStandIronRecoil=0.65
    PctCrouchRecoil=0.75
    PctCrouchIronRecoil=0.6
    PctProneRecoil=0.7
    PctProneIronRecoil=0.4
    PctRestDeployRecoil=0.5
    PctBipodDeployRecoil=0.1
    PctLeanPenalty=1.25
    RecoilCurve=(Points=((InVal=0.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0))) // Default curve has no impact on recoil
    RecoilGainIncrementAmount=1.0
    RecoilFallOffFactor=5.0
    RecoilFallOffExponent=2.0

    // Spread
    CrouchSpreadModifier=0.9
    ProneSpreadModifier=0.8
    BipodDeployedSpreadModifier=0.5
    RestDeploySpreadModifier=0.75
    HipSpreadModifier=3.5
    LeanSpreadModifier=1.15

    NoAmmoSound=Sound'Inf_Weapons_Foley.Misc.dryfire_rifle'
    FireForce="AssaultRifleFire"

    FireAnim="Shoot"
    FireIronAnim="Iron_Shoot"
    TweenTime=0.0

    bShouldBlurOnFire=true
    BlurTime=0.1
    BlurTimeIronsight=0.1
    BlurScale=0.01
    BlurScaleIronsight=0.1

    // Bots
    BotRefireRate=0.5
    WarnTargetPct=0.9
    bLeadTarget=true
}
