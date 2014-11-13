//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PanzerFaustFire extends ROProjectileFire;

var     float       ExhaustDamage;          // Damage caused by exhaust (back blast)
var     float       ExhaustDamageRadius;    // Radius for damage caused by exhaust
var     float       ExhaustMomentumTransfer;   // Momentum from exhaust to inflict on players
var     class<DamageType>     ExhaustDamageType;    // Damage type for exhaust

var     name        FireIronAnimOne;    // Iron Fire animation for range setting one
var     name        FireIronAnimTwo;    // Iron Fire animation for range setting two
var     name        FireIronAnimThree;  // Iron Fire animation for range setting three

event ModeDoFire()
{
    local vector WeapLoc;
    local rotator WeapRot;
    local vector HitLoc, HitNorm, FlameDir, FlameReflectDir;
    local float FlameLen;
    local Actor Other;
    local RODestroyableStaticMesh DestroMesh;

    if (Level.NetMode != NM_DedicatedServer)
    {
        if (RORocketWeapon(Owner).RocketAttachment  != none)
           RORocketWeapon(Owner).RocketAttachment.Destroy();
    }

    super.ModeDoFire();

    WeapLoc=Weapon.ThirdPersonActor.Location; // Get the location of the panzerfaust
    WeapRot=Weapon.ThirdPersonActor.Rotation; // Get the rotation of the panzerfaust
    FlameDir = vector(WeapRot); // Set direction of exhaust

    Other = Trace(HitLoc, HitNorm, WeapLoc - FlameDir * 300, WeapLoc, false);
    DestroMesh = RODestroyableStaticMesh(Other);

    // Check if the firer is too close to an object and if so, simulate exhaust spreading out along, and reflecting from, the wall
    // Do not reflect off players or breakable objects like windows
    if (Other != none && DH_Pawn(Other) == none && DestroMesh == none)
    {
        FlameLen = VSize(HitLoc - WeapLoc); // Exhaust stream length when it hit an object
        FlameReflectDir = 2 * (HitNorm * FlameDir) * HitNorm - FlameDir; // vector back towards firer from hit object

        if (FlameLen < 200)
        {
            Weapon.HurtRadius(ExhaustDamage, ExhaustDamageRadius * 3, ExhaustDamageType, ExhaustMomentumTransfer, HitLoc + FlameReflectDir * FlameLen / 2);
        }
    }
    else
        FlameLen = 400; // Didn't hit anything, so exhaust is max length

    if (FlameLen > 100)
    {
        Weapon.HurtRadius(ExhaustDamage, ExhaustDamageRadius, ExhaustDamageType, ExhaustMomentumTransfer, WeapLoc - FlameDir * 100);
    }

    if (FlameLen > 200)
    {
        Weapon.HurtRadius(ExhaustDamage / 2, ExhaustDamageRadius * 2, ExhaustDamageType, ExhaustMomentumTransfer, WeapLoc - FlameDir * 200);
    }

    if (FlameLen > 400)
    {
        Weapon.HurtRadius(ExhaustDamage / 3, ExhaustDamageRadius * 3, ExhaustDamageType, ExhaustMomentumTransfer, WeapLoc - FlameDir * 200);
    }

    DH_PanzerFaustWeapon(Weapon).PostFire();
}

function PlayFiring()
{
    local name Anim;

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
                switch(DH_PanzerFaustWeapon(Weapon).RangeIndex)
                {
                    case 0:
                        Anim = FireIronAnimOne;
                        break;
                    case 1:
                        Anim = FireIronAnimTwo;
                        break;
                    case 2:
                        Anim = FireIronAnimThree;
                        break;
                }
                Weapon.PlayAnim(Anim, FireAnimRate, FireTweenTime);
            }
            else
            {
                Weapon.PlayAnim(FireAnim, FireAnimRate, FireTweenTime);
            }
        }
    }

    Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)],SLOT_none,FireVolume,,,,false);

    ClientPlayForceFeedback(FireForce);  // jdf

    FireCount++;
}

defaultproperties
{
     ExhaustDamage=200.000000
     ExhaustDamageRadius=50.000000
     ExhaustMomentumTransfer=100.000000
     ExhaustDamageType=class'DH_ATWeapons.DH_PanzerfaustExhaustDamType'
     FireIronAnimOne="shoot30"
     FireIronAnimTwo="shoot"
     FireIronAnimThree="shoot90"
     ProjSpawnOffset=(X=25.000000)
     FAProjSpawnOffset=(X=-25.000000)
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
     TweenTime=0.000000
     FireForce="RocketLauncherFire"
     FireRate=2.600000
     AmmoClass=class'DH_ATWeapons.DH_PanzerFaustAmmo'
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=500.000000)
     ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=7500.000000)
     ShakeRotTime=6.000000
     ShakeOffsetMag=(X=3.000000,Y=1.000000,Z=5.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.000000
     ProjectileClass=class'DH_ATWeapons.DH_PanzerFaustRocket'
     BotRefireRate=0.500000
     WarnTargetPct=0.900000
     SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
     aimerror=1200.000000
     Spread=550.000000
     SpreadStyle=SS_Random
}
