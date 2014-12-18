//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ROTankCannonShellHE extends DH_ROTankCannonShell;


// Modified to to add different effects if didn't penetrate armor, to add an explosion sound and to move karma ragdolls around when HE round explodes (Matt: moved here from Destroyed)
simulated function SpawnExplosionEffects(vector HitLocation, vector HitNormal, optional float ActualLocationAdjustment)
{
    local vector  Start, Direction, TraceHitLocation, TraceHitNormal;
    local float   DamageScale, Distance;
    local ROPawn  Victims;

    // Effects if failed to penetrate vehicle
    if (bFailedToPenetrateArmor)
    {
        PlaySound(VehicleDeflectSound, , 5.5 * TransientSoundVolume);

        if (EffectIsRelevant(HitLocation, false))
        {
            Spawn(ShellDeflectEffectClass, , , HitLocation + HitNormal * 16.0, rotator(HitNormal));
        }
    }
    // Otherwise the normal explosion effects
    else
    {
        super.SpawnExplosionEffects(HitLocation, HitNormal, ActualLocationAdjustment);
    }

    // Always play explosion sound for HE
    PlaySound(ExplosionSound[Rand(4)], , 5.5 * TransientSoundVolume);

    // Move karma ragdolls around when this explodes
    if (Level.NetMode != NM_DedicatedServer)
    {
        Start = SavedHitLocation + vect(0.0,0.0,32.0); // Matt: changed from Location to SavedHitLocation

        foreach VisibleCollidingActors(class 'ROPawn', Victims, DamageRadius, Start)
        {
            // Don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
            if (Victims.Physics == PHYS_KarmaRagDoll && Victims != self)
            {
                Direction = Victims.Location - Start;
                Distance = FMax(1.0, VSize(Direction));
                Direction = Direction / Distance;
                DamageScale = 1.0 - FMax(0.0, (Distance - Victims.CollisionRadius) / DamageRadius);

                Victims.DeadExplosionKarma(MyDamageType, DamageScale * MomentumTransfer * Direction, DamageScale);
            }
        }
    }
}

simulated function DELETEProcessTouch(Actor Other, vector HitLocation)
{
    local ROVehicle       HitVehicle;
    local ROVehicleWeapon HitVehicleWeapon;
    local vector          TempHitLocation, HitNormal, SavedVelocity;
    local array<int>      HitPoints;
    local float           TouchAngle; // dummy variable passed to DHShouldPenetrate function (does not need a value setting)

    if (bDebuggingText) Log("HE.ProcessTouch called: Other =" @ Other.Tag @ " SavedTouchActor =" @ SavedTouchActor @ " SavedHitActor =" @ SavedHitActor); // TEMP
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
                if (ShouldDrawDebugLines())
                {
                    DrawStayingDebugLine(Location, Location - (Normal(Velocity) * 500.0), 255, 0, 0);
                }

                if (bDebuggingText) Log("HE.ProcessTouch: hit driver, authority should damage him & shell continue"); // TEMP
                if (Role == ROLE_Authority && VehicleWeaponPawn(HitVehicleWeapon.Owner) != none && VehicleWeaponPawn(HitVehicleWeapon.Owner).Driver != none)
                {
                    VehicleWeaponPawn(HitVehicleWeapon.Owner).Driver.TakeDamage(ImpactDamage, Instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage);
                }

                Velocity *= 0.8; // hitting the Driver's body doesn't cause shell to explode, but we'll slow it down a bit
            }
            else
            {
                if (bDebuggingText) Log("HE.ProcessTouch: hit driver area but not driver, shell should continue"); // TEMP
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
        if (HitVehicleWeapon.IsA('DH_ROTankCannon') && !DH_ROTankCannon(HitVehicleWeapon).DHShouldPenetrate(Class, HitLocation, Normal(Velocity), GetPenetration(LaunchLocation - HitLocation)))
        {
            if (ShouldDrawDebugLines())
            {
                DrawStayingDebugLine(Location, Location - (Normal(Velocity) * 500.0), 0, 255, 0);
            }

            if (bDebuggingText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "HE/Smoke failed to penetrate turret!");
            }

            // Don't update the position any more and don't move the projectile any more
            bUpdateSimulatedPosition = false;
            SetPhysics(PHYS_None);
            SetDrawType(DT_None);

            HurtWall = none;

            return;            
        }

        // Don't update the position any more and don't move the projectile any more
        bUpdateSimulatedPosition = false;
        SavedVelocity = Velocity; // PHYS_None zeroes Velocity, so we have to save it
        SetPhysics(PHYS_None);
        SetDrawType(DT_None);

        if (ShouldDrawDebugLines())
        {
            DrawStayingDebugLine(Location, Location - (Normal(SavedVelocity) * 500.0), 255, 0, 0);
        }

        if (Role == ROLE_Authority)
        {
            // Matt: removed as SetDDI is irrelevant to VehWeapon (empty function) & for Vehicle we'll let the VehWeapon call SetDDI on the Vehicle only if it's calling TakeDamage on it
//          if (ShellImpactDamage.default.bDelayedDamage && Instigator == none || Instigator.Controller == none)
//          {
//              HitVehicleWeapon.SetDelayedDamageInstigatorController(InstigatorController);
//              HitVehicle.SetDelayedDamageInstigatorController(InstigatorController);
//          }

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
            Other = HitPointTrace(TempHitLocation, HitNormal, HitLocation + (65535.0 * Normal(Velocity)), HitPoints, HitLocation,, 0);

            // We hit one of the body's hit points, so register a hit on the soldier
            if (Other != none)
            {
                if (bDebuggingText) Log("HE.ProcessTouch: successful HitPointTrace on ROPawn, authority calling ProcessLocationalDamage on it"); // TEMP
                if (Role == ROLE_Authority)
                {
                    ROPawn(Other).ProcessLocationalDamage(ImpactDamage, Instigator, Location, MomentumTransfer * Normal(Velocity), ShellImpactDamage, HitPoints);
                }

                Velocity *= 0.8; // hitting a body doesn't cause shell to explode, but we'll slow it down a bit
            }
            else if (bDebuggingText) Log("HE.ProcessTouch: unsuccessful HitPointTrace on ROPawn, doing nothing"); // TEMP

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
                if (bDebuggingText) Log("HE.ProcessTouch: exiting as hit destroyable SM but it doesn't stop bullets"); // TEMP
                return;
            }
            else if (bDebuggingText && Other.IsA('RODestroyableStaticMesh')) Log("HE.ProcessTouch: exploding on destroyable SM"); // TEMP
            else if (bDebuggingText) Log("HE.ProcessTouch: exploding on Pawn" @ Other.Tag @ "that is not an ROPawn"); // TEMP
        }
        // Otherwise we hit something we aren't going to damage
        else if (Role == ROLE_Authority && Instigator != none && Instigator.Controller != none && ROBot(Instigator.Controller) != none)
        {
            if (bDebuggingText) Log("HE.ProcessTouch: exploding on Actor" @ Other.Tag @ "that is not a Pawn or destroyable SM???"); // TEMP
            ROBot(Instigator.Controller).NotifyIneffectiveAttack();
        }

        // Don't update the position any more and don't move the projectile any more
        bUpdateSimulatedPosition = false;
        SetPhysics(PHYS_None);
        SetDrawType(DT_None);

        Explode(HitLocation, vect(0.0,0.0,1.0));
        HurtWall = none;
    }
}

defaultproperties
{
    RoundType=RT_HE
    bExplodesOnArmor=true
    bExplodesOnHittingWater=true
    bAlwaysDoShakeEffect=true
    bBotNotifyIneffective=false
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
    DirtHitSound=none // so don't play in SpawnExplosionEffects, as will be drowned out by ExplosionSound
    RockHitSound=none
    WoodHitSound=none
    WaterHitSound=none
    DamageRadius=300.000000
    MyDamageType=class'DH_HECannonShellDamage'
    ExplosionDecal=class'ROEffects.ArtilleryMarkDirt'
    ExplosionDecalSnow=class'ROEffects.ArtilleryMarkSnow'
    LifeSpan=10.000000
    SoundRadius=1000.000000
}
