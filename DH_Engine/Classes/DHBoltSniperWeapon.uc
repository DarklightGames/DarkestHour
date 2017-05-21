//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
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

var     EReloadState    ReloadState;      // weapon's current reloading state (none means not reloading)
var     bool            bInterruptReload; // set when one-by-one reload is stopped by player part way through, by pressing fire button
var     name            PreReloadAnim;    // one-off anim when starting to reload
var     name            SingleReloadAnim; // looping anim for inserting a single round
var     name            PostReloadAnim;   // one-off anim when reloading ends
var     byte            NumRoundsToLoad;  // how many rounds to be loaded to fill the weapon

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerSetInterruptReload;
}

// Modified to update number of individual spare rounds
// As weapon doesn't used mags, the existing replicated CurrentMagCount is used to represent the total no. of individual spare rounds
// This is calculated by adding up the rounds in each dummy 'mag' (just a data grouping of individual spare rounds)
// This is primarily used by net clients to display the no. of spare rounds carried, as clients don't have PrimaryAmmoArray data
function UpdateResupplyStatus(bool bCurrentWeapon)
{
    local DHPawn P;
    local int    NumSpareRounds, DummyMagCount, i;

    if (bCurrentWeapon)
    {
        for (i = 1; i < PrimaryAmmoArray.Length; ++i)
        {
            NumSpareRounds += PrimaryAmmoArray[i];
        }

        CurrentMagCount = byte(NumSpareRounds);
    }

    P = DHPawn(Instigator);

    if (P != none)
    {
        DummyMagCount = Max(0, PrimaryAmmoArray.Length - 1); // what CurrentMagCount would normally be, used below to set bWeaponNeedsResupply

        P.bWeaponNeedsResupply = bCanBeResupplied && bCurrentWeapon && DummyMagCount < (MaxNumPrimaryMags - 1);
        P.bWeaponNeedsReload = false;
    }
}

// Modified to prevent reloading if weapon is already reloading or has maximum ammo
simulated function bool AllowReload()
{
    return ReloadState == RS_None && !AmmoMaxed(0) && !IsFiring() && !IsBusy() && CurrentMagCount > 0;
}

// Modified to allow reloading of individual rounds
function ServerRequestReload()
{
    local byte ReloadAmount;

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

// Modified to update (on the client) the number of rounds to be reloaded
simulated function ClientDoReload(optional byte NumRounds)
{
    NumRoundsToLoad = NumRounds;

    super.ClientDoReload(NumRounds);
}

// Out of state this does nothing & should never be called anyway - it is only effective in state Reloading
function ServerSetInterruptReload()
{
}

// Modified to handle substantially different one round at a time reload system
simulated state Reloading
{
    // Modified to allow interruption of reload by pressing fire
    simulated function Fire(float F)
    {
        if (ReloadState != RS_PostReload)
        {
            bInterruptReload = true;
            ServerSetInterruptReload();
        }
    }

    // New replicated client-to-server function to set bInterruptReload on server
    function ServerSetInterruptReload()
    {
        bInterruptReload = true;
    }

    // Modified to progress through reload stages, playing appropriate anims
    simulated function AnimEnd(int Channel)
    {
        local name  Anim;
        local float Frame, Rate;

        if (InstigatorIsLocallyControlled())
        {
            GetAnimParams(0, Anim, Frame, Rate);

            // Just finished playing pre-reload anim so now load 1st round
            if (Anim == PreReloadAnim)
            {
                SetTimer(0.0, false);
                ReloadState = RS_ReloadLooped;
                PlayReload();

                return;
            }

            // Just finished playing a single round reload anim
            if (Anim == SingleReloadAnim)
            {
                // Either loaded last round or player stopped the reload (by pressing fire), so now play post-reload anim
                if (NumRoundsToLoad == 0 || bInterruptReload)
                {
                    SetTimer(0.0, false);
                    bInterruptReload = false;
                    ReloadState = RS_PostReload;
                    PlayPostReload();

                    if (Role == ROLE_Authority)
                    {
                        if (ROPawn(Instigator) != none)
                        {
                            ROPawn(Instigator).StopReload();
                        }

                        PerformReload();
                    }
                }
                // Otherwise start loading the next round
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
    }

    // Modified to progress through reload stages
    simulated function Timer()
    {
        // Just finished pre-reload anim so now load 1st round
        if (ReloadState == RS_PreReload)
        {
            ReloadState = RS_ReloadLooped;
            PlayReload();

            if (Role == ROLE_Authority)
            {
                NumRoundsToLoad--;
            }
        }
        // Just finished loading a single round
        else if (ReloadState == RS_ReloadLooped)
        {
            // Either loaded last round or player stopped the reload (by pressing fire), so now play post-reload anim
            if (NumRoundsToLoad == 0 || bInterruptReload)
            {
                if (Role == ROLE_Authority)
                {
                    if (ROPawn(Instigator) != none)
                    {
                        ROPawn(Instigator).StopReload();
                    }

                    PerformReload();
                }

                bInterruptReload = false;
                ReloadState = RS_PostReload;
                PlayPostReload();
            }
            // Otherwise start loading the next round
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
        // Just finished post-reload anim so we're finished
        else if (ReloadState == RS_PostReload)
        {
            GotoState('Idle');
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
    PlayAnimAndSetTimer(PreReloadAnim, 1.0);
}

// Modified to use single reload animation (without adding FastTweenTime to timer), & to decrement the number of rounds to load
simulated function PlayReload()
{
    SetTimer(GetAnimDuration(SingleReloadAnim, 1.0), false);

    if (InstigatorIsLocallyControlled())
    {
        NumRoundsToLoad--;

        if (HasAnim(SingleReloadAnim))
        {
            PlayAnim(SingleReloadAnim, 1.0);
        }
    }
}

// New function to play PostReloadAnim & set a timer for when it ends (without adding FastTweenTime to timer)
simulated function PlayPostReload()
{
    SetTimer(GetAnimDuration(PostReloadAnim, 1.0), false);

    if (InstigatorIsLocallyControlled() && HasAnim(PostReloadAnim))
    {
        PlayAnim(PostReloadAnim, 1.0);
    }
}

// New function to calculate the number of rounds to be loaded to fill the weapon
function byte GetRoundsToLoad()
{
    local int  CurrentLoadedRounds, MaxLoadedRounds;
    local byte AmountNeeded;

    if (PrimaryAmmoArray.Length == 0)
    {
        return 0;
    }

    CurrentLoadedRounds = AmmoAmount(0);
    MaxLoadedRounds = AmmoClass[0].default.InitialAmount;

    if (bTwoMagsCapacity)
    {
        MaxLoadedRounds *= 2;
    }

    AmountNeeded = MaxLoadedRounds - CurrentLoadedRounds;

    return Min(AmountNeeded, CurrentMagCount);
}

// Modified to load one round each time
// 'Mags' for this weapon aren't really mags, they are just dummy mags that act as data groupings of individual spare rounds
// Each dummy mag contains the max no. of rounds that can be loaded into the weapon
// Mag zero represents the weapon's currently loaded rounds (so CurrentMagIndex is not cycled as usual & always remains zero)
// When reloading, individual rounds are stripped one at a time from mag 1 & loaded into the weapon
// When mag 1 is empty it is deleted (removed from PrimaryAmmoArray) so the next mag becomes mag 1 & that is used for any further loading
// It's done this way to work with existing mag-based functionality, while allowing one at a time loading up to a max no. limited by the dummy mag size
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
    if (bWaitingToBolt && AmmoAmount(0) > 0 && !FireMode[1].bIsFiring && !FireMode[1].IsInState('MeleeAttacking'))
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
        if (bUsingSights)
        {
            if (bPlayerFOVZooms && InstigatorIsLocallyControlled())
            {
                PlayerViewZoom(false);
            }

            PlayAnimAndSetTimer(BoltIronAnim, 1.0, 0.1);
        }
        else
        {
            PlayAnimAndSetTimer(BoltHipAnim, 1.0, 0.1);
        }

        if (Role == ROLE_Authority && ROPawn(Instigator) != none)
        {
            ROPawn(Instigator).HandleBoltAction(); // play the animation on the pawn
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

// Modified to skip over the Super in DHSniperWeapon that is only relevant to semi-auto & auto weapons
simulated function AnimEnd(int channel)
{
    super(DHProjectileWeapon).AnimEnd(Channel);
}

// Modified to skip over the Super in DHSniperWeapon that is only relevant to semi-auto & auto weapons
simulated event StopFire(int Mode)
{
    super(DHProjectileWeapon).StopFire(Mode);
}

// Modified so bots don't go straight to the reloading state on bolt actions
simulated function OutOfAmmo()
{
    super(ROWeapon).OutOfAmmo();
}

defaultproperties
{
    bPlusOneLoading=false
    BobModifyFactor=0.8
    ZoomOutTime=0.4

    PostFireIdleAnim="Idle"
    PostFireIronIdleAnim="Scope_Idle"
    BoltHipAnim="bolt_scope"
    BoltIronAnim="scope_bolt"
    PreReloadAnim="Single_Open"
    SingleReloadAnim="Single_insert"
    PostReloadAnim="Single_Close"
    MagEmptyReloadAnim=none
    MagPartialReloadAnim=none
}
