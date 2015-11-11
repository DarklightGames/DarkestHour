//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
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
    local ROVehicleWeapon HitVehicleWeapon;
    local DHPawn          HitPawn;
    local Actor           A;
    local array<Actor>    SavedColMeshes;
    local vector          PawnHitLocation, TempHitLocation, HitNormal, X, Y, Z;
    local bool            bPenetratedVehicle;
    local float           BulletDistance, V;
    local array<int>      HitPoints;
    local int             i;

    // Exit without doing anything if we hit something we don't want to count a hit on
    // Note that bBlockHitPointTraces removed here & instead checked in Touch() event, so an actor owning a collision mesh actor gets handled properly
    if (Other == none || SavedTouchActor == Other || Other == Instigator || Other.Base == Instigator || Other.Owner == Instigator
        || Other.bDeleteMe || (Other.IsA('Projectile') && !Other.bProjTarget))
    {
        return;
    }

    SavedTouchActor = Other;
    HitVehicleWeapon = ROVehicleWeapon(Other);

    // Handle hit on a vehicle weapon
    if (HitVehicleWeapon != none)
    {
        bPenetratedVehicle = !HasDeflected() && PenetrateVehicleWeapon(HitVehicleWeapon);

        PlayVehicleHitEffects(bPenetratedVehicle, HitLocation, Normal(-Velocity));

        // Exit if failed to penetrate, destroying bullet unless it's a tracer deflection
        if (!bPenetratedVehicle)
        {
            // Tracer deflects unless bullet speed is very low (approx 12 m/s)
            // Added the trace to get a HitNormal, so ricochet is at correct angle (from shell's DeflectWithoutNormal function)
            if (Level.NetMode != NM_DedicatedServer && bHasTracer && VSizeSquared(Velocity) > 500000.0)
            {
                Trace(HitLocation, HitNormal, HitLocation + Normal(Velocity) * 50.0, HitLocation - Normal(Velocity) * 50.0, true);
                DHDeflect(HitLocation, HitNormal, HitVehicleWeapon);
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
    }

    // Get the axes, based on bullet's direction
    if (V >= 25.0 || HasDeflected())
    {
        GetAxes(rotator(Velocity), X, Y, Z);
    }
    // But if bullet collides right after launch it won't have any velocity yet, so give it the default speed & use its rotation to get axes
    else
    {
        V = default.Speed;
        GetAxes(Rotation, X, Y, Z);
    }

    // We hit the bullet whip attachment around a player pawn
    if (ROBulletWhipAttachment(Other) != none)
    {
        if ((Other.Base != none && Other.Base.bDeleteMe) || Instigator == none)
        {
            return;
        }

        // Set WhizType for possible bullet snap sound
        if (!HasDeflected())
        {
            // If bullet collides immediately after launch, it has no location (or so it would appear, go figure) - let's check against the firer's location instead
            if (OrigLoc == vect(0.0, 0.0, 0.0))
            {
                OrigLoc = Instigator.Location;
            }

            BulletDistance = class'DHLib'.static.UnrealToMeters(VSize(HitLocation - OrigLoc)); // calculate distance travelled by bullet in metres

            // If it's friendly fire at close range, we won't suppress, so send a different WhizType in the HitPointTrace
            if (BulletDistance < 10.0 && InstigatorController != none && DHPawn(Other.Base) != none && InstigatorController.SameTeamAs(DHPawn(Other.Base).Controller))
            {
                WhizType = 3;
            }
            // Bullets only "snap" after a certain distance in reality, same goes here
            else if (BulletDistance < 20.0 && WhizType == 1)
            {
                WhizType = 2;
            }
        }

        // Trace to see if bullet path will actually hit one of the player pawn's various body hit points
        // Use the Instigator pawn to do the trace, as that makes a HitPointTrace work better, as it ignores the Instigator (the firing player) & its bullet whip attachment
        // Matt: temporarily make Instigator use same bUseCollisionStaticMesh setting as projectile (normally means switching to true), meaning trace uses col meshes on vehicles
        Instigator.bUseCollisionStaticMesh = bUseCollisionStaticMesh;

        // Maximum of 3 traces - but we only ever repeat the trace if we hit an invalid col mesh actor, which is very rare, so nearly always only 1 trace will be done
        for (i = 0; i < 3; ++i)
        {
            A = Instigator.HitPointTrace(TempHitLocation, HitNormal, HitLocation + (65535.0 * X), HitPoints, HitLocation,, WhizType);

            // We're primarily interested if we hit a player, but also need to check if hit an invalid collision mesh that doesn't stop bullets (as would need to repeat trace)
            if (DHPawn(A) != none || (DHCollisionMeshActor(A) != none && DHCollisionMeshActor(A).bWontStopBullet))
            {
                // Make sure hit actor isn't further away than furthest possible point of bullet whip attachment (don't count as valid hit, just let bullet continue)
                if (VSizeSquared(TempHitLocation - HitLocation) <= 360000.0) // 360k is whip's diameter (600 UU) squared
                {
                    // We hit a player, so record it
                    if (DHPawn(A) != none)
                    {
                        HitPawn = DHPawn(A);
                        PawnHitLocation = TempHitLocation;
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

            break; // generally we're going to exit the for loop after the 1st pass, except in the rare event where we hit an invalid col mesh
        }

        // Reset any temporarily disabled collision mesh collision, now we've finished tracing
        for (i = 0; i < SavedColMeshes.Length; ++i)
        {
            SavedColMeshes[i].SetCollision(true, SavedColMeshes[i].bBlockActors);
        }

        // HitPointTrace says we hit a player, but we need to verify that as HitPointTrace is unreliable & often passes through a blocking vehicle, hitting a shielded player
        if (HitPawn != none)
        {
            // Trace along path from where we hit player's whip attachment to where we traced a hit on player, checking if any blocking actor is in the way
            foreach Instigator.TraceActors(class'Actor', A, TempHitLocation, HitNormal, PawnHitLocation, HitLocation)
            {
                // We hit a blocking actor, so now check if it's a valid 'stopper'
                if ((A.bBlockActors || A.bWorldGeometry) && A.bBlockHitPointTraces)
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

                    // A blocking actor is in the way, so we didn't really hit the player (but ignore anything ProcessTouch would normally ignore)
                    if (A != Instigator && A.Base != Instigator && A.Owner != Instigator && !A.bDeleteMe && (!A.IsA('Projectile') || A.bProjTarget) && A != HitPawn)
                    {
                        HitPawn = none;
                        break;
                    }
                }
            }
        }

        // Reset Instigator collision properties & reset WhizType for next collision
        Instigator.bUseCollisionStaticMesh = Instigator.default.bUseCollisionStaticMesh;
        WhizType = default.WhizType;

        // Bullet won't hit the player, so we'll exit now
        if (HitPawn == none)
        {
            return;
        }
    }

    // Do any damage
    if (!HasDeflected() && Role == ROLE_Authority && V > (MinPenetrateVelocity * ScaleFactor))
    {
        UpdateInstigator();

        // Damage a player pawn
        if (HitPawn != none)
        {
            if (!HitPawn.bDeleteMe)
            {
                HitPawn.ProcessLocationalDamage(Damage - 20.0 * (1.0 - V / default.Speed), Instigator, PawnHitLocation, MomentumTransfer * X, MyDamageType, HitPoints);
            }
        }
        // Damage something else
        else
        {
            Other.TakeDamage(Damage - 20.0 * (1.0 - V / default.Speed), Instigator, HitLocation, MomentumTransfer * X, MyDamageType);
        }
    }

    // The only way a tracer will deflect is off a vehicle weapon, which is handled above & results in exiting function early, so we can always destroy the bullet here
    Destroy();
}

// From DHBullet
simulated function HitWall(vector HitNormal, Actor Wall)
{
    local ROVehicle HitVehicle;
    local bool      bPenetratedVehicle;

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
        Spawn(ImpactEffect,,, Location, rotator(-HitNormal));
    }

    if (!HasDeflected() && (HitVehicle == none || bPenetratedVehicle))
    {
        // Do any damage
        if (Role == ROLE_Authority)
        {
            UpdateInstigator();

            // Have to use special damage for vehicles, otherwise it doesn't register for some reason
            if (ROVehicle(Wall) != none)
            {
                Wall.TakeDamage(Damage - (20.0 * (1.0 - VSize(Velocity) / default.Speed)), Instigator, Location, MomentumTransfer * Normal(Velocity), MyVehicleDamage);
            }
            else if (Mover(Wall) != none || RODestroyableStaticMesh(Wall) != none || Vehicle(Wall) != none || ROVehicleWeapon(Wall) != none)
            {
                Wall.TakeDamage(Damage - (20.0 * (1.0 - VSize(Velocity) / default.Speed)), Instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
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
    return DHVehicleCannon(VW) == none || !DHVehicleCannon(VW).DHShouldPenetrate(self, Location, Normal(Velocity), GetPenetration(LaunchLocation - Location));
}

// Modified to run penetration calculations on an armored vehicle, but damage any other vehicle automatically
simulated function bool PenetrateVehicle(ROVehicle V)
{
    return DHArmoredVehicle(V) == none || DHArmoredVehicle(V).DHShouldPenetrate(self, Location, Normal(Velocity), GetPenetration(LaunchLocation - Location));
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

// Modified so tracer bullet switches to DeflectedMesh (from DHBullet)
simulated function DHDeflect(vector HitLocation, vector HitNormal, Actor Wall)
{
    if (StaticMesh != DeflectedMesh)
    {
        SetStaticMesh(DeflectedMesh);
    }
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
    ShellHitWaterEffectClass=class'ROBulletHitWaterEffect'

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
