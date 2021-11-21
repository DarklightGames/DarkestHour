//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHWeaponFire extends ROWeaponFire;

var bool bIgnoresWeaponLock;

var     class<DHShellEject1st>          ShellCaseEjectClass; //converting the shell ejection system to emitter-based
var     DHShellEject1st                 ShellEject1st;

var vector MuzzleOffset;

//variables to allow customization of shell behaviour
var vector  ShellEjectOffset;
var rotator ShellEjectRotate;
var float   ShellVelMinX;
var float   ShellVelMaxX;
var float   ShellVelMinY;
var float   ShellVelMaxY;
var float   ShellVelMinZ;
var float   ShellVelMaxZ;

function DoShellEject()
{
    if (ShellEject1st != None)
        ShellEject1st.Trigger(Weapon, Instigator);
}

// Overriden to support our recoil system
event ModeDoFire()
{
    if (!AllowFire())
        return;

    if (MaxHoldTime > 0.0)
        HoldTime = FMin(HoldTime, MaxHoldTime);

    // server
    if (Weapon.Role == ROLE_Authority)
    {
        Weapon.ConsumeAmmo(ThisModeNum, Load);
        DoFireEffect();
        HoldTime = 0;   // if bot decides to stop firing, HoldTime must be reset first
        if ( (Instigator == None) || (Instigator.Controller == None) )
            return;

        if ( AIController(Instigator.Controller) != None )
            AIController(Instigator.Controller).WeaponFireAgain(BotRefireRate, true);

        Instigator.DeactivateSpawnProtection();
    }

    // client
    if (Instigator.IsLocallyControlled())
    {
        if( !bDelayedRecoil )
            HandleRecoil();
        else
            SetTimer(DelayedRecoilTime, False);

        ShakeView();
        PlayFiring();

        if( !bMeleeMode )
        {
            if(Instigator.IsFirstPerson() && !bAnimNotifiedShellEjects)
            {
                DoShellEject();
            }

            FlashMuzzleFlash();
            StartMuzzleSmoke();
        }
    }
    else // server
    {
        ServerPlayFiring();
    }

    Weapon.IncrementFlashCount(ThisModeNum);

    // set the next firing time. must be careful here so client and server do not get out of sync
    if (bFireOnRelease)
    {
        if (bIsFiring)
            NextFireTime += MaxHoldTime + FireRate;
        else
            NextFireTime = Level.TimeSeconds + FireRate;
    }
    else
    {
        NextFireTime += FireRate;
        NextFireTime = FMax(NextFireTime, Level.TimeSeconds);
    }

    Load = AmmoPerFire;
    HoldTime = 0;

    if (Instigator.PendingWeapon != Weapon && Instigator.PendingWeapon != None)
    {
        bIsFiring = false;
        Weapon.PutDown();
    }
}

simulated function InitEffects()
{

    if (Level.NetMode == NM_DedicatedServer || AIController(Instigator.Controller) != none)
    {
        return;
    }

    if (FlashEmitterClass != none && (FlashEmitter == none || FlashEmitter.bDeleteMe))
    {
        FlashEmitter = Weapon.Spawn(FlashEmitterClass);

        if (FlashEmitter != none && MuzzleBone != '')
        {
            Weapon.AttachToBone(FlashEmitter, MuzzleBone);
            FlashEmitter.SetRelativeLocation(MuzzleOffset);
        }
    }

    if (SmokeEmitterClass != none && (SmokeEmitter == none || SmokeEmitter.bDeleteMe))
    {
        SmokeEmitter = Weapon.Spawn(SmokeEmitterClass, Instigator);

        if (SmokeEmitter != None && MuzzleBone != '')
        {
            Weapon.AttachToBone(SmokeEmitter, MuzzleBone);
            SmokeEmitter.SetRelativeLocation(MuzzleOffset);
        }
    }
}

defaultproperties
{
    SpreadStyle=SS_Random // this is actually assumed & hard-coded into spread functionality
}
