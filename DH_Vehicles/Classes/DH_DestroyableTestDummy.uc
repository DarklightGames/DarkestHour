//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

// Matt: originally extended RODestroyableStaticMeshBase, but lots of classes look for a RODestroyableStaticMesh, which is a subclass of RODSMBase & so won't be found
// Makes no difference in function, as RODSM is just an empty class that extends RODSMBase, so does exactly the same thing
class DH_DestroyableTestDummy extends RODestroyableStaticMesh;

var()         name          SensorName;

replication
{

    reliable if (bNetDirty && ROLE == ROLE_Authority)
        SensorName;
}

simulated function string GetOnDestroyCriticalMessage()
{
    local string s;
    //Log("GetOnDestroyCriticalMessage called.");
    //Log("Looking at localize info for" @ SavedName $ "," @ string(class) $ "," @ string(level.outer));
    s = Localize(string(SavedName), "OnDestroyCriticalMessage", string(level.outer));

    if (s != "")
    {
        return s;
    }
    else
    {
        return default.OnDestroyCriticalMessage;
    }
}

function Reset()
{
    super.Reset();

    GotoState('Working');
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    SavedStaticMesh = StaticMesh;
    SavedName = name;
    disable('tick');
}

function Trigger(actor Other, pawn EventInstigator)
{
    if (EventInstigator != none)
    {
        MakeNoise(1.0);
    }

    Health = 0;
    TriggerEvent(DestroyedEvent, self, EventInstigator);
    BroadcastCriticalMessage(EventInstigator);
    BreakApart(Location);
}

// Check to see if this mesh can recieve damage from a particular damagetype
function bool ShouldTakeDamage(class<DamageType> damageType)
{
    local int i;

    for (i = 0; i < TypesCanDamage.Length; i++)
    {
        if (damageType==TypesCanDamage[i] || ClassIsChildOf(damageType, TypesCanDamage[i]))
        {
            return true;
        }
    }
    return false;
}

function BroadcastCriticalMessage(Pawn instigatedBy)
{
    local PlayerReplicationInfo PRI;

    // Broadcast critical message if needed
    if (OnDestroyCriticalMessage != "" && OnDestroyBroadcastTarget != CMBT_Nobody)
    {
        if (Level.game != none)
        {
            if (instigatedBy != none)
            {
                PRI = instigatedBy.PlayerReplicationInfo;
                //if (PRI == none)
                //    Log("no valid PRI!!!");
            }
            else
            {
                //Log("no valid PRI!!");
                PRI = none;
            }

            Level.game.BroadcastLocalizedMessage(class'RODestroyableSMDestroyedMsg', OnDestroyBroadcastTarget, PRI,, self);
        }
    }
}

function BreakApart(vector HitLocation, optional vector momentum)
{
    // If we are single player or on a listen server, just spawn the actor, otherwise bHidden will trigger the effect
    if (Level.NetMode != NM_DedicatedServer)
    {
        if (DestroyedEffect != none)
        {
            Spawn(DestroyedEffect, Owner,, (Location + (DestroyedEffectOffset >> Rotation)));
        }
    }

    GotoState('Broken');
}

auto state Working
{
    function BeginState()
    {
        super.BeginState();

        KSetBlockKarma(false);
        NetUpdateTime = Level.TimeSeconds - 1;
        SetStaticMesh(SavedStaticMesh);
        SetCollision(true, true, true);
        KSetBlockKarma(true); // update karma collision

        bHidden = false;
        bDamaged = false;
        Health = default.health;
        DestroyedTime = 0;
    }

    function EndState()
    {
        super.EndState();

        NetUpdateTime = Level.TimeSeconds - 1.0;
        DestroyedTime = Level.TimeSeconds;

        if (bUseDamagedMesh)
        {
            KSetBlockKarma(false);
            SetStaticMesh(DamagedMesh);
            SetCollision(true, true, true);
            KSetBlockKarma(true); // update karma collision
            bDamaged = true;
        }
        else
        {
            bHidden = true;
            SetCollision(false, false, false);
        }
    }

    function TakeDamage(int Damage, Pawn instigatedBy, vector hitlocation,  vector momentum, class<DamageType> damageType, optional int HitIndex)
    {
        if (!ShouldTakeDamage(damageType))
        {
            return;
        }

        if (instigatedBy != none)
        {
            MakeNoise(1.0);
        }

        Health -= Damage;
        Level.Game.Broadcast(self, "Dummy:" $ SensorName $ ", DamageTaken:" @ Damage @ "points");
        Log("Dummy =" @ SensorName);
        Log("DamageTaken =" @ Damage);

        if (Health <= 0)
        {
            TriggerEvent(DestroyedEvent, self, instigatedBy);
            BroadcastCriticalMessage(instigatedBy);
            BreakApart(HitLocation, Momentum);
        }
    }
}

state Broken
{
    function BeginState()
    {
        super.BeginState();
    }
}

simulated function PostNetReceive()
{
    if ((bHidden || bDamaged) && DestroyedEffect != none && Level.TimeSeconds - DestroyedTime < 1.5)
    {
        Spawn(DestroyedEffect, Owner,, (Location + (DestroyedEffectOffset >> Rotation)));
    }
}

defaultproperties
{
    SensorName="Shurek"
}
