//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PIATFire extends DH_ProjectileFire;

var     name        FireIronAnimOne;    // Iron Fire animation for range setting one
var     name        FireIronAnimTwo;    // Iron Fire animation for range setting two
var     name        FireIronAnimThree;  // Iron Fire animation for range setting three


event ModeDoFire()
{
    if (!Weapon.bUsingSights)
        return;

    if (!Instigator.bIsCrawling && !Instigator.bRestingWeapon)
        return;

    if (Level.NetMode != NM_DedicatedServer)
    {
        if (DH_PIATWeapon(Owner).RocketAttachment  != none)
        {
            DH_PIATWeapon(Owner).RocketAttachment.Destroy();
        }
    }

    Super.ModeDoFire();

//  DH_PIATWeapon(Weapon).PostFire();
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
                switch(DH_PIATWeapon(Weapon).RangeIndex)
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

simulated function InitEffects()
{
}

defaultproperties
{
     FireIronAnimOne="iron_shoot"
     FireIronAnimTwo="iron_shootMid"
     FireIronAnimThree="iron_shootFar"
     ProjSpawnOffset=(X=25.000000)
     FAProjSpawnOffset=(X=-25.000000)
     bUsePreLaunchTrace=false
     FireIronAnim="iron_shoot"
     MuzzleBone="Warhead"
     FireSounds(0)=SoundGroup'DH_WeaponSounds.PIAT.PIAT_Fire01'
     maxVerticalRecoilAngle=2500
     maxHorizontalRecoilAngle=1000
     bWaitForRelease=true
     FireAnim="shoothip"
     TweenTime=0.000000
     FireForce="RocketLauncherFire"
     FireRate=2.600000
     AmmoClass=Class'DH_ATWeapons.DH_PIATAmmo'
     ShakeRotMag=(X=100.000000,Y=100.000000,Z=800.000000)
     ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
     ShakeRotTime=7.000000
     ShakeOffsetMag=(X=6.000000,Y=2.000000,Z=10.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=4.000000
     ProjectileClass=Class'DH_ATWeapons.DH_PIATRocket'
     BotRefireRate=0.500000
     WarnTargetPct=0.900000
     aimerror=1200.000000
     Spread=490.000000
     SpreadStyle=SS_Random
}
