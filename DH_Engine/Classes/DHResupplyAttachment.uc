//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHResupplyAttachment extends RODummyAttachment
  dependson(DHResupplyStrategy)
  notplaceable;

var     private int     TeamIndex;      // Team this volume resupplies
var     private int     SquadIndex;     // Squad this volume resupplies. When
                                        // set, vehicles are only resupplied
                                        // when controlled by a squad memeber.
var     DHResupplyStrategy.EResupplyType   ResupplyType;   // Who this volume will resupply
var     array<Pawn>     ResupplyActors;
var     float           UpdateTime;     // How often this thing needs to do it's business

var     class<DHMapIconAttachment> MapIconAttachmentClass;
var     DHMapIconAttachment        MapIconAttachment;

var     DHResupplyStrategy ResupplyStrategy;

delegate OnPawnResupplied(Pawn P);            // Called for every pawn that is resupplied

function OnTeamIndexChanged();

function PostBeginPlay()
{
    super(Actor).PostBeginPlay();

    ResupplyStrategy = new class'DHResupplyStrategy';

    SetTimer(1.0, true);
}

final function AttachMapIcon()
{
    if (MapIconAttachmentClass != none)
    {
        MapIconAttachment = Spawn(MapIconAttachmentClass, self);

        if (MapIconAttachment != none)
        {
            MapIconAttachment.SetBase(self);
            MapIconAttachment.Setup();
            DHMapIconAttachment_Resupply(MapIconAttachment).SetResupplyType(ResupplyType);
            MapIconAttachment.SetTeamIndex(TeamIndex);
        }
        else
        {
            MapIconAttachmentClass.static.OnError(ERROR_SpawnFailed);
        }
    }
}

simulated function int GetTeamIndex()
{
    return TeamIndex;
}

final function SetTeamIndex(int TeamIndex)
{
    self.TeamIndex = TeamIndex;

    if (MapIconAttachment != none)
    {
        MapIconAttachment.SetTeamIndex(TeamIndex);
    }

    OnTeamIndexChanged();
}

simulated function int GetSquadIndex()
{
    return SquadIndex;
}

final function SetSquadIndex(int SquadIndex)
{
    self.SquadIndex = SquadIndex;
}

final function SetResupplyType(DHResupplyStrategy.EResupplyType ResupplyType)
{
    self.ResupplyType = ResupplyType;

    if (MapIconAttachment != none)
    {
        DHMapIconAttachment_Resupply(MapIconAttachment).SetResupplyType(ResupplyType);
    }
}

function bool CanResupplyPawn(Pawn P)
{
    local DHPlayerReplicationInfo PRI;
    local ROVehicle ROV;
    local int i;

    if (P != none && (TeamIndex == NEUTRAL_TEAM_INDEX || P.GetTeamNum() == TeamIndex))
    {
        if (SquadIndex >= 0)
        {
            ROV = ROVehicle(P);

            if (ROV != none)
            {
                // Check if any of the weapons are manned by a squad member.
                for (i = 0; i < ROV.WeaponPawns.Length; ++i)
                {
                    PRI = DHPlayerReplicationInfo(ROV.WeaponPawns[i].PlayerReplicationInfo);

                    if (PRI != none && PRI.SquadIndex == SquadIndex)
                    {
                        return true;
                    }
                }
            }

            PRI = DHPlayerReplicationInfo(P.PlayerReplicationInfo);
            return PRI != none && PRI.SquadIndex == SquadIndex;
        }

        return true;
    }
}

function ProcessActorLeave()
{
    local int i;
    local Pawn P, R;
    local bool bFound;

    for (i = 0; i < ResupplyActors.Length; ++i)
    {
        R = ResupplyActors[i];

        if (R == none)
        {
            continue;
        }

        bFound = false;

        foreach VisibleCollidingActors(class'Pawn', P, CollisionRadius)
        {
            // This stops us from the vehicle resupplying itself.
            if (Base != none && Base == P && P == R)
            {
                bFound = true;
                break;
            }
        }

        if (!bFound)
        {
            if (DHPawn(R) != none)
            {
                DHPawn(R).bTouchingResupply = false;
            }
            else if (Vehicle(R) != none)
            {
                Vehicle(R).LeftResupply();
            }
        }
    }
}

function Timer()
{
    local Pawn recvr;
    local ROPawn P;
    local Vehicle V;
    local DHRoleInfo RI;

    ProcessActorLeave();

    ResupplyActors.Remove(0, ResupplyActors.Length);

    foreach RadiusActors(class'Pawn', recvr, CollisionRadius)
    {

        // This stops us from the vehicle resupplying itself.
        if (Base != none && Base == recvr)
        {
            continue;
        }

        if (CanResupplyPawn(recvr))
        {
            P = ROPawn(recvr);
            V = Vehicle(recvr);

            if (P != none &&
                (ResupplyStrategy.static.CanResupplyType(ResupplyType, RT_Players) ||
                 (ResupplyStrategy.static.CanResupplyType(ResupplyType, RT_Mortars) &&
                  RI != none &&
                  RI.bCanUseMortars)))
            {
                //Add him into our resupply list.
                ResupplyActors[ResupplyActors.Length] = P;
                P.bTouchingResupply = true;
            }
            else if (V != none &&
                     V != Base &&
                     (ResupplyStrategy.static.CanResupplyType(ResupplyType, RT_Vehicles) ||
                      (ResupplyStrategy.static.CanResupplyType(ResupplyType, RT_Mortars) &&
                       V.IsA('DHMortarVehicleWeaponPawn'))))
            {
                ResupplyActors[ResupplyActors.Length] = V;
                V.bTouchingResupply = true;
            }

            if (ResupplyStrategy.HandleResupply(recvr, ResupplyType, Level.TimeSeconds))
            {
                OnPawnResupplied(recvr);
            }
        }
    }
}

event Destroyed()
{
    local int i;
    local Pawn P;

    if (MapIconAttachment != none)
    {
        MapIconAttachment.Destroy();
    }

    super.Destroyed();

    for (i = 0; i < ResupplyActors.Length; ++i)
    {
        P = ResupplyActors[i];

        if (DHPawn(P) != none)
        {
            DHPawn(P).bTouchingResupply = false;
        }
        else if (Vehicle(P) != none)
        {
            Vehicle(P).LeftResupply();
        }
    }
}

event Touch(Actor Other)
{
    local ROPawn ROP;
    local Vehicle V;

    // This stops us from the vehicle resupplying itself.
    if (Base != none && Base == Other)
    {
        return;
    }

    ROP = ROPawn(Other);
    V = Vehicle(Other);

    if (CanResupplyPawn(ROP))
    {
        ROP.bTouchingResupply = true;
    }

    if (CanResupplyPawn(V))
    {
        V.EnteredResupply();
    }
}

event UnTouch(Actor Other)
{
    local ROPawn ROP;
    local Vehicle V;

    ROP = ROPawn(Other);
    V = Vehicle(Other);

    // This stops us from the vehicle resupplying itself.
    if (Base != none && Base == Other)
    {
        return;
    }

    if (ROP != none)
    {
        ROP.bTouchingResupply = false;
    }

    if (V != none)
    {
        V.LeftResupply();
    }
}

defaultproperties
{
    RemoteRole=ROLE_DumbProxy

    TeamIndex=-1
    SquadIndex=-1
    UpdateTime=2.5
    ResupplyType=RT_All
    bDramaticLighting=true
    CollisionRadius=300
    CollisionHeight=100
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_Resupply'
}
