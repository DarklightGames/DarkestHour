//=============================================================================================================
// DH_AdminMenu_Replicator - by Matt UK
//=============================================================================================================
//
// A 'helper' actor that is spawned by the actual mutator on the server
// It then gets replicated to all clients to add menu interactions & to replicate some variables for client use
//
//=============================================================================================================
class DH_AdminMenu_Replicator extends Actor;


var  array<string>  MenuArray;             // the standard local menu interactions to be created
var  string         PrivateMessage;        // stores any private message from an admin to a player, which can then be accessed by the message class
var  bool           bHasInteraction;       // a clientside fail-safe to make sure we don't create more than 1 grid overlay interaction
var  bool           bSavedHideCapProgress; // clientside record of last received value of bHideCapProgress so PostNetReceive can tell if it's changed
var  bool           bSavedHidePlayerIcon;  // clientside record of last received value of bHidePlayerIcon so PostNetReceive can tell if it's changed
var  config  bool   bClientDebug;          // clientside config flag to log various events, which can be set in the local player's own DarkestHour.ini file

// Copies of same-named variables from the mutator itself, replicated to clients so they know what the server allows them to do & know the state of certain things:
var  bool           bBypassAdminLogin, bParaDropPlayerAllowed, bShowRealismMenu, bRealismMutPresent, bMinesDisabled, bHideCapProgress, bHidePlayerIcon;
var  sound          WarningSound;

replication
{
    // Variables the server should send to the client (but only initially & will not change during play)
    reliable if (bNetInitial && Role == ROLE_Authority)
        bBypassAdminLogin, bParaDropPlayerAllowed, bShowRealismMenu, bRealismMutPresent, WarningSound;

    // Variables the server should send to the client (& may change during play)        
    reliable if (bNetDirty && Role == ROLE_Authority)
        bMinesDisabled, bHideCapProgress, bHidePlayerIcon;
        
    // Functions the server can call on the owning client
    reliable if (Role == ROLE_Authority)
        ClientPrivateMessage;
}


// Serverside, copies variables from the mutator, which will then get replicated to each clientside version of this helper actor
function PostBeginPlay()
{
    local  DH_AdminMenuMutator  AMMutator;

    super.PostBeginPlay();

    AMMutator = DH_AdminMenuMutator(Owner);

    bBypassAdminLogin      = AMMutator.bBypassAdminLogin;
    bParaDropPlayerAllowed = AMMutator.bParaDropPlayerAllowed;
    bShowRealismMenu       = AMMutator.bShowRealismMenu;
    bRealismMutPresent     = AMMutator.bRealismMutPresent;
    bMinesDisabled         = AMMutator.bMinesDisabled;
    bHidePlayerIcon        = AMMutator.bHidePlayerIcon;
    bHideCapProgress       = AMMutator.bHideCapProgress;
    WarningSound           = AMMutator.WarningSound;

    if (AMMutator != none && AMMutator.bDebug)
    {
        Log("DH_AdminMenu_Replicator: bBypassAdminLogin =" @ bBypassAdminLogin @ " bParaDropPlayerAllowed =" @ bParaDropPlayerAllowed @ " bShowRealismMenu =" @ 
            bShowRealismMenu @ " bRealismMutPresent =" @ bRealismMutPresent @ " bMinesDisabled =" @ bMinesDisabled @ " WarningSound =" @ WarningSound);
    }
}

// Clientside, this waits until the local PlayerController has been replicated & then creates the local menu interactions
simulated function Tick(float DeltaTime)
{
    local  PlayerController  PC;

    if (bHasInteraction || Level.NetMode == NM_DedicatedServer)
    {
        Disable('Tick'); // let's not carry on calling Tick many times per second if we've already created the menus or if this is a dedicated server
        return;
    }

    PC = Level.GetLocalPlayerController();

    if (PC != none && PC.GameReplicationInfo != none)
    {
        CreateLocalMenus();
    }
}

// Clientside function to create the local menu interactions for each player
simulated function CreateLocalMenus()
{
    local  PlayerController       PC;
    local  DH_AdminMenu_MenuBase  NewInteraction;
    local  int                    i;

    PC = Level.GetLocalPlayerController();

    if (PC == none) // note that if somehow this has been called on a dedicated server, PC will be none & we will exit
    {
        return;
    }

    // If the server does not allow paradrop and/or realism options, remove the associated menus from MenuArray
    if (!bParaDropPlayerAllowed && !bShowRealismMenu)
    {
        RemoveMenu("ObjectivesMenu");
    }

    if (!bShowRealismMenu)
    {
        RemoveMenu("RealismMenu");
    }

    // Add all the admin menu interactions
    for (i = 0; i < MenuArray.Length; i++)
    {
        NewInteraction = DH_AdminMenu_MenuBase(PC.Player.InteractionMaster.AddInteraction(MenuArray[i], PC.Player));

        if (NewInteraction != none)
        {
            NewInteraction.Replicator = self; // set the local menu's reference to this actor, so it can access our replicated variables
        }
    }

    // Set the fail-safe flag to make sure we don't try & create duplicate menu interactions
    bHasInteraction = true;

    // If the local player has set bClientDebug to true in their own DarkestHour.ini file, this logs replicated variables & a list of their local interactions
    if (bClientDebug)
    {
        Log("DH_AdminMenu_Replicator: bParaDropPlayerAllowed =" @ bParaDropPlayerAllowed @ " bShowRealismMenu =" @ bShowRealismMenu @ 
            " bRealismMutPresent =" @ bRealismMutPresent @ " bMinesDisabled =" @ bMinesDisabled);

        for (i = 0; i < PC.Player.LocalInteractions.Length; i++)
        {
            Log("DH_AdminMenu_Replicator: LocalInteractions["$i$"] =" @ PC.Player.LocalInteractions[i]);
        }
    }
}

// Clientside function to remove optional menus if their functionality is not allowed on the server, e.g. objectives menu (not relevant if no paradrops) or realism menu
simulated function RemoveMenu(string MenuPartName)
{
    local  int  i;

    for (i = 0; i < MenuArray.Length; i++)
    {
        if (InStr(MenuArray[i], MenuPartName) >= 0)
        {
            MenuArray.Remove(i, 1);
            break;
        }
    }
}

// Serverside function called from the mutator to give a p message to a player - it passes the info to the relevant client using a replicated client function
function ServerPrivateMessage(PlayerController Receiver, PlayerController Admin, string Message, optional bool bIsAdminWarning)
{
    if (Receiver != none && Admin != none && Message != "")
    {
        SetOwner(Receiver); // need to temporarily make the target player the owner of this actor, so we can call a replicated client function for that player
        ClientPrivateMessage(Receiver, Admin.PlayerReplicationInfo, Message, bIsAdminWarning);
        SetOwner(none); // reset
    }
}

// Replicated clientside function that passes info to client for player to receive private message on an ROCriticalMessage background in the middle of the their screen 
// Crucial part is when message function is called, this actor is included as OptionalObject parameter, allowing message to access this actor's PrivateMessage variable
simulated function ClientPrivateMessage(PlayerController Receiver, PlayerReplicationInfo AdminPRI, string Message, bool bIsAdminWarning)
{
    if (Receiver != none && AdminPRI != none && Message != "")
    {
        PrivateMessage = Message;

        if (bIsAdminWarning)
        {
            // Displays the warning in the middle of the player's screen
            Receiver.ReceiveLocalizedMessage(class'DH_AdminMenu_WarningMessage', 1, AdminPRI, , self);

            // As a backup, display the message as white chat text at the bottom of the player's screen
            Receiver.ClientMessage(class'DH_AdminMenu_WarningMessage'.default.WarningChatPrefix @ "'" $ AdminPRI.PlayerName $ "':" @ PrivateMessage);
            
            // Play a warning sound to highlight the message
            if (WarningSound != none)
            {
                Receiver.ClientPlaySound(WarningSound, false, , SLOT_Interface);
            }
        }
        else
        {
            // Displays the private message toward the top of the player's screen
            Receiver.ReceiveLocalizedMessage(class'DH_AdminMenu_PrivateMessage', 0, AdminPRI, , self);

            // As a backup, display the message as white chat text at the bottom of the player's screen
            Receiver.ClientMessage(class'DH_AdminMenu_PrivateMessage'.default.MessageChatPrefix @ "'" $ AdminPRI.PlayerName $ "':" @ PrivateMessage);
        }

        PrivateMessage = ""; // re-set
    }
}

// Serverside function, called from the mutator, which causes the ClientToggleCapProgress function to be called
// (either via replication of bHideCapProgress to a net client, or calling it directly in single player or a listen server)
function ServerToggleCapProgress(bool bHide)
{
    if (Role == ROLE_Authority)
    {
        bHideCapProgress = bHide;
    }

    if (Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer)
    {
        ClientToggleCapProgress();
    }
}

// Serverside function, called from the mutator, which causes the ClientTogglePlayerIcon function to be called
// (either via replication of bHidePlayerIcon to a net client, or calling it directly in single player or a listen server)
function ServerTogglePlayerIcon(bool bHide)
{
    if (Role == ROLE_Authority)
    {
        bHidePlayerIcon = bHide;
    }

    if (Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer)
    {
        ClientTogglePlayerIcon();
    }
}

// Native clientside event, triggered whenever a replicated variable is received
// We use it to check if bHidePlayerIcon or bHideCapProgress have changed & then toggle their functionality on the grid overlay interaction
simulated function PostNetReceive()
{
    if (bHideCapProgress != bSavedHideCapProgress)
    {
        bSavedHideCapProgress = bHideCapProgress; // save current bHideCapProgress so PostNetReceive can tell if it changes in future
        ClientToggleCapProgress();
    }

    if (bHidePlayerIcon != bSavedHidePlayerIcon)
    {
        bSavedHidePlayerIcon = bHidePlayerIcon; // save current bHidePlayerIcon so PostNetReceive can tell if it changes in future
        ClientTogglePlayerIcon();
    }
}

// Clientside function to toggle the capture progress bars at objectives
simulated function ClientToggleCapProgress()
{
    local  ROHUD  MyHUD;

    MyHUD = ROHud(Level.GetLocalPlayerController().myHUD);

    if (MyHUD != none)
    {
        if (bHideCapProgress)
        {
            MyHUD.MapIconDispute[1].Tints[0].A = 0;
            MyHUD.MapIconDispute[1].Tints[1].A = 0;
            
            MyHUD.CaptureBarAttacker.Tints[0].A = 0;
            MyHUD.CaptureBarAttacker.Tints[1].A = 0;
            
            MyHUD.CaptureBarDefender.Tints[0].A = 0;
            MyHUD.CaptureBarDefender.Tints[1].A = 0;
            
            MyHUD.CaptureBarAttackerRatio.Tints[0].A = 0;
            MyHUD.CaptureBarAttackerRatio.Tints[1].A = 0;
            
            MyHUD.CaptureBarDefenderRatio.Tints[0].A = 0;
            MyHUD.CaptureBarDefenderRatio.Tints[1].A = 0;
            
            MyHUD.CaptureBarTeamIcons[0] = none;
            MyHUD.CaptureBarTeamIcons[1] = none;
            
            MyHUD.CaptureBarTeamColors[0].A = 0;
            MyHUD.CaptureBarTeamColors[1].A = 0;
            
            MyHUD.MapIconsFlash = MyHUD.MapIconTeam[0].WidgetTexture;
            MyHUD.MapIconsFastFlash = MyHUD.MapIconTeam[0].WidgetTexture;
            MyHUD.MapIconsAltFlash = MyHUD.MapIconTeam[0].WidgetTexture;
            MyHUD.MapIconsAltFastFlash = MyHUD.MapIconTeam[0].WidgetTexture;
        }
        else
        {
            MyHUD.MapIconDispute[0].Tints[0] = MyHUD.default.MapIconDispute[0].Tints[0];
            MyHUD.MapIconDispute[0].Tints[1] = MyHUD.default.MapIconDispute[0].Tints[1];
            
            MyHUD.MapIconDispute[1].Tints[0] = MyHUD.default.MapIconDispute[1].Tints[0];
            MyHUD.MapIconDispute[1].Tints[1] = MyHUD.default.MapIconDispute[1].Tints[1];
            
            MyHUD.CaptureBarAttacker.Tints[0] = MyHUD.default.CaptureBarAttacker.Tints[0];
            MyHUD.CaptureBarAttacker.Tints[1] = MyHUD.default.CaptureBarAttacker.Tints[1];
            
            MyHUD.CaptureBarDefender.Tints[0] = MyHUD.default.CaptureBarDefender.Tints[0];
            MyHUD.CaptureBarDefender.Tints[1] = MyHUD.default.CaptureBarDefender.Tints[1];
            
            MyHUD.CaptureBarAttackerRatio.Tints[0] = MyHUD.default.CaptureBarAttackerRatio.Tints[0];
            MyHUD.CaptureBarAttackerRatio.Tints[1] = MyHUD.default.CaptureBarAttackerRatio.Tints[1];
            
            MyHUD.CaptureBarDefenderRatio.Tints[0] = MyHUD.default.CaptureBarDefenderRatio.Tints[0];
            MyHUD.CaptureBarDefenderRatio.Tints[1] = MyHUD.default.CaptureBarDefenderRatio.Tints[1];
            
            MyHUD.CaptureBarTeamIcons[0] = MyHUD.default.CaptureBarTeamIcons[0];
            MyHUD.CaptureBarTeamIcons[1] = MyHUD.default.CaptureBarTeamIcons[1];
            
            MyHUD.CaptureBarTeamColors[0] = MyHUD.default.CaptureBarTeamColors[0];
            MyHUD.CaptureBarTeamColors[1] = MyHUD.default.CaptureBarTeamColors[1];
            
            MyHUD.MapIconsFlash = MyHUD.default.MapIconsFlash;
            MyHUD.MapIconsFastFlash = MyHUD.default.MapIconsFastFlash;
            MyHUD.MapIconsAltFlash = MyHUD.default.MapIconsAltFlash;
            MyHUD.MapIconsAltFastFlash = MyHUD.default.MapIconsAltFastFlash;
        }
    }
}

// Clientside function to toggle the player icon on the map
simulated function ClientTogglePlayerIcon()
{
    local  ROHUD  MyHUD;

    MyHUD = ROHud(Level.GetLocalPlayerController().myHUD);

    if (MyHUD != none)
    {
        if (bHidePlayerIcon)
        {
            MyHUD.MapPlayerIcon.Tints[0].A = 0;
            MyHUD.MapPlayerIcon.Tints[1].A = 0;
        }
        else
        {
            MyHUD.MapPlayerIcon.Tints[0].A = 255;
            MyHUD.MapPlayerIcon.Tints[1].A = 255;
        }
    }
}

// To cleanly remove all admin menu local interactions if this Replicator actor is destroyed
// Including setting all actor references in menus to 'none', which is important when dealing with actor references in non-actor objects
simulated function Destroyed()
{
    local  PlayerController       PC;
    local  DH_AdminMenu_MenuBase  AdminMenu;
    local  int                    i;

    PC = Level.GetLocalPlayerController();
    
    if (PC != none && PC.Player != none)
    {    
        for (i = 0; i < PC.Player.LocalInteractions.Length; i++)
        {
            AdminMenu = DH_AdminMenu_MenuBase(PC.Player.LocalInteractions[i]);
            
            if (AdminMenu != none)
            {
                AdminMenu.RemoveThisInteraction();
            }
        }
    }

    super.Destroyed();
}

defaultproperties
{
    MenuArray(0)="DH_AdminMenuMutator_WIP.DH_AdminMenu_PlayerMenu"
    MenuArray(1)="DH_AdminMenuMutator_WIP.DH_AdminMenu_PlayerActionsMenu"
    MenuArray(2)="DH_AdminMenuMutator_WIP.DH_AdminMenu_RolesMenu"
    MenuArray(3)="DH_AdminMenuMutator_WIP.DH_AdminMenu_ObjectivesMenu"
    MenuArray(4)="DH_AdminMenuMutator_WIP.DH_AdminMenu_RealismMenu"

    bNetNotify=true // so the PostNetReceive event gets called when a variable is replicated (for toggling bHidePlayerIcon & bHideCapProgress)

    // the same properties a ReplicationInfo actor would have:
    RemoteRole=ROLE_SimulatedProxy
    bAlwaysRelevant=true
    NetUpdateFrequency=10.0
    bOnlyDirtyReplication=true
    bSkipActorPropertyReplication=true
    bHidden=true
}
