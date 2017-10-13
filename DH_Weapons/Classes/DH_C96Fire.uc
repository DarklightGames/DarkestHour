//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
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
    ProjectileClass=class'DH_Weapons.DH_C96Bullet'
    AmmoClass=class'DH_Weapons.DH_C96Ammo'
    FireRate=0.066666
    Spread=400.0
    RecoilRate=0.05
    MaxVerticalRecoilAngle=600
    MaxHorizontalRecoilAngle=75

    AmbientFireSound=SoundGroup'DH_WeaponSounds.c96.C96_FireLoop01'
    FireSounds(0)=SoundGroup'DH_WeaponSounds.c96.C96_FireSingle01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.c96.C96_FireSingle02'
    FireEndSound=SoundGroup'DH_WeaponSounds.c96.C96_FireEnd01'
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPistol'
    ShellEjectClass=class'ROAmmo.ShellEject1st9x19mm'
    ShellRotOffsetIron=(Pitch=5000)
    // TODO: in semi-auto fire mode the ejected 1st person shells eject the wrong way (to the left, instead of to the right as for auto fire or when using ironsights
}
