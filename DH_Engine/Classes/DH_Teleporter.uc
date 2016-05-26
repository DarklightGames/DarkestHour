//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================
// This is now largely unused, but was heavily used in pre-6.0 "spawn rooms"
// where players would walk through ethereal portals to teleport to the battle.
//==============================================================================

class DH_Teleporter extends Teleporter
    placeable;

// The amount of time, in seconds, that the player will have spawn protection
// after using the teleporter.
var()   int     SpawnProtectionTime;

// When true, the player's stamina will be reset upon using the teleporter.
var()   bool    bResetStamina;

// Set timer for spawn protection
simulated function bool Accept(Actor Incoming, Actor Source)
{
    local rotator NewRotation, OldRotation;
    local float Magnitude;
    local vector OldDirection;
    local Controller P;

    if (Incoming == none)
    {
        return false;
    }

    // Move the actor here.
    Disable('Touch');

    NewRotation = Incoming.Rotation;

    if (bChangesYaw)
    {
        OldRotation = Incoming.Rotation;
        NewRotation.Yaw = Rotation.Yaw;
    }

    if (Pawn(Incoming) != none)
    {
        //tell enemies about teleport
        if (Role == ROLE_Authority)
        {
            for (P = Level.ControllerList; P != none; P = P.NextController)
            {
                if (P.Enemy == Incoming)
                {
                    P.LineOfSightTo(Incoming);
                }
            }
        }

        if (!Pawn(Incoming).SetLocation(Location))
        {
            Log(self @ "Teleport failed for" @ Incoming);

            return false;
        }

        if (Role == ROLE_Authority || (Level.TimeSeconds - LastFired) > 0.5)
        {
            NewRotation.Roll = 0;

            Pawn(Incoming).SetRotation(NewRotation);
            Pawn(Incoming).SetViewRotation(NewRotation);
            Pawn(Incoming).ClientSetRotation(NewRotation);

            LastFired = Level.TimeSeconds;
        }

        if (Pawn(Incoming).Controller != none)
        {
            Pawn(Incoming).Controller.MoveTimer = -1.0;
            Pawn(Incoming).Anchor = self;
            Pawn(Incoming).SetMoveTarget(self);
        }

        Incoming.PlayTeleportEffect(false, true);
    }
    else
    {
        if (!Incoming.SetLocation(Location))
        {
            Enable('Touch');

            return false;
        }

        if (bChangesYaw)
        {
            Incoming.SetRotation(NewRotation);
        }
    }

    Enable('Touch');

    if (bChangesVelocity)
    {
        Incoming.Velocity = TargetVelocity;
    }
    else
    {
        if (bChangesYaw)
        {
            if (Incoming.Physics == PHYS_Walking)
            {
                OldRotation.Pitch = 0;
            }

            OldDirection = vector(OldRotation);
            Magnitude = Incoming.Velocity dot OldDirection;
            Incoming.Velocity = Incoming.Velocity - Magnitude * OldDirection + Magnitude * vector(Incoming.Rotation);
        }

        if (bReversesX)
        {
            Incoming.Velocity.X *= -1.0;
        }

        if (bReversesY)
        {
            Incoming.Velocity.Y *= -1.0;
        }

        if (bReversesZ)
        {
            Incoming.Velocity.Z *= -1.0;
        }
    }

    DHPawn(Incoming).TeleSpawnProtEnds = Level.TimeSeconds + SpawnProtectionTime;

    if (Role == ROLE_Authority && bResetStamina && DHPawn(Incoming) != none)
    {
        DHPawn(Incoming).Stamina = DHPawn(Incoming).default.Stamina;
        DHPawn(Incoming).ClientForceStaminaUpdate(DHPawn(Incoming).default.Stamina);
    }

    return true;
}

function Reset()
{
    bEnabled = default.bEnabled;
}

defaultproperties
{
    bResetStamina=true
}
