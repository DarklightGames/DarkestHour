//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_PIATFire extends DH_ProjectileFire;

var array<name> FireIronAnims;

event ModeDoFire()
{
    if (!Weapon.bUsingSights)
    {
        return;
    }

    if (!Instigator.bIsCrawling && !Instigator.bRestingWeapon)
    {
        return;
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        if (DH_PIATWeapon(Owner).RocketAttachment  != none)
        {
            DH_PIATWeapon(Owner).RocketAttachment.Destroy();
        }
    }

    super.ModeDoFire();
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
                Weapon.PlayAnim(FireIronAnims[DH_PIATWeapon(Weapon).RangeIndex], FireAnimRate, FireTweenTime);
            }
            else
            {
                Weapon.PlayAnim(FireAnim, FireAnimRate, FireTweenTime);
            }
        }
    }

    Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)], SLOT_None, FireVolume,,,, false);

    ClientPlayForceFeedback(FireForce);

    FireCount++;
}

simulated function InitEffects()
{
}

defaultproperties
{
    FireIronAnims(0)="iron_shoot"
    FireIronAnims(1)="iron_shootMid"
    FireIronAnims(2)="iron_shootFar"
    ProjSpawnOffset=(X=25.0)
    FAProjSpawnOffset=(X=-25.0)
    bUsePreLaunchTrace=false
    FireIronAnim="iron_shoot"
    MuzzleBone="Warhead"
    FireSounds(0)=SoundGroup'DH_WeaponSounds.PIAT.PIAT_Fire01'
    maxVerticalRecoilAngle=2500
    maxHorizontalRecoilAngle=1000
    bWaitForRelease=true
    FireAnim="shoothip"
    TweenTime=0.0
    FireForce="RocketLauncherFire"
    FireRate=2.6
    AmmoClass=class'DH_ATWeapons.DH_PIATAmmo'
    ShakeRotMag=(X=100.0,Y=100.0,Z=800.0)
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=12500.0)
    ShakeRotTime=7.0
    ShakeOffsetMag=(X=6.0,Y=2.0,Z=10.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=4.0
    ProjectileClass=class'DH_ATWeapons.DH_PIATRocket'
    BotRefireRate=0.5
    WarnTargetPct=0.9
    AimError=1200.0
    Spread=490.0
    SpreadStyle=SS_Random
}
