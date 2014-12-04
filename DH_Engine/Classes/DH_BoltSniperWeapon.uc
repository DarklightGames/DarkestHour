//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BoltSniperWeapon extends DH_SniperWeapon
    abstract;

var         name        PreReloadAnim;          // anim for opening the bolt
var         name        SingleReloadAnim;       // anim inserting single bullets
var         name        PostReloadAnim;         // anim for closing the bolt

var         int         NumRoundsToLoad;        // Set by ClientDoReload to know how many rounds to put in the gun
var         int         CurrentBulletCount;     // Number of spare bullets, used for HUD display rather than total clips

var         bool        bInterruptReload;       // Stop reload part way through?

var         Material    AmmoIcon;               // Icon to use instead of regular ammo one


enum EReloadState
{
    RS_none,
    RS_PreReload,
    RS_ReloadLooped,
    RS_PostReload,
};

var     EReloadState            ReloadState;

replication
{
    reliable if (bNetDirty && bNetOwner && (Role==ROLE_Authority))
        CurrentBulletCount;

    reliable if (Role < ROLE_Authority)
        ServerSetInterruptReload;
}

// We want to display actual number of bullets, rather than number of clips
simulated function int GetHudAmmoCount()
{
    return CurrentBulletCount;
}

function CalculateBulletCount()
{
    local int i, tempCount;

    for (i = 1; i < PrimaryAmmoArray.length; i++)
    {
        tempCount = tempCount + PrimaryAmmoArray[i];
    }

    CurrentBulletCount = tempCount;
}

// Overriden because we don't want to allow reloading unless the weapon is out of
simulated function bool AllowReload()
{
    if (ReloadState != RS_none || AmmoMaxed(0))
    {
        return false;
    }

    return super.AllowReload();
}

simulated exec function ROManualReload()
{
    if (!AllowReload())
        return;

    if (Level.Netmode == NM_Client && !IsBusy())
    {
        GotoState('PendingAction');
    }

    ServerRequestReload();
}

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
        // if we can't reload
        ClientCancelReload();
    }
}

simulated function ClientDoReload(optional int NumRounds)
{
    NumRoundsToLoad = NumRounds;
    GotoState('Reloading');
}

function ServerSetInterruptReload(){}

simulated state Reloading
{
    simulated function bool ReadyToFire(int Mode)
    {
        return false;
    }

    simulated function bool ShouldUseFreeAim()
    {
        return false;
    }

    simulated function bool WeaponAllowSprint()
    {
        return false;
    }

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

    // Overriden to support playing proper anims after bolting
    simulated function AnimEnd(int channel)
    {
        local name anim;
        local float frame, rate;

        GetAnimParams(0, anim, frame, rate);

        if (Instigator.IsLocallyControlled() && (anim == PreReloadAnim || anim == SingleReloadAnim))
        {
            if (anim == PreReloadAnim)
            {
                SetTimer(0.0, false);
                ReloadState = RS_ReloadLooped;
                PlayReload();
            }
            else if (anim == SingleReloadAnim )
            {
                if (NumRoundsToLoad == 0 || bInterruptReload)
                {
                    SetTimer(0.0, false);
                    ReloadState = RS_PostReload;
                    PlayPostReload();

                    if (Role == ROLE_Authority)
                    {
                        ROPawn(Instigator).StopReload();
                        LoadBullet();
                    }

                    bInterruptReload = false;
                }
                else
                {
                    PlayReload();

                    if (Role == ROLE_Authority)
                    {
                        LoadBullet();
                    }
                }
            }

            return;
        }
        else
        {
            super.AnimEnd(channel);
        }
    }

    simulated function Timer()
    {

        if (ReloadState == RS_PostReload)
        {
            if (Instigator.bIsCrawling && VSizeSquared(Instigator.Velocity) > 1.0)
                GotoState('StartCrawling');
            else
                GotoState('Idle');
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
            if (NumRoundsToLoad <= 0 || bInterruptReload)
            {
                if (Role == ROLE_Authority)
                {
                    ROPawn(Instigator).StopReload();
                    LoadBullet();
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
                    LoadBullet();
                    NumRoundsToLoad--;
                }
            }
        }
    }

    simulated function BeginState()
    {
        if (Role == ROLE_Authority)
        {
            ROPawn(Instigator).StartReload();
        }

        if (ReloadState == RS_none)
        {
            ReloadState = RS_PreReload;
            PlayPreReload();
        }
    }

    simulated function EndState()
    {
        if (ReloadState == RS_PostReload)
        {
            NumRoundsToLoad=0;
            bWaitingToBolt = false;
            ReloadState = RS_none;
        }
    }

// Take the player out of iron sights if they are in ironsights
Begin:
    if (bUsingSights)
    {
        if (Role == ROLE_Authority)
            ServerZoomOut(false);
        else
            ZoomOut(false);

        if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            if (bPlayerFOVZooms)
            {
                PlayerViewZoom(false);
            }
            SmoothZoom(false);
        }
    }

    // Sometimes the client will get switched out of ironsight mode before getting to
    // the reload function. This should catch that.
    if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
    {
        if (DisplayFOV != default.DisplayFOV)
        {
            SmoothZoom(false);
        }

        if (bPlayerFOVZooms)
        {
            PlayerViewZoom(false);
        }
    }
}

simulated function PlayPreReload()
{
    SetTimer(GetAnimDuration(PreReloadAnim, 1.0) + FastTweenTime, false);

    if (Instigator.IsLocallyControlled())
    {
        PlayAnim(PreReloadAnim, 1.0, FastTweenTime);
    }
}

simulated function PlayReload()
{
    // Need to add tween time to this
    SetTimer(GetAnimDuration(SingleReloadAnim, 1.0), false);

    if (Instigator.IsLocallyControlled())
    {
        NumRoundsToLoad--;
        PlayAnim(SingleReloadAnim, 1.0);
    }
}

simulated function PlayPostReload()
{
    SetTimer(GetAnimDuration(PostReloadAnim, 1.0), false);

    if (Instigator.IsLocallyControlled())
    {
        PlayAnim(PostReloadAnim, 1.0);
    }
}

// Returns the number of bullets to be loaded
function int GetRoundsToLoad()
{
    local int CurrentMagLoad;
    local int AmountToAdd, AmountNeeded;

    CurrentMagLoad = AmmoAmount(0);

    if (PrimaryAmmoArray.Length == 0)
    {
        return 0;
    }


    AmountNeeded = AmmoClass[0].default.InitialAmount - CurrentMagLoad;

    if (AmountNeeded > CurrentBulletCount)
        AmountToAdd = CurrentBulletCount;
    else
        AmountToAdd = AmountNeeded;

    return AmountToAdd;
}

// Does the actual ammo swapping
// Loads one bullet each time through
function LoadBullet()
{
    if (PrimaryAmmoArray[CurrentMagIndex + 1] == 1)
    {
        PrimaryAmmoArray.Remove(CurrentMagIndex + 1, 1);
    }
    else
    {
        PrimaryAmmoArray[CurrentMagIndex + 1] = PrimaryAmmoArray[CurrentMagIndex + 1] - 1;
    }

    AddAmmo(1, 0);

    if (AmmoAmount(0) > 0)
    {
        if (DHWeaponAttachment(ThirdPersonActor) != none)
        {
            DHWeaponAttachment(ThirdPersonActor).bOutOfAmmo = false;
        }
    }

    ClientForceAmmoUpdate(0, AmmoAmount(0));
    CurrentMagCount = PrimaryAmmoArray.Length - 1;
    CalculateBulletCount();
}

// Work the bolt when fire is pressed
simulated function Fire(float F)
{
    super.Fire(F);

    if (IsBusy() || !bWaitingToBolt)
        return;

    WorkBolt();
}

// Work the bolt
simulated function WorkBolt()
{
    if (!bWaitingToBolt || AmmoAmount(0) < 1)
        return;

    GotoState('WorkingBolt');

    if (Role < ROLE_Authority)
        ServerWorkBolt();

}

// Server side function called to work the bolt on the server
function ServerWorkBolt()
{
    WorkBolt();
}

//State where the bolt is being worked
simulated state WorkingBolt extends Busy
{
    simulated function bool ReadyToFire(int Mode)
    {
        return false;
    }

    simulated function bool WeaponAllowSprint()
    {
        return false;
    }

    simulated function bool CanStartCrawlMoving()
    {
        return false;
    }

    simulated function Timer()
    {
        GotoState('Idle');
    }

    // Overriden to support playing proper anims after bolting
    simulated function AnimEnd(int channel)
    {
        local name anim;
        local float frame, rate;

        GetAnimParams(0, anim, frame, rate);

        if (Instigator.IsLocallyControlled() && (anim == BoltIronAnim || anim == BoltHipAnim))
        {
            bWaitingToBolt = false;
        }

        super.AnimEnd(channel);
        GotoState('Idle');
    }

    simulated function BeginState()
    {
        local name Anim;
        local float BoltWaitTime;

        if (bUsingSights)
        {
            if (Instigator.IsLocallyControlled())
            {
                if (bPlayerFOVZooms)
                    PlayerViewZoom(false);
            }

            Anim = BoltIronAnim;
        }
        else
        {
            Anim = BoltHipAnim;
        }

        if (Instigator.IsLocallyControlled())
        {
            PlayAnim(Anim, 1.0, FastTweenTime);
        }

        // Play the animation on the pawn
        if (Role == ROLE_Authority)
        {
            ROPawn(Instigator).HandleBoltAction();
        }

        BoltWaitTime = GetAnimDuration(Anim, 1.0) + FastTweenTime;

        if (Instigator.IsLocallyControlled())
        {
            SetTimer(BoltWaitTime, false);
        }
        else
        {
            // Let the server set the bWaitingToBolt to false a little sooner than the client
            // Since the client can't attempt to fire until he is done bolting, this will
            // help alleviate situations where the client finishes bolting before the
            // server registers the bolting as finished
            BoltWaitTime = BoltWaitTime - (BoltWaitTime * 0.1);
            SetTimer(BoltWaitTime, false);
        }
    }

    simulated function EndState()
    {
        if (bUsingSights && Instigator.IsLocallyControlled())
        {
            if (bPlayerFOVZooms)
                PlayerViewZoom(true);
        }

        bWaitingToBolt = false;
        FireMode[0].NextFireTime = Level.TimeSeconds - 0.1; //fire now!
    }
}

// Called by the weapon fire code to send the weapon to the post firing state
simulated function PostFire()
{
    GotoState('PostFiring');
}

// Don't want to go straight to the reloading state on bolt actions
simulated function OutOfAmmo()
{
    super(ROWeapon).OutOfAmmo();
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
        if (!Instigator.IsHumanControlled())
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
        bWaitingToBolt=true;
        if (bUsingSights)
        {
            SetTimer(GetAnimDuration(DH_ProjectileFire(FireMode[0]).FireIronAnim, 1.0), false);
        }
        else
        {
            SetTimer(GetAnimDuration(FireMode[0].FireAnim, 1.0), false);
        }
    }
}

function bool FillAmmo()
{
    local bool Temp;

    Temp = super.FillAmmo();
    CalculateBulletCount();

    return Temp;
}

function GiveAmmo(int m, WeaponPickup WP, bool bJustSpawned)
{
    super.GiveAmmo(m, WP, bJustSpawned);
    CalculateBulletCount();
}

function bool HandlePickupQuery(pickup Item)
{
    local bool Temp;

    Temp = super.HandlePickupQuery(Item);
    CalculateBulletCount();

    return Temp;
}

defaultproperties
{
}
