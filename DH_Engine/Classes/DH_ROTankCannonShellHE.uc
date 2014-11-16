//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ROTankCannonShellHE extends DH_ROTankCannonShell;

var     sound       ExplosionSound[4];          // sound of the round exploding
var     bool        bPenetrated;                // This shell penetrated what it hit

// Matt: re-worked, with commentary below
simulated function ProcessTouch(Actor Other, vector HitLocation)
{
    local ROVehicle       HitVehicle;
    local ROVehicleWeapon HitVehicleWeapon;
    local vector          TempHitLocation, HitNormal, SavedVelocity;
    local array<int>      HitPoints;
    local float           TouchAngle; // dummy variable passed to DHShouldPenetrate function (does not need a value setting)

    log("HE.ProcessTouch called: Other =" @ Other.Tag @ " SavedTouchActor =" @ SavedTouchActor @ " SavedHitActor =" @ SavedHitActor); // TEMP
    if (Other == none || SavedTouchActor == Other || Other.bDeleteMe || Other.IsA('ROBulletWhipAttachment') ||
        Other == Instigator || Other.Base == Instigator || Other.Owner == Instigator || (Other.IsA('Projectile') && !Other.bProjTarget))
    {
        return;
    }

    SavedTouchActor = Other;
    HitVehicleWeapon = ROVehicleWeapon(Other);
    HitVehicle = ROVehicle(Other.Base);

    // We hit a VehicleWeapon
    if (HitVehicleWeapon != none && HitVehicle != none)
    {
        // We hit the Driver's collision box, not the actual VehicleWeapon
        if (HitVehicleWeapon.HitDriverArea(HitLocation, Velocity))
        {
            // We actually hit the Driver
            if (HitVehicleWeapon.HitDriver(HitLocation, Velocity))
            {
                if (Drawdebuglines && Firsthit && Level.NetMode != NM_DedicatedServer)
                {
                    FirstHit = false;
                    DrawStayingDebugLine(Location, Location - (Normal(Velocity) * 500.0), 255, 0, 0);
                }

                log("HE.ProcessTouch: hit driver, should damage him & shell continue"); // TEMP
                if (Role == ROLE_Authority && VehicleWeaponPawn(HitVehicleWeapon.Owner) != none && VehicleWeaponPawn(HitVehicleWeapon.Owner).Driver != none)
                {
                    VehicleWeaponPawn(HitVehicleWeapon.Owner).Driver.TakeDamage(ImpactDamage, Instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage);
                }

                Velocity *= 0.8; // hitting the Driver's body doesn't cause shell to explode, but we'll slow it down a bit
            }
            else
            {
                log("HE.ProcessTouch: hit driver area but not driver, shell should continue"); // TEMP
                SavedTouchActor = none; // this isn't a real hit so we shouldn't save hitting this actor
            }

            return; // exit so shell carries on, as it only hit Driver's collision box not actual VehicleWeapon (even if we hit the Driver, his body won't stop shell)
        }

        SavedHitActor = HitVehicle;

        if (bDebuggingText && Role == ROLE_Authority)
        {
            if (bIsAlliedShell)
            {
                Level.Game.Broadcast(self, "Dist:" @ VSize(LaunchLocation - Location) / 66.002 @ "yards, ImpactVel:" @ VSize(Velocity) / 18.395 @ "fps");
            }
            else
            {
                Level.Game.Broadcast(self, "Dist:" @ VSize(LaunchLocation - Location) / 60.352 @ "m, ImpactVel:" @ VSize(Velocity) / 60.352 @ "m/s");
            }
        }

        // We hit a tank cannon (turret) but failed to penetrate
        if (HitVehicleWeapon.IsA('DH_ROTankCannon') && !DH_ROTankCannon(HitVehicleWeapon).DHShouldPenetrateAPC(HitLocation, Normal(Velocity),
            GetPenetration(LaunchLocation - HitLocation), TouchAngle, ShellDiameter, ShellImpactDamage, bShatterProne))
        {
            if (bDebuggingText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Turret ricochet!");
            }

            if (Drawdebuglines && Firsthit && Level.NetMode != NM_DedicatedServer)
            {
                FirstHit = false;
                DrawStayingDebugLine(Location, Location - (Normal(Velocity) * 500.0), 0, 255, 0);
            }

            // Round deflects off the turret
            if (!bShatterProne || !DH_ROTankCannon(HitVehicleWeapon).bRoundShattered)
            {
                SavedHitActor = none; // don't save hitting this actor since we deflected
                bUpdateSimulatedPosition = false; // don't replicate the position any more

                DoShakeEffect();
                DeflectWithoutNormal(HitVehicleWeapon, HitLocation);

                if (Instigator != none && ROBot(Instigator.Controller) != none)
                {
                    ROBot(Instigator.Controller).NotifyIneffectiveAttack(HitVehicle);
                }
            }
            // Round shatters on turret
            else
            {
                // Don't update the position any more and don't move the projectile any more
                bUpdateSimulatedPosition = false;
                SavedVelocity = Velocity; // PHYS_none zeroes Velocity, so we have to save it
                SetPhysics(PHYS_none);
                SetDrawType(DT_none);

                ShatterExplode(HitLocation + ExploWallOut * Normal(-SavedVelocity), Normal(-SavedVelocity));
                HurtWall = none;
            }

            return;
        }

        // Don't update the position any more and don't move the projectile any more
        bUpdateSimulatedPosition = false;
        SavedVelocity = Velocity; // PHYS_none zeroes Velocity, so we have to save it
        SetPhysics(PHYS_none);
        SetDrawType(DT_none);

        if (Drawdebuglines && Firsthit && Level.NetMode != NM_DedicatedServer)
        {
            log("HE.ProcessTouch: DrawStayingDebugLine for turret penetration: Velocity =" @ Velocity @ " SavedVelocity =" @ SavedVelocity); // TEMP
            FirstHit = false;
            DrawStayingDebugLine(Location, Location - (Normal(SavedVelocity) * 500.0), 255, 0, 0);
        }

        if (Role == ROLE_Authority)
        {
            if (Instigator == none || Instigator.Controller == none)
            {
                HitVehicleWeapon.SetDelayedDamageInstigatorController(InstigatorController);
                HitVehicle.SetDelayedDamageInstigatorController(InstigatorController);
            }

            HitVehicleWeapon.TakeDamage(ImpactDamage, Instigator, Location, MomentumTransfer * Normal(SavedVelocity), ShellImpactDamage);

            if (DamageRadius > 0 && HitVehicle.Health > 0)
            {
                HitVehicle.DriverRadiusDamage(Damage, DamageRadius, InstigatorController, MyDamageType, MomentumTransfer, HitLocation);
            }

            HurtWall = HitVehicle;
        }

        Explode(HitLocation + ExploWallOut * Normal(-SavedVelocity), Normal(-SavedVelocity));
        HurtWall = none;

        return;
    }
    // We hit something other than a VehicleWeapon
    else
    {
        // We hit a soldier ... potentially - first we need to run a HitPointTrace to make sure we actually hit part of his body, not just his collision area
        if (Other.IsA('ROPawn'))
        {
            Other = HitPointTrace(TempHitLocation, HitNormal, HitLocation + (65535.0 * Normal(Velocity)), HitPoints, HitLocation, , 0);

            // We hit one of the body's hit points, so register a hit on the soldier
            if (Other != none)
            {
                log("HE.ProcessTouch: successful HitPointTrace on ROPawn, calling ProcessLocationalDamage on it"); // TEMP
                if (Role == ROLE_Authority)
                {
                    ROPawn(Other).ProcessLocationalDamage(ImpactDamage, Instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage, HitPoints);
                }

                Velocity *= 0.8; // hitting a body doesn't cause shell to explode, but we'll slow it down a bit
            }
            else log("HE.ProcessTouch: unsuccessful HitPointTrace on ROPawn, doing nothing"); // TEMP

            return; // exit without exploding, so shell continues on its flight
        }
        // We hit some other kind of pawn or a destroyable mesh
        else if (Other.IsA('RODestroyableStaticMesh') || Other.IsA('Pawn'))
        {
            if (Role == ROLE_Authority)
            {
                Other.TakeDamage(ImpactDamage, Instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage);
            }

            // We hit a destroyable mesh that is so weak it doesn't stop bullets (e.g. glass), so it won't make a shell explode
            if (Other.IsA('RODestroyableStaticMesh') && RODestroyableStaticMesh(Other).bWontStopBullets)
            {
                log("HE.ProcessTouch: exiting as hit destroyable SM but it doesn't stop bullets"); // TEMP
                return;
            }
            else if (Other.IsA('RODestroyableStaticMesh')) log("HE.ProcessTouch: exploding on destroyable SM"); // TEMP
            else log("HE.ProcessTouch: exploding on Pawn" @ Other.Tag @ "that is not an ROPawn"); // TEMP
        }
        // Otherwise we hit something we aren't going to damage
        else if (Role == ROLE_Authority && Instigator != none && Instigator.Controller != none && ROBot(Instigator.Controller) != none)
        {
            log("HE.ProcessTouch: exploding on Actor" @ Other.Tag @ "that is not a Pawn or destroyable SM???"); // TEMP
            ROBot(Instigator.Controller).NotifyIneffectiveAttack();
        }

        // Don't update the position any more and don't move the projectile any more
        bUpdateSimulatedPosition = false;
        SetPhysics(PHYS_none);
        SetDrawType(DT_none);

        Explode(HitLocation, vect(0.0,0.0,1.0));
        HurtWall = none;
    }
}

simulated singular function HitWall(vector HitNormal, actor Wall)
{

    local PlayerController PC;
    local float  HitAngle; //just a dummy

    if (Wall.Base != none && Wall.Base == instigator)
        return;

    HitAngle=1.57;

    if (bDebuggingText && Role == ROLE_Authority)
    {
        if (!bIsAlliedShell)
        {
            Level.Game.Broadcast(self, "Dist: "$(VSize(LaunchLocation-Location)/60.352)$" m, ImpactVel: "$VSize(Velocity) / 60.352$" m/s"); //, flight time = "$FlightTime$"s");
        }
        else
        {
            Level.Game.Broadcast(self, "Dist: "$(VSize(LaunchLocation-Location)/66.002)$" yards, ImpactVel: "$VSize(Velocity) / 18.395$" fps"); //, flight time = "$FlightTime$"s");
        }
    }

    if (Wall.IsA('DH_ROTreadCraft') && !DH_ROTreadCraft(Wall).DHShouldPenetrateAPC(Location, Normal(Velocity), GetPenetration(LaunchLocation-Location), HitAngle, ShellDiameter, ShellImpactDamage, bShatterProne))
    {
        if (Role == ROLE_Authority)
        {
            MakeNoise(1.0);
        }
        NonPenetrateExplode(Location + ExploWallOut * HitNormal, HitNormal);

        // Don't update the position any more and don't move the projectile any more.
        bUpdateSimulatedPosition=false;
        SetPhysics(PHYS_none);
        SetDrawType(DT_none);

        if ((ExplosionDecal != none) && (Level.NetMode != NM_DedicatedServer) )
        {
            if (ExplosionDecal.Default.CullDistance != 0)
            {
                PC = Level.GetLocalPlayerController();
                if (!PC.BeyondViewDistance(Location, ExplosionDecal.Default.CullDistance))
                    Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
                else if ((Instigator != none) && (PC == Instigator.Controller) && !PC.BeyondViewDistance(Location, 2*ExplosionDecal.Default.CullDistance))
                    Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
            }
            else
                Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
        }
        HurtWall = none;
        return;
    }

    if ((SavedHitActor == Wall) || (Wall.bDeleteMe))
        return;

    // Don't update the position any more and don't move the projectile any more.
    bUpdateSimulatedPosition=false;
    SetPhysics(PHYS_none);
    SetDrawType(DT_none);

    SavedHitActor = Pawn(Wall);


    if (Role == ROLE_Authority)
    {
        if ((!Wall.bStatic && !Wall.bWorldGeometry) || RODestroyableStaticMesh(Wall) != none || Mover(Wall) != none)
        {
            if (Instigator == none || Instigator.Controller == none)
                Wall.SetDelayedDamageInstigatorController(InstigatorController);

            if (savedhitactor != none || RODestroyableStaticMesh(Wall) != none || Mover(Wall) != none)
            {
                Wall.TakeDamage(ImpactDamage, instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage);
            }

            if (DamageRadius > 0 && Vehicle(Wall) != none && Vehicle(Wall).Health > 0)
                Vehicle(Wall).DriverRadiusDamage(Damage, DamageRadius, InstigatorController, MyDamageType, MomentumTransfer, Location);
            HurtWall = Wall;
        }
        MakeNoise(1.0);
    }
    Explode(Location + ExploWallOut * HitNormal, HitNormal);
    // We do this in the Explode logic
    if (!bCollided && (ExplosionDecal != none) && (Level.NetMode != NM_DedicatedServer) )
    {
        if (ExplosionDecal.Default.CullDistance != 0)
        {
            PC = Level.GetLocalPlayerController();
            if (!PC.BeyondViewDistance(Location, ExplosionDecal.Default.CullDistance))
                Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
            else if ((Instigator != none) && (PC == Instigator.Controller) && !PC.BeyondViewDistance(Location, 2*ExplosionDecal.Default.CullDistance))
                Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
        }
        else
            Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
    }
    HurtWall = none;
    //log(" Shell flew "$(VSize(LaunchLocation - Location)/60.352)$" meters total");
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    local vector TraceHitLocation, TraceHitNormal;
    local Material HitMaterial;
    local ESurfaceTypes ST;
    local bool bShowDecal, bSnowDecal;

    bPenetrated = true;

    if (SavedHitActor == none)
    {
       Trace(TraceHitLocation, TraceHitNormal, Location + vector(Rotation) * 16, Location, false,, HitMaterial);
    }

    DoShakeEffect();

    if (!bDidExplosionFX)
    {
        if (HitMaterial == none)
            ST = EST_Default;
        else
            ST = ESurfaceTypes(HitMaterial.SurfaceType);

        if (SavedHitActor != none)
        {
             PlaySound(VehicleHitSound,,5.5*TransientSoundVolume);
            if (EffectIsRelevant(Location,false))
            {
                Spawn(ShellHitVehicleEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
                if ((ExplosionDecal != none) && (Level.NetMode != NM_DedicatedServer))
                    Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
            }
        }
        else
        {
            PlaySound(DirtHitSound,,5.5*TransientSoundVolume);
            if (EffectIsRelevant(Location,false))
            {
                switch(ST)
                {
                    case EST_Snow:
                    case EST_Ice:
                        Spawn(ShellHitSnowEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
                        bShowDecal = true;
                        bSnowDecal = true;
                        break;
                    case EST_Rock:
                    case EST_Gravel:
                    case EST_Concrete:
                        Spawn(ShellHitRockEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
                        bShowDecal = true;
                        break;
                    case EST_Wood:
                    case EST_HollowWood:
                        Spawn(ShellHitWoodEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
                        bShowDecal = true;
                        break;
                    case EST_Water:
                        Spawn(ShellHitWaterEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
                        PlaySound(WaterHitSound,,5.5*TransientSoundVolume);
                        bShowDecal = false;
                        break;
                    default:
                        Spawn(ShellHitDirtEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
                        bShowDecal = true;
                        break;
                }

                if (bShowDecal && Level.NetMode != NM_DedicatedServer)
                {
                    if (bSnowDecal && ExplosionDecalSnow != none)
                    {
                        Spawn(ExplosionDecalSnow,self,,Location, rotator(-HitNormal));
                    }
                    else if (ExplosionDecal != none)
                    {
                        Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
                    }
                }
            }
        }
        PlaySound(ExplosionSound[Rand(4)],,5.5*TransientSoundVolume);

    }

    if (Corona != none)
        Corona.Destroy();

    super(ROAntiVehicleProjectile).Explode(HitLocation, HitNormal);
}

// HE Shell explosion for when it hit a tank but didn't penetrate
simulated function NonPenetrateExplode(vector HitLocation, vector HitNormal)
{
    if (bCollided)
        return;

    DoShakeEffect();

    if (!bDidExplosionFX)
    {
        PlaySound(VehicleDeflectSound,,5.5*TransientSoundVolume);
        if (EffectIsRelevant(Location,false))
        {
            Spawn(ShellDeflectEffectClass,,,HitLocation + HitNormal*16,rotator(HitNormal));
        }

        PlaySound(ExplosionSound[Rand(4)],,5.5*TransientSoundVolume);

        bDidExplosionFX=true;
    }

    if (Corona != none)
        Corona.Destroy();

    // Save the hit info for when the shell is destroyed
    SavedHitLocation = HitLocation;
    SavedHitNormal = HitNormal;
    AmbientSound=none;

    BlowUp(HitLocation);

    // Give the bullet a little time to play the hit effect client side before destroying the bullet
    if (Level.NetMode == NM_DedicatedServer)
    {
        bCollided = true;
        SetCollision(false,false);
    }
    else
    {
        Destroy();
    }
}

simulated function Destroyed()
{
    local vector TraceHitLocation, TraceHitNormal;
    local Material HitMaterial;
    local ESurfaceTypes ST;
    local bool bShowDecal, bSnowDecal;
    local ROPawn Victims;
    local float damageScale, dist;
    local vector dir, Start;

    // Move karma ragdolls around when this explodes
    if (Level.NetMode != NM_DedicatedServer)
    {
        Start = Location + 32 * vect(0,0,1);

        foreach VisibleCollidingActors(class 'ROPawn', Victims, DamageRadius, Start)
        {
            // don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
            if (Victims != self)
            {
                dir = Victims.Location - Start;
                dist = FMax(1,VSize(dir));
                dir = dir/dist;
                damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);

                if (Victims.Physics == PHYS_KarmaRagDoll)
                {
                    Victims.DeadExplosionKarma(MyDamageType, damageScale * MomentumTransfer * dir, damageScale);
                }
            }
        }
    }

    if (!bDidExplosionFX)
    {
        if (bPenetrated)
        {
            if (bDebugBallistics && DH_ROTankCannonPawn(Instigator) != none && ROTankCannon(DH_ROTankCannonPawn(Instigator).Gun) != none)
            {
                ROTankCannon(DH_ROTankCannonPawn(Instigator).Gun).HandleShellDebug(SavedHitLocation);
            }

            if (SavedHitActor == none)
            {
               Trace(TraceHitLocation, TraceHitNormal, Location + vector(Rotation) * 16, Location, false,, HitMaterial);
            }

            if (HitMaterial == none)
                ST = EST_Default;
            else
                ST = ESurfaceTypes(HitMaterial.SurfaceType);

            if (SavedHitActor != none)
            {
                PlaySound(VehicleHitSound,,5.5*TransientSoundVolume);

                if (EffectIsRelevant(SavedHitLocation,false))
                {
                    Spawn(ShellHitVehicleEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
                    if ((ExplosionDecal != none) && (Level.NetMode != NM_DedicatedServer))
                        Spawn(ExplosionDecal,self,,SavedHitLocation, rotator(-SavedHitNormal));
                }
            }
            else
            {
                PlaySound(DirtHitSound,,5.5*TransientSoundVolume);
                if (EffectIsRelevant(SavedHitLocation,false))
                {
                    switch(ST)
                    {
                        case EST_Snow:
                        case EST_Ice:
                            Spawn(ShellHitSnowEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
                            bShowDecal = true;
                            bSnowDecal = true;
                            break;
                        case EST_Rock:
                        case EST_Gravel:
                        case EST_Concrete:
                            Spawn(ShellHitRockEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
                            bShowDecal = true;
                            break;
                        case EST_Wood:
                        case EST_HollowWood:
                            Spawn(ShellHitWoodEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
                            bShowDecal = true;
                            break;
                        case EST_Water:
                            Spawn(ShellHitWaterEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
                            PlaySound(WaterHitSound,,5.5*TransientSoundVolume);
                            bShowDecal = false;
                            break;
                        default:
                            Spawn(ShellHitDirtEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
                            bShowDecal = true;
                            break;
                    }

                    if (bShowDecal && Level.NetMode != NM_DedicatedServer)
                    {
                        if (bSnowDecal && ExplosionDecalSnow != none)
                        {
                            Spawn(ExplosionDecalSnow,self,,SavedHitLocation, rotator(-SavedHitNormal));
                        }
                        else if (ExplosionDecal != none)
                        {
                            Spawn(ExplosionDecal,self,,SavedHitLocation, rotator(-SavedHitNormal));
                        }
                    }
                }
            }
            PlaySound(ExplosionSound[Rand(4)],,5.5*TransientSoundVolume);
        }
        else
        {
            PlaySound(VehicleDeflectSound,,5.5*TransientSoundVolume);
            if (EffectIsRelevant(Location,false))
            {
                Spawn(ShellDeflectEffectClass,,,SavedHitLocation + SavedHitNormal*16,rotator(SavedHitNormal));
            }

            PlaySound(ExplosionSound[Rand(4)],,5.5*TransientSoundVolume);
        }
    }

    if (Corona != none)
        Corona.Destroy();

    // Don't want to spawn the effect on the super
    super(ROAntiVehicleProjectile).Destroyed();
}



//-----------------------------------------------------------------------------
// PhysicsVolumeChange - Blow up HE rounds when they hit water
//-----------------------------------------------------------------------------
simulated function PhysicsVolumeChange(PhysicsVolume Volume)
{
    if (Volume.bWaterVolume)
    {
        Explode(Location, vector(Rotation * -1));
    }
}

defaultproperties
{
     ExplosionSound(0)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode01'
     ExplosionSound(1)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode02'
     ExplosionSound(2)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode03'
     ExplosionSound(3)=SoundGroup'ProjectileSounds.cannon_rounds.OUT_HE_explode04'
     bHasTracer=false
     ShakeRotMag=(Y=0.000000)
     ShakeRotRate=(Z=2500.000000)
     BlurTime=6.000000
     BlurEffectScalar=2.200000
     PenetrationMag=300.000000
     VehicleDeflectSound=SoundGroup'ProjectileSounds.cannon_rounds.HE_deflect'
     ShellHitVehicleEffectClass=class'ROEffects.TankHEHitPenetrate'
     ShellDeflectEffectClass=class'ROEffects.TankHEHitDeflect'
     ShellHitDirtEffectClass=class'DH_Effects.DH_TankMediumHEHitEffect'
     ShellHitSnowEffectClass=class'DH_Effects.DH_TankMediumHEHitEffect'
     ShellHitWoodEffectClass=class'DH_Effects.DH_TankMediumHEHitEffect'
     ShellHitRockEffectClass=class'DH_Effects.DH_TankMediumHEHitEffect'
     ShellHitWaterEffectClass=class'DH_Effects.DH_TankMediumHEHitEffect'
     DamageRadius=300.000000
     MyDamageType=class'DH_HECannonShellDamage'
     ExplosionDecal=class'ROEffects.ArtilleryMarkDirt'
     ExplosionDecalSnow=class'ROEffects.ArtilleryMarkSnow'
     LifeSpan=10.000000
     SoundRadius=1000.000000
}
