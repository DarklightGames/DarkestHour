//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_C96Fire extends DHFastAutoFire;

// Overridden here to allow semi auto fire sound handling for a FastAuto weapon class
// This is an extremely messy & inefficient way of doing this, however it works - Ch!cken
state FireLoop
{
    function BeginState()
    {
        local DHProjectileWeapon RPW;

        if (ROWeapon(Weapon).UsingAutoFire())
        {
            NextFireTime = Level.TimeSeconds - 0.1; // fire now!

            RPW = DHProjectileWeapon(Weapon);

            if (!RPW.bUsingSights && !Instigator.bBipodDeployed)
            {
                Weapon.LoopAnim(FireLoopAnim, LoopFireAnimRate, TweenTime);
            }
            else
            {
                Weapon.LoopAnim(FireIronLoopAnim, IronLoopFireAnimRate, TweenTime);
            }

            PlayAmbientSound(AmbientFireSound);
        }
    }

    function ServerPlayFiring()
    {
        if (!ROWeapon(Weapon).UsingAutoFire())
        {
            Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)], SLOT_None, FireVolume,,,, false);
        }
    }

    function PlayFiring()
    {
        if (!ROWeapon(Weapon).UsingAutoFire())
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

                Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)], SLOT_None, FireVolume,,,, false);

                ClientPlayForceFeedback(FireForce);

                FireCount++;
            }
        }
    }

    function PlayFireEnd()
    {
        if (!ROWeapon(Weapon).UsingAutoFire())
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
    }

    function EndState()
    {
        if (ROWeapon(Weapon).UsingAutoFire())
        {
            Weapon.AnimStopLooping();
            PlayAmbientSound(none);
            Weapon.PlayOwnedSound(FireEndSound, SLOT_None, FireVolume,, AmbientFireSoundRadius);
            Weapon.StopFire(ThisModeNum);

            // If we are not switching weapons, go to the idle state
            if (!Weapon.IsInState('LoweringWeapon'))
            {
                ROWeapon(Weapon).GotoState('Idle');
            }
        }
    }

    function StopFiring()
    {
        if (Level.NetMode == NM_DedicatedServer && HiROFWeaponAttachment.bUnReplicatedShot)
        {
            HiROFWeaponAttachment.SavedDualShot.FirstShot = HiROFWeaponAttachment.LastShot;

            if (HiROFWeaponAttachment.DualShotCount == 255)
            {
                HiROFWeaponAttachment.DualShotCount = 254;
            }
            else
            {
                HiROFWeaponAttachment.DualShotCount = 255;
            }

            HiROFWeaponAttachment.NetUpdateTime = Level.TimeSeconds - 1.0;
        }

        GotoState('');
    }

    function ModeTick(float DeltaTime)
    {
        super.ModeTick(DeltaTime);

        // WeaponTODO: see how to properly reimplement this
        if (!bIsFiring || ROWeapon(Weapon).IsBusy() || !AllowFire() || (DHMGWeapon(Weapon) != none && DHMGWeapon(Weapon).bBarrelFailed))  // stopped firing, magazine empty or barrel overheat
        {
            GotoState('');
        }
    }
}

defaultproperties
{
    FireEndSound=SoundGroup'DH_WeaponSounds.c96.C96_FireEnd01'
    AmbientFireSoundRadius=750.0
    AmbientFireSound=SoundGroup'DH_WeaponSounds.c96.C96_FireLoop01'
    AmbientFireVolume=255
    ProjSpawnOffset=(X=25.0)
    FAProjSpawnOffset=(X=-20.0)
    FireIronAnim="Iron_Shoot_Loop"
    FireIronLoopAnim="Iron_Shoot_Loop"
    FireIronEndAnim="Iron_Shoot_End"
    FireSounds(0)=SoundGroup'DH_WeaponSounds.c96.C96_FireSingle01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.c96.C96_FireSingle02'
    MaxVerticalRecoilAngle=600
    MaxHorizontalRecoilAngle=75
    RecoilRate=0.05
    ShellEjectClass=class'ROAmmo.ShellEject1st9x19mm'
    ShellRotOffsetIron=(Pitch=5000)
    PreFireAnim="Shoot1_start"
    FireAnim="Shoot_Loop"
    FireLoopAnim="Shoot_Loop"
    FireEndAnim="Shoot_End"
    TweenTime=0.0
    FireRate=0.066666
    AmmoClass=class'DH_Weapons.DH_C96Ammo'
    ShakeRotMag=(X=50.0,Y=50.0,Z=150.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=0.5
    ShakeOffsetMag=(X=3.0,Y=1.0,Z=3.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ProjectileClass=class'DH_Weapons.DH_C96Bullet'
    BotRefireRate=0.99
    WarnTargetPct=0.9
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPistol'
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    AimError=1200.0
    Spread=400.0
    SpreadStyle=SS_Random
}
