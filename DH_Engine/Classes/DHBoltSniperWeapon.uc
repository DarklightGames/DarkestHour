//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHBoltSniperWeapon extends DHSniperWeapon
    abstract;

enum EReloadState
{
    RS_None,
    RS_PreReload,
    RS_ReloadLooped,
    RS_PostReload,
};

var     EReloadState    ReloadState;

var     bool            bInterruptReload;   // stop reload part way through?

var     name            PreReloadAnim;      // anim for opening the bolt
var     name            SingleReloadAnim;   // anim inserting single bullets
var     name            PostReloadAnim;     // anim for closing the bolt

var     byte            NumRoundsToLoad;    // set by ClientDoReload to know how many rounds to put in the gun
var     byte            CurrentBulletCount; // number of spare bullets, used for HUD display rather than total clips

var     Material        AmmoIcon;           // icon to use instead of regular ammo one

replication
{
    // Variables the server will replicate to the client that owns this actor
    reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
        CurrentBulletCount;

    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerSetInterruptReload;
}

// Modified as we want to display actual number of bullets, rather than number of clips
simulated function int GetHudAmmoCount()
{
    return CurrentBulletCount;
}

// Modified to update count of individual rounds
function UpdateResupplyStatus(bool bCurrentWeapon)
{
    local int TempCount, i;

    super.UpdateResupplyStatus(bCurrentWeapon);

    if (bCurrentWeapon)
    {
        for (i = 1; i < PrimaryAmmoArray.Length; ++i)
        {
            TempCount += PrimaryAmmoArray[i];
        }

        CurrentBulletCount = TempCount;
    }
}

// Modified to allow one-by-one reloading unless weapon is already reloading, has maximum ammo, is firing or busy, or is out of ammo
simulated function bool AllowReload()
{
    return ReloadState == RS_None && !AmmoMaxed(0) && !IsFiring() && !IsBusy() && CurrentMagCount > 0;
}

// Modified to allow reloading of individual bullets
function ServerRequestReload()
{
    local int ReloadAmount;

    if (AllowReload())
    {
        ReloadAmount = GetRoundsToLoad();

        if (Level.NetMode == NM_DedicatedServer)
        {
            NumRoundsToLoad = ReloadAmount;
            GotoState('Reloading');
        }

        ClientDoReload(ReloadAmount);
    }
    else
    {
        ClientCancelReload();
    }
}

// Modified to allow reloading of individual bullets
simulated function ClientDoReload(optional byte NumRounds)
{
    NumRoundsToLoad = NumRounds;
    GotoState('Reloading');
}

// Out of state this does nothing & should never be called anyway - it is only effective in state Reloading
function ServerSetInterruptReload()
{
}

// Modified to handle substantially different reload system
simulated state Reloading
{
    // Overridden to allow interruption of reloads
    simulated function Fire(float F)
    {
        if (ReloadState != RS_PostReload)
        {
            bInterruptReload = true;
            ServerSetInterruptReload();
        }
    }

    function ServerSetInterruptReload()
    {
        bInterruptReload = true;
    }

    // Overridden to support playing proper anims after bolting
    simulated function AnimEnd(int Channel)
    {
        local name  Anim;
        local float Frame, Rate;

        if (InstigatorIsLocallyControlled())
        {
            GetAnimParams(0, Anim, Frame, Rate);

            if (Anim == PreReloadAnim)
            {
                SetTimer(0.0, false);
                ReloadState = RS_ReloadLooped;
                PlayReload();

                return;
            }

            if (Anim == SingleReloadAnim)
            {
                if (NumRoundsToLoad == 0 || bInterruptReload)
                {
                    SetTimer(0.0, false);
                    ReloadState = RS_PostReload;
                    PlayPostReload();

                    if (Role == ROLE_Authority)
                    {
                        ROPawn(Instigator).StopReload();
                        PerformReload();
                    }

                    bInterruptReload = false;
                }
                else
                {
                    PlayReload();

                    if (Role == ROLE_Authority)
                    {
                        PerformReload();
                    }
                }

                return;
            }
        }

        super.AnimEnd(Channel);
    }

    simulated function Timer()
    {
        if (ReloadState == RS_PostReload)
        {
            super.Timer();
        }
        else if (ReloadState == RS_PreReload)
        {
            ReloadState = RS_ReloadLooped;
            PlayReload();

            if (Role == ROLE_Authority)
            {
                NumRoundsToLoad--;
            }
        }
        else if (ReloadState == RS_ReloadLooped)
        {
            if (NumRoundsToLoad == 0 || bInterruptReload)
            {
                if (Role == ROLE_Authority)
                {
                    if (ROPawn(Instigator) != none)
                    {
                        ROPawn(Instigator).StopReload();
                    }

                    PerformReload();
                    bInterruptReload = false;
                }

                ReloadState = RS_PostReload;
                PlayPostReload();
            }
            else
            {
                PlayReload();

                if (Role == ROLE_Authority)
                {
                    PerformReload();
                    NumRoundsToLoad--;
                }
            }
        }
    }

    simulated function BeginState()
    {
        if (Role == ROLE_Authority && ROPawn(Instigator) != none)
        {
            ROPawn(Instigator).StartReload();
        }

        if (ReloadState == RS_None)
        {
            ReloadState = RS_PreReload;
            PlayPreReload();
        }
    }

    simulated function EndState()
    {
        if (ReloadState == RS_PostReload)
        {
            NumRoundsToLoad = 0;
            bWaitingToBolt = false;
            ReloadState = RS_None;
        }
    }
}

// New function to play the pre-reload animation
simulated function PlayPreReload()
{
    SetTimer(GetAnimDuration(PreReloadAnim, 1.0) + FastTweenTime, false);

    if (InstigatorIsLocallyControlled())
    {
        PlayAnim(PreReloadAnim, 1.0, FastTweenTime);
    }
}

// Modified to use single reload animation & to decrement the number of rounds to load // need to add tween time to this?
simulated function PlayReload()
{
    SetTimer(GetAnimDuration(SingleReloadAnim, 1.0), false);

    if (InstigatorIsLocallyControlled())
    {
        NumRoundsToLoad--;
        PlayAnim(SingleReloadAnim, 1.0);
    }
}

// New function to play the post-reload animation // need to add tween time to this?
simulated function PlayPostReload()
{
    SetTimer(GetAnimDuration(PostReloadAnim, 1.0), false);

    if (InstigatorIsLocallyControlled())
    {
        PlayAnim(PostReloadAnim, 1.0);
    }
}

// New function to calculate the number of bullets to be loaded
function byte GetRoundsToLoad()
{
    local int  CurrentMagLoad, InitialAmount;
    local byte AmountNeeded;

    if (PrimaryAmmoArray.Length == 0)
    {
        return 0;
    }

    CurrentMagLoad = AmmoAmount(0);
    InitialAmount = AmmoClass[0].default.InitialAmount;

    if (bTwoMagsCapacity)
    {
        InitialAmount *= 2;
    }

    AmountNeeded = InitialAmount - CurrentMagLoad;

    return Min(AmountNeeded, CurrentBulletCount);
}

// Modified to load one round each time
// Note than in this weapon type, CurrentMagIndex is not cycled & always remains zero (it's the 'mag' already loaded in the weapon)
function PerformReload()
{
    local int i;

    if (CurrentMagCount < 1)
    {
        return;
    }

    // Loop through the spare mags
    for (i = 1; i < PrimaryAmmoArray.Length; ++i)
    {
        // If mag is empty, discard it & check the next one (shouldn't happen, but a fail-safe)
        if (PrimaryAmmoArray[i] <= 0)
        {
            PrimaryAmmoArray.Remove(i, 1);
            --i; // need to adjust for array member being removed, otherwise we'll skip the next mag
            continue;
        }

        // If mag has 1 round, discard the mag as it will be empty after loading
        if (PrimaryAmmoArray[i] == 1)
        {
            PrimaryAmmoArray.Remove(i, 1);
        }
        // Otherwise reduce the next mag by 1 round
        else
        {
            --PrimaryAmmoArray[1];
        }

        // Load 1 round & stop checking
        AddAmmo(1, 0);
        break;
    }

    // Update the weapon attachment ammo status
    if (AmmoAmount(0) > 0 && ROWeaponAttachment(ThirdPersonActor) != none)
    {
        ROWeaponAttachment(ThirdPersonActor).bOutOfAmmo = false;
    }

    UpdateResupplyStatus(true);
}

// Modified to work the bolt when fire is pressed, if weapon is waiting to bolt
simulated function Fire(float F)
{
    if (bWaitingToBolt && !IsBusy())
    {
        WorkBolt();
    }
    else
    {
        super.Fire(F);
    }
}

// New function to work the bolt
simulated function WorkBolt()
{
    if (bWaitingToBolt && AmmoAmount(0) > 0)
    {
        GotoState('WorkingBolt');

        if (Role < ROLE_Authority)
        {
            ServerWorkBolt();
        }
    }
}

// Client-to-server function to work the bolt
function ServerWorkBolt()
{
    WorkBolt();
}

// State where the bolt is being worked
simulated state WorkingBolt extends WeaponBusy
{
    simulated function bool ShouldUseFreeAim()
    {
        return global.ShouldUseFreeAim();
    }

    simulated function bool WeaponAllowSprint()
    {
        return false;
    }

    simulated function bool CanStartCrawlMoving()
    {
        return false;
    }

    // Overridden to support playing proper anims after bolting
    simulated function AnimEnd(int Channel)
    {
        local name  Anim;
        local float Frame, Rate;

        if (InstigatorIsLocallyControlled())
        {
            GetAnimParams(0, Anim, Frame, Rate);

            if (Anim == BoltIronAnim || Anim == BoltHipAnim)
            {
                bWaitingToBolt = false;
            }
        }

        super.AnimEnd(Channel);

        GotoState('Idle');
    }

    simulated function BeginState()
    {
        local name Anim;

        if (bUsingSights)
        {
            if (bPlayerFOVZooms && InstigatorIsLocallyControlled())
            {
                PlayerViewZoom(false);
            }

            Anim = BoltIronAnim;
        }
        else
        {
            Anim = BoltHipAnim;
        }

        PlayAnimAndSetTimer(Anim, 1.0, 0.1);

        // Play the animation on the pawn
        if (Role == ROLE_Authority && ROPawn(Instigator) != none)
        {
            ROPawn(Instigator).HandleBoltAction();
        }
    }

    simulated function EndState()
    {
        if (bUsingSights && bPlayerFOVZooms && InstigatorIsLocallyControlled())
        {
            PlayerViewZoom(true);
        }

        bWaitingToBolt = false;
        FireMode[0].NextFireTime = Level.TimeSeconds - 0.1; // ready to fire fire now
    }
}

// Called by the weapon fire code to send the weapon to the post firing state
simulated function PostFire()
{
    GotoState('PostFiring');
}

// State where the weapon has just been fired
simulated state PostFiring
{
    simulated function bool ReadyToFire(int Mode)
    {
        return false;
    }

    simulated function Timer()
    {
        if (!InstigatorIsHumanControlled())
        {
            if (AmmoAmount(0) > 0)
            {
                GotoState('WorkingBolt');
            }
            else
            {
               GotoState('Reloading');
            }
        }
        else
        {
            GotoState('Idle');
        }
    }

    simulated function BeginState()
    {
        bWaitingToBolt = true;

        if (bUsingSights && DHProjectileFire(FireMode[0]) != none)
        {
            SetTimer(GetAnimDuration(DHProjectileFire(FireMode[0]).FireIronAnim, 1.0), false);
        }
        else
        {
            SetTimer(GetAnimDuration(FireMode[0].FireAnim, 1.0), false);
        }
    }
}

// Modified so bots don't go straight to the reloading state on bolt actions
simulated function OutOfAmmo()
{
    super(ROWeapon).OutOfAmmo();
}

defaultproperties
{
    BobModifyFactor=0.05
}
