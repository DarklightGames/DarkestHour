//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ROTankCannonShellHE extends DH_ROTankCannonShell;


// Modified to to add different effects if didn't penetrate armor, to add an explosion sound and to move karma ragdolls around when HE round explodes (Matt: moved here from Destroyed)
simulated function SpawnExplosionEffects(vector HitLocation, vector HitNormal, optional float ActualLocationAdjustment)
{
    local vector  Start, Direction;
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
        Start = SavedHitLocation + vect(0.0, 0.0, 32.0); // Matt: changed from Location to SavedHitLocation

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
    ShakeRotMag=(Y=0.0)
    ShakeRotRate=(Z=2500.0)
    BlurTime=6.0
    BlurEffectScalar=2.2
    PenetrationMag=300.0
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
    DamageRadius=300.0
    MyDamageType=class'DH_HECannonShellDamage'
    ExplosionDecal=class'ROEffects.ArtilleryMarkDirt'
    ExplosionDecalSnow=class'ROEffects.ArtilleryMarkSnow'
    SoundRadius=1000.000000
    LifeSpan=10.0
}
