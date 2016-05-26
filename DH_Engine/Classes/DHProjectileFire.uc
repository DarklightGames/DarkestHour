//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
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
var     float           PreLaunchTraceDistance;      // how long of a pre launch trace to use (shorter for SMGs and pistols, longer for rifles and MGs)
var     bool            bTraceHitBulletProofColMesh; // bullet has hit a collision mesh actor that is bullet proof, so we can handle vehicle hits accordingly

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
    local rotator R, Aim;
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

    SpawnCount = Max(1, ProjPerFire * int(Load));

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
                Theta = AppliedSpread * PI / 32768.0 * (ProjectileID - float(SpawnCount - 1) / 2.0);
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

    // Do any additional pitch changes before launching the projectile
    Dir.Pitch += AddedPitch;

    // Perform pre-launch trace (if enabled) & exit without spawning projectile if it hits something valid & handles damage & effects here
    if (bUsePreLaunchTrace && Weapon != none && PreLaunchTrace(Start, vector(Dir)))
    {
        return none;
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
// In multiplayer, this only happens on server, so have to record players that would have been whizzed & play whizzes after trace, if we are going to stop bullet spawning[
function bool PreLaunchTrace(vector Start, vector Direction)
{
    local Actor           Other, A;
    local DHPawn          HitPlayer, WhizzedPlayer;
    local vector          HitLocation, HitPlayerLocation, TempHitLocation, HitNormal, TempHitNormal, Momentum;
    local material        HitMaterial;
    local int             WhizType, Damage, i;
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

        // Abort pre-launch trace if we hit a special BSP that we are using as a network culler, signified by being textured with a material surface type 'EST_Custom00'
        // bHiddenEd is used as a quick screening check, as it's very unusual & is pretty good at flagging up this special BSP (a little hacky, but cheap & effective)
        // Then we have to do a short trace just to get the hit material, to confirm it is our special BSP
        if (A.bHiddenEd)
        {
            Weapon.Trace(TempHitLocation, TempHitNormal, HitLocation + (16.0 * Direction), HitLocation, true,, HitMaterial);

            if (HitMaterial != none && HitMaterial.SurfaceType == EST_Custom00)
            {
                return true; // this will stop the bullet from spawning & we won't play any hit effects
            }
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
    Damage = ProjectileClass.default.Damage;
    Momentum = ProjectileClass.default.MomentumTransfer * Direction;

    if (HitPlayer != none)
    {
        HitPlayer.ProcessLocationalDamage(Damage, Instigator, HitLocation, Momentum, ProjectileClass.default.MyDamageType, HitPoints);
    }
    else if (!bTraceHitBulletProofColMesh)
    {
        if (Other.IsA('ROVehicle') && class<ROBullet>(ProjectileClass) != none)
        {
            Other.TakeDamage(Damage, Instigator, HitLocation, Momentum, class<ROBullet>(ProjectileClass).default.MyVehicleDamage); // only difference is using special vehicle DamageType
        }
        else if (!Other.bWorldGeometry || Other.IsA('RODestroyableStaticMesh'))
        {
            Other.TakeDamage(Damage, Instigator, HitLocation, Momentum, ProjectileClass.default.MyDamageType);
        }
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
    bUsePreLaunchTrace=true
    PreLaunchTraceDistance=2624.0 // 43.5m

    ProjPerFire=1
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
