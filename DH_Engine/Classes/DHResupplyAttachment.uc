//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHResupplyAttachment extends RODummyAttachment
    notplaceable;

enum EResupplyType
{
    RT_Players,
    RT_Vehicles,
    RT_All,
    RT_Mortars
};

var     private int     TeamIndex;      // Team this volume resupplies
var     EResupplyType   ResupplyType;   // Who this volume will resupply
var     array<Pawn>     ResupplyActors;
var     float           UpdateTime;     // How often this thing needs to do it's business

var     class<DHMapIconAttachment> MapIconAttachmentClass;
var     DHMapIconAttachment        MapIconAttachment;

delegate OnPawnResupplied(Pawn P);            // Called for every pawn that is resupplied

function OnTeamIndexChanged();

function PostBeginPlay()
{
    super(Actor).PostBeginPlay();

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

final function SetResupplyType(EResupplyType ResupplyType)
{
    self.ResupplyType = ResupplyType;

    if (MapIconAttachment != none)
    {
        DHMapIconAttachment_Resupply(MapIconAttachment).SetResupplyType(ResupplyType);
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
    local inventory recvr_inv;
    local ROWeapon recvr_weapon;
    local bool bResupplied;
    local DHPawn P;
    local Vehicle V;
    local DHRoleInfo RI;

    ProcessActorLeave();

    ResupplyActors.Remove(0, ResupplyActors.Length);

    foreach RadiusActors(class'Pawn', recvr, CollisionRadius)
    {
        // This stops us from the vehicle resupplying itself.
        if (Base != none && Base == P)
        {
            continue;
        }

        if (TeamIndex == NEUTRAL_TEAM_INDEX || recvr.GetTeamNum() == TeamIndex)
        {
            bResupplied = false;
            P = DHPawn(recvr);
            V = Vehicle(recvr);

            if (P != none && (ResupplyType == RT_Players || ResupplyType == RT_All))
            {
                //Add him into our resupply list.
                ResupplyActors[ResupplyActors.Length] = P;
                P.bTouchingResupply = true;
            }
            else if (V != none && V != Base && (ResupplyType == RT_Vehicles || ResupplyType == RT_All))
            {
                ResupplyActors[ResupplyActors.Length] = V;
                V.bTouchingResupply = true;
            }

            if (Level.TimeSeconds - recvr.LastResupplyTime >= UpdateTime)
            {
                if (P != none)
                {
                    RI = P.GetRoleInfo();
                }

                if (P != none && (ResupplyType == RT_Players || ResupplyType == RT_All))
                {
                    //Resupply weapons
                    for (recvr_inv = P.Inventory; recvr_inv != none; recvr_inv = recvr_inv.Inventory)
                    {
                        recvr_weapon = ROWeapon(recvr_inv);

                        if (recvr_weapon == none || recvr_weapon.IsGrenade() || recvr_weapon.IsA('DHMortarWeapon'))
                        {
                            continue;
                        }

                        if (recvr_weapon.FillAmmo())
                        {
                            bResupplied = true;
                        }
                    }

                    if (RI != none && P.bUsedCarriedMGAmmo && P.bCarriesExtraAmmo)
                    {
                        P.bUsedCarriedMGAmmo = false;
                        bResupplied = true;
                    }
                }

                if (V != none && (ResupplyType == RT_Vehicles || ResupplyType == RT_All) && !V.IsA('DHMortarVehicle'))
                {
                    // Resupply vehicles
                    if (V.ResupplyAmmo())
                    {
                        bResupplied = true;
                    }
                }

                //Mortar specific resupplying.
                if (ResupplyType == RT_Players || ResupplyType == RT_Mortars || ResupplyType == RT_All)
                {
                    // Resupply player carrying a mortar
                    if (P != none)
                    {
                        if (RI != none && RI.bCanUseMortars && P.ResupplyMortarAmmunition())
                        {
                            bResupplied = true;
                        }

                        if (P.bUsedCarriedMGAmmo && P.bCarriesExtraAmmo)
                        {
                            P.bUsedCarriedMGAmmo = false;
                            bResupplied = true;
                        }
                    }
                    // Resupply deployed mortar
                    else if (DHMortarVehicle(V) != none && V.ResupplyAmmo())
                    {
                        bResupplied = true;
                    }
                }

                //Play sound if applicable
                if (bResupplied)
                {
                    recvr.LastResupplyTime = Level.TimeSeconds;
                    recvr.ClientResupplied();

                    OnPawnResupplied(recvr);
                }
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

    if (ROP != none && (ROP.GetTeamNum() == TeamIndex || TeamIndex == NEUTRAL_TEAM_INDEX))
    {
        ROP.bTouchingResupply = true;
    }

    if (V != none && (V.GetTeamNum() == TeamIndex || TeamIndex == NEUTRAL_TEAM_INDEX))
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
    UpdateTime=2.5
    ResupplyType=RT_All
    bDramaticLighting=true
    CollisionRadius=300
    CollisionHeight=100
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_Resupply'
}
