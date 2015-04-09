//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

// Matt: originally extended ROProjectileFire, but this is the only DH weapon to do so - the minor changes in DH_ProjectileFire won't affect a faust, so changed to DH version for uniformity
class DH_PanzerFaustFire extends DH_ProjectileFire;

var float               ExhaustDamage;           // damage caused by exhaust (back blast)
var float               ExhaustDamageRadius;     // radius for damage caused by exhaust
var float               ExhaustMomentumTransfer; // momentum from exhaust to inflict on players
var class<DamageType>   ExhaustDamageType;       // damage type for exhaust

var array<name>         FireIronAnims;

event ModeDoFire()
{
    local rotator WeapRot;
    local vector WeapLoc, HitLoc, HitNorm, FlameDir, FlameReflectDir;
    local float FlameLen;
    local Actor Other;
    local RODestroyableStaticMesh DestroMesh;
    local RORocketWeapon RW;

    RW = RORocketWeapon(Owner);

    if (Level.NetMode != NM_DedicatedServer &&
        RW != none &&
        RW.RocketAttachment != none)
    {
        RW.RocketAttachment.Destroy();
    }

    super.ModeDoFire();

    WeapLoc = Weapon.ThirdPersonActor.Location;
    WeapRot = Weapon.ThirdPersonActor.Rotation;
    FlameDir = vector(WeapRot);

    Other = Trace(HitLoc, HitNorm, WeapLoc - (FlameDir * 300.0), WeapLoc, false);
    DestroMesh = RODestroyableStaticMesh(Other);

    // Check if the firer is too close to an object and if so, simulate exhaust spreading out along, and reflecting from, the wall
    // Do not reflect off players or breakable objects like windows
    if (Other != none && DestroMesh == none && DHPawn(Other) == none)
    {
        FlameLen = VSize(HitLoc - WeapLoc); // exhaust stream length when it hit an object
        FlameReflectDir = 2.0 * (HitNorm * FlameDir) * HitNorm - FlameDir; // vector back towards firer from hit object

        if (FlameLen < 200.0)
        {
            Weapon.HurtRadius(ExhaustDamage, ExhaustDamageRadius * 3.0, ExhaustDamageType, ExhaustMomentumTransfer, HitLoc + FlameReflectDir * FlameLen / 2.0);
        }
    }
    else
    {
        FlameLen = 400.0; // Didn't hit anything, so exhaust is max length
    }

    if (FlameLen > 100.0)
    {
        Weapon.HurtRadius(ExhaustDamage, ExhaustDamageRadius, ExhaustDamageType, ExhaustMomentumTransfer, WeapLoc - FlameDir * 100.0);
    }

    if (FlameLen > 200.0)
    {
        Weapon.HurtRadius(ExhaustDamage / 2.0, ExhaustDamageRadius * 2.0, ExhaustDamageType, ExhaustMomentumTransfer, WeapLoc - FlameDir * 200.0);
    }

    if (FlameLen > 400.0)
    {
        Weapon.HurtRadius(ExhaustDamage / 3.0, ExhaustDamageRadius * 3.0, ExhaustDamageType, ExhaustMomentumTransfer, WeapLoc - FlameDir * 200.0);
    }

    Weapon.PostFire();
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
                Weapon.PlayAnim(FireIronAnims[DH_PanzerFaustWeapon(Weapon).RangeIndex], FireAnimRate, FireTweenTime);
            }
            else
            {
                Weapon.PlayAnim(FireAnim, FireAnimRate, FireTweenTime);
            }
        }
    }

    Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)], SLOT_None, FireVolume,,,, false);

    ClientPlayForceFeedback(FireForce);

    ++FireCount;
}

defaultproperties
{
    ExhaustDamage=200.0
    ExhaustDamageRadius=50.0
    ExhaustMomentumTransfer=100.0
    ExhaustDamageType=class'DH_ATWeapons.DH_PanzerfaustExhaustDamType'
    FireIronAnims(0)="shoot30"
    FireIronAnims(1)="shoot"
    FireIronAnims(2)="shoot90"
    ProjSpawnOffset=(X=25.0)
    FAProjSpawnOffset=(X=-25.0)
    bUsePreLaunchTrace=false
    FireIronAnim="shoot"
    MuzzleBone="Warhead"
    FireSounds(0)=SoundGroup'Inf_Weapons.panzerfaust60.panzerfaust60_fire01'
    FireSounds(1)=SoundGroup'Inf_Weapons.panzerfaust60.panzerfaust60_fire02'
    FireSounds(2)=SoundGroup'Inf_Weapons.panzerfaust60.panzerfaust60_fire03'
    maxVerticalRecoilAngle=1000
    maxHorizontalRecoilAngle=600
    bWaitForRelease=true
    FireAnim="shoothip"
    TweenTime=0.0
    FireForce="RocketLauncherFire"
    FireRate=2.6
    AmmoClass=class'DH_ATWeapons.DH_PanzerFaustAmmo'
    ShakeRotMag=(X=50.0,Y=50.0,Z=500.0)
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=7500.0)
    ShakeRotTime=6.0
    ShakeOffsetMag=(X=3.0,Y=1.0,Z=5.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ProjectileClass=class'DH_ATWeapons.DH_PanzerFaustRocket'
    BotRefireRate=0.5
    WarnTargetPct=0.9
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    AimError=1200.0
    Spread=550.0
    SpreadStyle=SS_Random
}
