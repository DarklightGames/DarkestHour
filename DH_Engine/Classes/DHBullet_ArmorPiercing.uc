//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHBullet_ArmorPiercing extends DHAntiVehicleProjectile
    abstract;

// From ROBullet & DHBullet:
const   MinPenetrateVelocity = 163;

var     class<ROHitEffect>  ImpactEffect;
var     class<ROBulletWhiz> WhizSoundEffect;
var     class<DamageType>   MyVehicleDamage;

var     int             WhizType;
var     float           VehiclePenetrateSoundVolume;
var     float           VehicleDeflectSoundVolume;

// Tracers
var     class<Emitter>  TracerEffectClass;
var     Emitter         TracerEffect;
var     StaticMesh      DeflectedMesh;
var     float           TracerPullback;

// Modified to set tracer properties if this is a tracer bullet (from DHBullet)
simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if (bHasTracer && Level.NetMode != NM_DedicatedServer)
    {
        SetDrawType(DT_StaticMesh);
        bOrientToVelocity = true;

        if (Level.bDropDetail)
        {
            bDynamicLight = false;
        }
        else
        {
            bDynamicLight = true;
            LightType = LT_Steady;
        }

        LightBrightness = 90.0;
        LightRadius = 10.0;
        LightHue = 45;
        LightSaturation = 128;
        AmbientGlow = 254;
        LightCone = 16;

        TracerEffect = Spawn(TracerEffectClass, self,, (Location + Normal(Velocity) * TracerPullback));
    }
}

// From DHBullet, to use DHCollisionMeshActor handling that is specific to a bullet
simulated singular function Touch(Actor Other)
{
    local vector HitLocation, HitNormal;

    // Added bBlockHitPointTraces check here, so can avoid it at start of ProcessTouch(), meaning owner of col mesh gets handled properly in PT (it will have bBlockHitPointTraces=false)
    if (Other != none && (Other.bProjTarget || Other.bBlockActors) && Other.bBlockHitPointTraces)
    {
        // Collision static mesh actor handling
        if (Other.IsA('DHCollisionMeshActor'))
        {
            // If col mesh is set not to stop a bullet then we exit, doing nothing
            if (DHCollisionMeshActor(Other).bWontStopBullet)
            {
                return;
            }

            // If col mesh represents a vehicle, which would normally get a HitWall event instead of Touch, we call HitWall on the vehicle & exit
            if (Other.Owner.IsA('ROVehicle'))
            {
                // Trace the col mesh to get an accurate HitLocation, as the projectile has often travelled further by the time this event gets called
                // A false return means we successfully traced the col mesh, so we change the projectile's location (as we can't pass HitLocation to HitWall)
                if (!Other.TraceThisActor(HitLocation, HitNormal, Location, Location - 2.0 * Velocity, GetCollisionExtent()))
                {
                    SetLocation(HitLocation);
                }

                HitWall(HitNormal, Other.Owner);

                return;
            }

            // Switch hit Other to be the col mesh's owner & proceed as if we'd hit that actor
            Other = Other.Owner;
        }

        LastTouched = Other;

        if (Velocity == vect(0.0, 0.0, 0.0) || Other.IsA('Mover'))
        {
            ProcessTouch(Other, Location);
            LastTouched = none;
        }
        else
        {
            if (Other.TraceThisActor(HitLocation, HitNormal, Location, Location - 2.0 * Velocity, GetCollisionExtent()))
            {
                HitLocation = Location;
            }

            ProcessTouch(Other, HitLocation);
            LastTouched = none;

            if (Role < ROLE_Authority && Other.Role == ROLE_Authority && Pawn(Other) != none)
            {
                ClientSideTouch(Other, HitLocation);
            }
        }
    }
}

// From DHBullet
simulated function ProcessTouch(Actor Other, vector HitLocation)
{
    local DHPawn       HitPlayer, WhizzedPlayer;
    local Pawn         InstigatorPlayer;
    local Actor        A;
    local array<Actor> SavedHitActors;
    local vector       DirectionNormal, PawnHitLocation, TempHitLocation, HitNormal;
    local bool         bPenetratedVehicle;
    local float        V;
    local array<int>   HitPoints;
    local int          TraceWhizType, i;

    if (SavedTouchActor == Other) // immediate exit to prevent recurring touches on same actor
    {
        return;
    }

    SavedTouchActor = Other;

    // Checks are normally run to make sure we haven't hit Instigator or its Base or Owner, which is mainly to stop player hitting his own bullet whip attachment
    // But the whip attachment now retains its collision if player in a vehicle is exposed, so we also need to check on a player in a VehicleWeaponPawn
    // A VehicleWeaponPawn will be the Instigator, so in that case we record InstigatorPlayer as its 'Driver' & use that in place of Instigator
    if (VehicleWeaponPawn(Instigator) != none && VehicleWeaponPawn(Instigator).Driver != none)
    {
        InstigatorPlayer = VehicleWeaponPawn(Instigator).Driver;
    }
    else
    {
        InstigatorPlayer = Instigator;
    }

    // Exit without doing anything if we hit something we don't want to count a hit on
    // Using InstigatorPlayer instead of Instigator, except for a check on "Other.Owner == Instigator", which stops a VehicleWeapon from somehow shooting itself
    // Note that bBlockHitPointTraces removed here & instead checked in Touch() event, so an actor owning a collision mesh actor gets handled properly
    if (Other == none || Other == InstigatorPlayer || Other.Base == InstigatorPlayer || Other.Owner == InstigatorPlayer || Other.Owner == Instigator
        || Other.bDeleteMe || (Other.IsA('Projectile') && !Other.bProjTarget))
    {
        return;
    }

    DirectionNormal = Normal(Velocity);

    // Handle hit on a vehicle weapon
    if (Other.IsA('ROVehicleWeapon'))
    {
        bPenetratedVehicle = !HasDeflected() && PenetrateVehicleWeapon(ROVehicleWeapon(Other));

        PlayVehicleHitEffects(bPenetratedVehicle, HitLocation, -DirectionNormal);

        // Exit if failed to penetrate, destroying bullet unless it's a tracer deflection
        if (!bPenetratedVehicle)
        {
            // Tracer deflects unless bullet speed is very low (approx 12 m/s)
            // Added the trace to get a HitNormal, so ricochet is at correct angle (from shell's DeflectWithoutNormal function)
            if (Level.NetMode != NM_DedicatedServer && bHasTracer && VSizeSquared(Velocity) > 500000.0)
            {
                Trace(HitLocation, HitNormal, HitLocation + (DirectionNormal * 50.0), HitLocation - (DirectionNormal * 50.0), true);
                DHDeflect(HitLocation, HitNormal, Other);
            }
            else
            {
                Destroy();
            }

            return;
        }

        SavedHitActor = Pawn(Other.Base);
    }

    // Get the bullet's speed
    if (!HasDeflected())
    {
        V = VSize(Velocity);

        // If bullet collides right after launch it won't have any velocity yet, so give it the default speed & use its rotation to get a DirectionNormal
        if (V < 25.0)
        {
            V = default.Speed;
            DirectionNormal = vector(Rotation);
        }
    }

    // Hit bullet whip attachment around player, which isn't itself a valid hit actor, but now need to Trace to see if bullet actually hits one of player's various body hit points
    // We also need to handle whiz effects for the player
    if (ROBulletWhipAttachment(Other) != none)
    {
        WhizzedPlayer = DHPawn(Other.Base);

        if (WhizzedPlayer == none || WhizzedPlayer.bDeleteMe || InstigatorPlayer == none)
        {
            return;
        }

        // Player needs to be whizzed, so determine WhizType to use in HitPointTrace
        // If player doesn't need whiz & we don't set TraceWhizType here, default WhizType 0 will mean native code won't calculate WhizLocation or trigger PawnWhizzed
        if (!HasDeflected() && WhizzedPlayer.ShouldBeWhizzed())
        {
            TraceWhizType = default.WhizType; // start with default WhizType for our projectile (1 is supersonic 'snap', 2 is subsonic whiz)
            class'DHBullet'.static.GetWhizType(TraceWhizType, WhizzedPlayer, Instigator, OrigLoc);
        }

        // Trace to see if bullet path will actually hit one of the player pawn's various body hit points
        // Use the InstigatorPlayer to do the trace, as that makes HitPointTrace work better because it ignores the InstigatorPlayer & its own bullet whip attachment
        // Temporarily make InstigatorPlayer use same bUseCollisionStaticMesh setting as projectile (normally means switching to true), meaning trace uses col meshes on vehicles
        InstigatorPlayer.bUseCollisionStaticMesh = bUseCollisionStaticMesh;

        // Maximum of 3 traces - but we only ever repeat trace if hit an invalid col mesh or destro mesh, which is very rare, so nearly always only 1 trace will be done
        for (i = 0; i < 3; ++i)
        {
            // HitPointTraces don't work well with short traces, so we have to do long trace first, then if we hit player we check whether he was within the whip attachment
            A = InstigatorPlayer.HitPointTrace(TempHitLocation, HitNormal, HitLocation + (DirectionNormal * 65535.0), HitPoints, HitLocation,, TraceWhizType);

            // We're primarily interested if we hit a player, but also need to check if hit invalid col mesh or destro mesh that doesn't stop bullet (as would need to repeat trace)
            if (DHPawn(A) != none || (DHCollisionMeshActor(A) != none && DHCollisionMeshActor(A).bWontStopBullet)
                || (RODestroyableStaticMesh(A) != none && RODestroyableStaticMesh(A).bWontStopBullets))
            {
                // Only count hit if traced actor is within extent of bullet whip (we had to do an artificially long HitPointTrace, so may have traced something far away)
                if (VSizeSquared(TempHitLocation - HitLocation) <= 180000.0) // 180k is square of max distance across whip 'diagonally'
                {
                    // We hit a player, so record it - but we need to do a verification trace to make sure there's no blocking actor in front of player
                    if (DHPawn(A) != none)
                    {
                        HitPlayer = DHPawn(A);
                        PawnHitLocation = TempHitLocation;
                    }
                    // Otherwise, must have hit a special collision or destroyable mesh that doesn't stop bullets, so we temporarily disable its collision & re-run the trace
                    // Matt: this is a hack, but I can't think of another solution - the disabled collision is only for a split second & it seems harmless & effective
                    else
                    {
                        TraceWhizType = 0; // if the player needs whizzing, the 1st HitPointTrace will have done it, so set to 0 to avoid repeat whizzes
                        SavedHitActors[SavedHitActors.Length] = A; // save reference to mesh so we can re-enable its collision after tracing
                        A.SetCollision(false, A.bBlockActors);
                        continue; // re-run the trace
                    }
                }
            }

            break; // generally we're going to exit the for loop after the 1st pass, except in the rare event where we hit an invalid col mesh or destro mesh
        }

        // HitPointTrace says we hit a player, but we need to verify that as HitPointTrace is unreliable & often passes through a blocking vehicle, hitting a shielded player
        if (HitPlayer != none)
        {
            // Trace along path from where we hit player's whip attachment to where we traced a hit on player, checking if any blocking actor is in the way
            foreach InstigatorPlayer.TraceActors(class'Actor', A, TempHitLocation, HitNormal, PawnHitLocation, HitLocation)
            {
                // We hit a blocking actor, so now check if it's a valid 'stopper' (something that would trigger HitWall or ProcessTouch)
                if (A.bWorldGeometry || A.Physics == PHYS_Karma || (A.bBlockActors && A.bBlockHitPointTraces))
                {
                    // If hit collision mesh actor, we switch hit actor to col mesh's owner & proceed as if we'd hit that actor
                    if (A.IsA('DHCollisionMeshActor'))
                    {
                        // But if col mesh doesn't stop bullets, we ignore it & continue the trace iteration
                        if (DHCollisionMeshActor(A).bWontStopBullet)
                        {
                            continue;
                        }

                        A = A.Owner;
                    }
                    // If hit destro mesh that won't stop a bullet (e.g. glass), we record it for possible later damage, but ignore it & continue the trace iteration
                    else if (RODestroyableStaticMesh(A) != none && RODestroyableStaticMesh(A).bWontStopBullets)
                    {
                        SavedHitActors[SavedHitActors.Length] = A;
                        continue;
                    }

                    // A blocking actor is in the way, so we didn't really hit the player (but ignore anything ProcessTouch would normally ignore)
                    if (A != InstigatorPlayer && A.Base != InstigatorPlayer && A.Owner != InstigatorPlayer && A.Owner != Instigator
                        && !A.bDeleteMe && !(Other.IsA('Projectile') && !Other.bProjTarget) && A != HitPlayer)
                    {
                        HitPlayer = none;
                        break;
                    }
                }
            }
        }

        // We've finished tracing, so reset any temporarily changed collision properties on InstigatorPlayer or collision/destroyable meshes
        InstigatorPlayer.bUseCollisionStaticMesh = InstigatorPlayer.default.bUseCollisionStaticMesh;

        for (i = SavedHitActors.Length - 1; i >= 0; --i)
        {
            if (SavedHitActors[i] != none)
            {
                SavedHitActors[i].SetCollision(true, SavedHitActors[i].bBlockActors);

                if (!SavedHitActors[i].IsA('RODestroyableStaticMesh'))
                {
                    SavedHitActors.Remove(i, 1); // remove col meshes from array, so we only leave any destro mesh that we may want to damage later
                }
            }
        }

        // Bullet won't hit the player, so we'll exit now
        if (HitPlayer == none)
        {
            return;
        }
    }

    // Do any damage
    if (!HasDeflected() && Role == ROLE_Authority && V > (MinPenetrateVelocity * ScaleFactor))
    {
        UpdateInstigator();

        // Damage a player pawn
        if (HitPlayer != none)
        {
            if (!HitPlayer.bDeleteMe)
            {
                HitPlayer.ProcessLocationalDamage(Damage - 20.0 * (1.0 - V / default.Speed), Instigator, PawnHitLocation, MomentumTransfer * DirectionNormal, MyDamageType, HitPoints);
            }

            // If traced hit on destro mesh that won't stop bullet (e.g. glass) in front of player, need to damage it now as we're destroying bullet & it won't collide with destro mesh
            for (i = 0; i < SavedHitActors.Length; ++i)
            {
                if (RODestroyableStaticMesh(SavedHitActors[i]) != none)
                {
                    SavedHitActors[i].TakeDamage(Damage - 20.0 * (1.0 - V / default.Speed), Instigator, SavedHitActors[i].Location, MomentumTransfer * DirectionNormal, MyDamageType);
                }
            }
        }
        // Damage something else
        else
        {
            Other.TakeDamage(Damage - 20.0 * (1.0 - V / default.Speed), Instigator, HitLocation, MomentumTransfer * DirectionNormal, MyDamageType);
        }
    }

    // The only way a tracer will deflect is off a vehicle weapon, which is handled above & results in exiting function early, so we can always destroy the bullet here
    Destroy();
}

// From DHBullet
simulated function HitWall(vector HitNormal, Actor Wall)
{
    local ROVehicle        HitVehicle;
    local DHArmoredVehicle AV;
    local bool             bPenetratedVehicle;
    local vector           HitLoc;
    local Material         HitMat;

    // This stops tracers from bouncing off thin air where the hidden BSP that network cuts is.
    // It supports network cutting BSP that is textured with a material surface type of `EST_Custom00`
    if (Wall.bHiddenEd) // `LevelInfo` which is BSP is set to bHiddenEd = true
    {
        Trace(HitLoc, HitNormal, Location + vector(Rotation) * 16.0, Location, true,, HitMat);

        if (HitMat != none && HitMat.SurfaceType == EST_Custom00)
        {
            Destroy();
            return;
        }
    }

    // Hit SavedHitActor that we've already hit & recorded
    if (SavedHitActor != none && SavedHitActor == Wall)
    {
        if (bHasTracer)
        {
            // Deflect off wall unless bullet speed is very low (approx 12 m/s)
            if (Level.NetMode != NM_DedicatedServer && VSizeSquared(Velocity) > 500000.0)
            {
                DHDeflect(Location, HitNormal, Wall);
            }
            // Otherwise destroy if tracer has already deflected & this 'bullet' is now just a client visual effect
            else if (HasDeflected())
            {
                bBounce = false;
                Destroy();
            }
        }

        return;
    }

    SavedHitActor = Pawn(Wall);
    HitVehicle = ROVehicle(Wall);

    // Handle hit on a vehicle
    if (HitVehicle != none)
    {
        bPenetratedVehicle = !HasDeflected() && PenetrateVehicle(HitVehicle);

        PlayVehicleHitEffects(bPenetratedVehicle, Location, HitNormal);
    }
    // Spawn the bullet hit effect on anything other than a vehicle
    else if (Level.NetMode != NM_DedicatedServer && ImpactEffect != none)
    {
        Spawn(ImpactEffect, self,, Location, rotator(-HitNormal)); // made bullet the owner of the effect, so effect can use bullet to do an EffectIsRelevant() check
    }

    if (!HasDeflected())
    {
        // Do any damage
        if (Role == ROLE_Authority)
        {
            // Skip calling TakeDamage if we hit a vehicle but failed to penetrate - except check for possible hit on any exposed gunsight optics
            if (HitVehicle != none && !bPenetratedVehicle)
            {
                AV = DHArmoredVehicle(HitVehicle);

                // Hit exposed gunsight optics
                if (AV != none && AV.GunOpticsHitPointIndex >= 0 && AV.GunOpticsHitPointIndex < AV.NewVehHitpoints.Length
                    && AV.NewVehHitpoints[AV.GunOpticsHitPointIndex].NewHitPointType == NHP_GunOptics
                    && AV.IsNewPointShot(Location, MomentumTransfer * Normal(Velocity), 1.0, AV.GunOpticsHitPointIndex)
                    && AV.Cannon != none && DHVehicleCannonPawn(AV.Cannon.WeaponPawn) != none)
                {
                    DHVehicleCannonPawn(AV.Cannon.WeaponPawn).DamageCannonOverlay();

                    if (AV.bLogPenetration)
                    {
                        Log("We hit NHP_GunOptics hitpoint");
                    }

                    if (AV.bDebuggingText)
                    {
                        Level.Game.Broadcast(self, "Hit gunsight optics");
                    }
                }
            }
            else
            {
                UpdateInstigator();

                if (ROVehicle(Wall) != none) // have to use special damage for vehicles, otherwise it doesn't register for some reason
                {
                    Wall.TakeDamage(Damage - (20.0 * (1.0 - VSize(Velocity) / default.Speed)), Instigator, Location, MomentumTransfer * Normal(Velocity), MyVehicleDamage);
                }
                else if (Mover(Wall) != none || RODestroyableStaticMesh(Wall) != none || Vehicle(Wall) != none || ROVehicleWeapon(Wall) != none)
                {
                    Wall.TakeDamage(Damage - (20.0 * (1.0 - VSize(Velocity) / default.Speed)), Instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
                }
            }

            MakeNoise(1.0);
        }

        super(ROBallisticProjectile).HitWall(HitNormal, Wall); // is debug only
    }

    // Don't want to destroy the bullet if its going through something like glass
    if (RODestroyableStaticMesh(Wall) != none && RODestroyableStaticMesh(Wall).bWontStopBullets)
    {
        return;
    }

    // Finally destroy this bullet, or maybe deflect if is tracer
    if (bHasTracer)
    {
        // Deflect off wall unless penetrated vehicle or bullet speed is very low (approx 12 m/s)
        if (Level.NetMode != NM_DedicatedServer && !bPenetratedVehicle && VSizeSquared(Velocity) > 500000.0)
        {
            DHDeflect(Location, HitNormal, Wall);
        }
        else
        {
            bBounce = false;
            Destroy();
        }
    }
    else
    {
        Destroy();
    }
}

// Modified to run penetration calculations on a vehicle cannon (e.g. turret), but damage any other vehicle weapon automatically
simulated function bool PenetrateVehicleWeapon(VehicleWeapon VW)
{
    return DHVehicleCannon(VW) == none || DHVehicleCannon(VW).ShouldPenetrate(self, Location, Normal(Velocity), GetPenetration(LaunchLocation - Location));
}

// Modified to run penetration calculations on an armored vehicle, but damage any other vehicle automatically
simulated function bool PenetrateVehicle(ROVehicle V)
{
    return DHArmoredVehicle(V) == none || DHArmoredVehicle(V).ShouldPenetrate(self, Location, Normal(Velocity), GetPenetration(LaunchLocation - Location));
}

// From DHBullet
simulated function PlayVehicleHitEffects(bool bPenetrated, vector HitLocation, vector HitNormal)
{
    if (Level.NetMode != NM_DedicatedServer)
    {
        if (bPenetrated)
        {
            PlaySound(VehicleHitSound, SLOT_None, VehiclePenetrateSoundVolume, false, 100.0);

            if (EffectIsRelevant(HitLocation, false) && ShellHitVehicleEffectClass != none)
            {
                Spawn(ShellHitVehicleEffectClass, ,, HitLocation, rotator(-HitNormal));
            }
        }
        else
        {
            PlaySound(VehicleDeflectSound, SLOT_None, VehicleDeflectSoundVolume, false, 100.0);

            if (EffectIsRelevant(HitLocation, false) && ShellDeflectEffectClass != none)
            {
                Spawn(ShellDeflectEffectClass,,, HitLocation, rotator(-HitNormal));
            }
        }
    }
}

// Modified so tracer bullet switches to DeflectedMesh & to destroy TracerEffect if bullet speed is very low (from DHBullet)
simulated function DHDeflect(vector HitLocation, vector HitNormal, Actor Wall)
{
    if (TracerEffect != none && VSizeSquared(Velocity) < 750000.0) // approx 14 m/s
    {
        TracerEffect.Destroy();
    }

    if (StaticMesh != DeflectedMesh)
    {
        SetStaticMesh(DeflectedMesh);
    }

    super.DHDeflect(HitLocation, HitNormal, Wall);
}

// New function just to add readability to functions
simulated function bool HasDeflected()
{
    return NumDeflections > 0;
}

// From DHBullet
simulated function Landed(vector HitNormal)
{
    if (bHasTracer)
    {
        SetPhysics(PHYS_None);
        Destroy();
    }
}

// Modified as not an exploding shell
simulated function Explode(vector HitLocation, vector HitNormal)
{
    Destroy();
}

// Modified to destroy any tracer effect
simulated function Destroyed()
{
    super.Destroyed();

    if (TracerEffect != none)
    {
        TracerEffect.Destroy();
    }
}

defaultproperties
{
    WhizSoundEffect=class'DH_Effects.DHBulletWhiz'
    ImpactEffect=class'DH_Effects.DHBulletHitEffect'
    ShellHitVehicleEffectClass=class'DH_Effects.DHBulletPenetrateArmorEffect' // custom class with much smaller penetration effects than shell (PTRD uses 'TankAPHitPenetrateSmall')
    VehicleHitSound=sound'ProjectileSounds.PTRD_penetrate'
    VehiclePenetrateSoundVolume=5.5
    ShellDeflectEffectClass=class'ROEffects.ROBulletHitMetalArmorEffect'
    VehicleDeflectSound=sound'PTRD_deflect'
    VehicleDeflectSoundVolume=5.5
    ShellHitWaterEffectClass=class'ROEffects.ROBulletHitWaterEffect'

    DrawType=DT_None
    WhizType=1
    MaxSpeed=40000.0
    MomentumTransfer=100.0
    LifeSpan=5.0
    DestroyTime=0.1
    bBotNotifyIneffective=false
    MyVehicleDamage=class'ROVehicleDamageType'

    // Tracer properties (won't affect ordinary bullet):
    DrawScale=2.0
    TracerPullback=150.0
    bBounce=true
    DampenFactor=0.1
    DampenFactorParallel=0.05
}
