//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHObstacleInstance extends Actor
    notplaceable;

var DHObstacle Info;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    GotoState('Cleared');
}

simulated state Intact
{
    simulated function BeginState()
    {
        SetStaticMesh(Info.GetIntactStaticMesh());
        KSetBlockKarma(false);

        super.BeginState();
    }

    simulated function EndState()
    {
        super.EndState();
    }

    event Touch(Actor Other)
    {
        local DarkestHourGame G;

        if (!Info.CanBeCrushed())
        {
            return;
        }

        if (Role == ROLE_Authority && SVehicle(Other) != none)
        {
            G = DarkestHourGame(Level.Game);

            if (G != none && G.ObstacleManager != none)
            {
                G.ObstacleManager.SetCleared(self, true);
            }
        }

        super.Touch(Other);
    }

    simulated function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
    {
        local DarkestHourGame G;

        if (Role == ROLE_Authority)
        {
            // Determine if the obstacle can be destroyed by explosives or weapons and make sure the damage meets the threshold for destruction
            if ((Info.CanBeDestroyedByExplosives() &&
                !DamageType.default.bLocationalHit &&
                Damage >= Info.GetExplosionDamageThreshold()) ||
                (Info.CanBeDestroyedByWeapons() &&
                DamageType.default.bLocationalHit &&
                Damage >= Info.GetDamageThreshold()))
            {
                G = DarkestHourGame(Level.Game);

                if (G != none && G.ObstacleManager != none)
                {
                    G.ObstacleManager.SetCleared(self, true);
                }
            }
        }
    }
}

simulated state Cleared
{
    simulated function BeginState()
    {
        Info = DHObstacle(Owner);

        SetStaticMesh(Info.GetClearedStaticMesh());
        KSetBlockKarma(false);

        super.BeginState();
    }
}

simulated function SetCleared(bool bIsCleared)
{
    local sound ClearSound;
    local class<Emitter> ClearEmitterClass;
    local float ClearSoundRadius;

    if (bIsCleared && !IsInState('Cleared'))
    {
        if (Level.NetMode != NM_DedicatedServer &&
            !IsInState('DHObstacleInstance'))
        {
            ClearSound = Info.GetClearSound(ClearSoundRadius);
            ClearEmitterClass = Info.GetClearEmitterClass();

            if (ClearSound != none)
            {
                PlaySound(ClearSound, SLOT_None, 255.0, true, ClearSoundRadius);
            }

            if (ClearEmitterClass != none)
            {
                Spawn(ClearEmitterClass, none, '', Location, Rotation);
            }
        }

        GotoState('Cleared');
    }
    else if (!bIsCleared && !IsInState('Intact'))
    {
        GotoState('Intact');
    }
}

defaultproperties
{
    bBlockPlayers=true
    bBlockActors=true
    bBlockKarma=true
    bBlockProjectiles=true
    bBlockHitPointTraces=true
    bBlockNonZeroExtentTraces=true
    bCanBeDamaged=true
    bCollideActors=true
    bCollideWorld=false
    bWorldGeometry=false
    DrawType=DT_StaticMesh
    RemoteRole=ROLE_None
}
