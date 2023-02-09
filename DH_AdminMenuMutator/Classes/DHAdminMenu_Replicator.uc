//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

// A 'helper' actor that is spawned by the actual mutator on the server (very similar to a ReplicationInfo actor)
// It then gets replicated to all clients to add menu interactions & to replicate some variables for client use
class DHAdminMenu_Replicator extends Actor;

var     array<string>   MenuArray;        // the standard local menu interactions to be created
var     string          PrivateMessage;   // stores any private message from an admin to a player, which can then be accessed by the message class
var     bool            bHasInteraction;  // client fail-safe to make sure we don't create more than 1 grid overlay interaction
var     config bool     bClientDebug;     // client config flag to log various events, which can be set in the local player's own DarkestHour.ini file
var     float           NewElapsedTime;   // set if mutator modifies the round time remaining, allowing it to be replicated & used to update GRI.ElapsedTime on clients

// Clientside records of last received values, so PostNetReceive can tell if they've changed
var     bool            bSavedHideCapProgress;
var     bool            bSavedHidePlayerIcon;
var     float           SavedNewElapsedTime;

// Copies of same-named variables from the mutator itself, replicated to clients so they know the server's settings
var     bool            bBypassAdminLogin, bParaDropPlayerAllowed, bShowRealismMenu, bRealismMutPresent, bMinesDisabled, bHideCapProgress, bHidePlayerIcon;
var     sound           WarningSound;

replication
{
    // Variables server sends to clients (but only initially & will not change during play)
    reliable if (bNetInitial && Role == ROLE_Authority)
        bBypassAdminLogin, bParaDropPlayerAllowed, bShowRealismMenu, bRealismMutPresent, WarningSound;

    // Variables server sends to clients (& may change during play)
    reliable if (bNetDirty && Role == ROLE_Authority)
        bMinesDisabled, bHideCapProgress, bHidePlayerIcon, NewElapsedTime;

    // Functions the server can call on the owning client
    reliable if (Role == ROLE_Authority)
        ClientRenamePlayer, ClientPrivateMessage;
}

// On the server this copies variables from the mutator, which will then get replicated to each client version of this helper actor
// On a client it resets the LifeTime of each message class back to defaults, in case GameSpeed was altered last round
simulated function PostBeginPlay()
{
    local DHAdminMenuMutator AMMutator;

    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        AMMutator = DHAdminMenuMutator(Owner);

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
            Log("DHAdminMenu_Replicator: bBypassAdminLogin =" @ bBypassAdminLogin @ " bParaDropPlayerAllowed =" @ bParaDropPlayerAllowed @ " bShowRealismMenu =" @
                bShowRealismMenu @ " bRealismMutPresent =" @ bRealismMutPresent @ " bMinesDisabled =" @ bMinesDisabled @ " WarningSound =" @ WarningSound);
        }
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        SetMessageClassLifeTimes(1.0);
    }
}

// Used to adjust default LifeTime in message classes to take account of the GameSpeed, so messages stay on screen for the same time even if GameSpeed is changed
static function SetMessageClassLifeTimes(float GameSpeed)
{
    class'DH_AdminMenuMutator.DHAdminMenu_NotifyMessages'.default.LifeTime = int(Round(8.0 * GameSpeed));
    class'DH_AdminMenuMutator.DHAdminMenu_WarningMessage'.default.LifeTime = int(Round(9.0 * GameSpeed));
    class'DH_AdminMenuMutator.DHAdminMenu_PrivateMessage'.default.LifeTime = int(Round(9.0 * GameSpeed));
    class'DH_AdminMenuMutator.DHAdminMenu_AdminMessages'.default.LifeTime  = int(Round(5.0 * GameSpeed));
    class'DH_AdminMenuMutator.DHAdminMenu_ErrorMessages'.default.LifeTime  = int(Round(3.0 * GameSpeed));
}

// On clients this waits until the local PlayerController has been replicated & then creates the local menu interactions
simulated function Tick(float DeltaTime)
{
    local PlayerController PC;

    if (bHasInteraction || Level.NetMode == NM_DedicatedServer)
    {
        Disable('Tick'); // let's not carry on calling Tick many times per second if we've already created the menus or if this is a dedicated server

        return;
    }

    PC = Level.GetLocalPlayerController();

    if (PC != none && PC.GameReplicationInfo != none)
    {
        CreateLocalMenus(PC);
    }
}

// Clientside function to create the local menu interactions for each player
simulated function CreateLocalMenus(PlayerController PC)
{
    local DHAdminMenu_MenuBase NewInteraction;
    local int                   i;

    if (PC == none)
    {
        return;
    }

    // If the server does not allow paradrop and/or realism/testing options, remove the associated menus from MenuArray
    if (!bParaDropPlayerAllowed && !bShowRealismMenu)
    {
        RemoveMenu("ObjectivesMenu");
    }

    if (!bShowRealismMenu)
    {
        RemoveMenu("RealismMenu");
    }

    // Add all the admin menu interactions
    for (i = 0; i < MenuArray.Length; ++i)
    {
        NewInteraction = DHAdminMenu_MenuBase(PC.Player.InteractionMaster.AddInteraction(MenuArray[i], PC.Player));

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
        Log("DHAdminMenu_Replicator: bParaDropPlayerAllowed =" @ bParaDropPlayerAllowed @ " bShowRealismMenu =" @ bShowRealismMenu @
            " bRealismMutPresent =" @ bRealismMutPresent @ " bMinesDisabled =" @ bMinesDisabled);

        for (i = 0; i < PC.Player.LocalInteractions.Length; ++i)
        {
            Log("DHAdminMenu_Replicator: LocalInteractions[" $ i $ "] =" @ PC.Player.LocalInteractions[i]);
        }
    }
}

// Clientside function to remove optional menus if their functionality is not allowed on the server, e.g. objectives menu (not relevant if no paradrops) or realism menu
simulated function RemoveMenu(string MenuPartName)
{
    local int i;

    for (i = 0; i < MenuArray.Length; ++i)
    {
        if (InStr(MenuArray[i], MenuPartName) >= 0)
        {
            MenuArray.Remove(i, 1);
            break;
        }
    }
}

// Serverside function called from the mutator to change the player name on the client - it passes the info to the relevant client using a replicated client function
function ServerRenamePlayer(Controller PlayerToRename, string NewPlayerName)
{
    if (PlayerToRename != none && NewPlayerName != "")
    {
        SetOwner(PlayerToRename); // need to temporarily make the target player the owner of this actor, so we can call a replicated client function for that player
        ClientRenamePlayer(PlayerToRename, NewPlayerName);
        SetOwner(none); // reset
    }
}

// Replicated clientside function that passes info to client for player to receive private message on an ROCriticalMessage background in the middle of the their screen
// Crucial part is when message function is called, this actor is included as OptionalObject parameter, allowing message to access this actor's PrivateMessage variable
simulated function ClientRenamePlayer(Controller PlayerToRename, string NewPlayerName)
{
    if (PlayerToRename != none && NewPlayerName != "")
    {
        PlayerToRename.UpdateURL("Name", NewPlayerName, true);
        PlayerToRename.SaveConfig();
    }
}

// Serverside function called from the mutator to give a message to a player - it passes the info to the relevant client using a replicated client function
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
            Receiver.ReceiveLocalizedMessage(class'DH_AdminMenuMutator.DHAdminMenu_WarningMessage', 1, AdminPRI,, self);

            // As a backup, display the message as white chat text at the bottom of the player's screen
            Receiver.ClientMessage(class'DH_AdminMenuMutator.DHAdminMenu_WarningMessage'.default.WarningChatPrefix @ "'" $ AdminPRI.PlayerName $ "':" @ PrivateMessage);

            // Play a warning sound to highlight the message
            if (WarningSound != none)
            {
                Receiver.ClientPlaySound(WarningSound, false,, SLOT_Interface);
            }
        }
        else
        {
            // Displays the private message toward the top of the player's screen
            Receiver.ReceiveLocalizedMessage(class'DH_AdminMenuMutator.DHAdminMenu_PrivateMessage', 0, AdminPRI,, self);

            // As a backup, display the message as white chat text at the bottom of the player's screen
            Receiver.ClientMessage(class'DH_AdminMenuMutator.DHAdminMenu_PrivateMessage'.default.MessageChatPrefix @ "'" $ AdminPRI.PlayerName $ "':" @ PrivateMessage);
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
// We use it to check if bHidePlayerIcon, bHideCapProgress or NewElapsedTime have changed & call their functionality on each client
simulated function PostNetReceive()
{
    local PlayerController PC;

    if (bHideCapProgress != bSavedHideCapProgress)
    {
        bSavedHideCapProgress = bHideCapProgress;
        ClientToggleCapProgress();
    }

    if (bHidePlayerIcon != bSavedHidePlayerIcon)
    {
        bSavedHidePlayerIcon = bHidePlayerIcon;
        ClientTogglePlayerIcon();
    }

    if (NewElapsedTime != SavedNewElapsedTime)
    {
        SavedNewElapsedTime = NewElapsedTime;
        PC = Level.GetLocalPlayerController();

        if (PC != none && PC.GameReplicationInfo != none)
        {
            PC.GameReplicationInfo.ElapsedTime = NewElapsedTime;
        }
    }
}

// Clientside function to toggle the capture progress bars at objectives
simulated function ClientToggleCapProgress()
{
    local ROHUD HUD;

    HUD = ROHud(Level.GetLocalPlayerController().myHUD);

    if (HUD != none)
    {
        if (bHideCapProgress)
        {
            HUD.MapIconDispute[1].Tints[0].A = 0;
            HUD.MapIconDispute[1].Tints[1].A = 0;
            HUD.CaptureBarAttacker.Tints[0].A = 0;
            HUD.CaptureBarAttacker.Tints[1].A = 0;
            HUD.CaptureBarDefender.Tints[0].A = 0;
            HUD.CaptureBarDefender.Tints[1].A = 0;
            HUD.CaptureBarAttackerRatio.Tints[0].A = 0;
            HUD.CaptureBarAttackerRatio.Tints[1].A = 0;
            HUD.CaptureBarDefenderRatio.Tints[0].A = 0;
            HUD.CaptureBarDefenderRatio.Tints[1].A = 0;
            HUD.CaptureBarTeamIcons[0] = none;
            HUD.CaptureBarTeamIcons[1] = none;
            HUD.CaptureBarTeamColors[0].A = 0;
            HUD.CaptureBarTeamColors[1].A = 0;
            HUD.MapIconsFlash = HUD.MapIconTeam[0].WidgetTexture;
            HUD.MapIconsFastFlash = HUD.MapIconTeam[0].WidgetTexture;
            HUD.MapIconsAltFlash = HUD.MapIconTeam[0].WidgetTexture;
            HUD.MapIconsAltFastFlash = HUD.MapIconTeam[0].WidgetTexture;
        }
        else
        {
            HUD.MapIconDispute[0].Tints[0] = HUD.default.MapIconDispute[0].Tints[0];
            HUD.MapIconDispute[0].Tints[1] = HUD.default.MapIconDispute[0].Tints[1];
            HUD.MapIconDispute[1].Tints[0] = HUD.default.MapIconDispute[1].Tints[0];
            HUD.MapIconDispute[1].Tints[1] = HUD.default.MapIconDispute[1].Tints[1];
            HUD.CaptureBarAttacker.Tints[0] = HUD.default.CaptureBarAttacker.Tints[0];
            HUD.CaptureBarAttacker.Tints[1] = HUD.default.CaptureBarAttacker.Tints[1];
            HUD.CaptureBarDefender.Tints[0] = HUD.default.CaptureBarDefender.Tints[0];
            HUD.CaptureBarDefender.Tints[1] = HUD.default.CaptureBarDefender.Tints[1];
            HUD.CaptureBarAttackerRatio.Tints[0] = HUD.default.CaptureBarAttackerRatio.Tints[0];
            HUD.CaptureBarAttackerRatio.Tints[1] = HUD.default.CaptureBarAttackerRatio.Tints[1];
            HUD.CaptureBarDefenderRatio.Tints[0] = HUD.default.CaptureBarDefenderRatio.Tints[0];
            HUD.CaptureBarDefenderRatio.Tints[1] = HUD.default.CaptureBarDefenderRatio.Tints[1];
            HUD.CaptureBarTeamIcons[0] = HUD.default.CaptureBarTeamIcons[0];
            HUD.CaptureBarTeamIcons[1] = HUD.default.CaptureBarTeamIcons[1];
            HUD.CaptureBarTeamColors[0] = HUD.default.CaptureBarTeamColors[0];
            HUD.CaptureBarTeamColors[1] = HUD.default.CaptureBarTeamColors[1];
            HUD.MapIconsFlash = HUD.default.MapIconsFlash;
            HUD.MapIconsFastFlash = HUD.default.MapIconsFastFlash;
            HUD.MapIconsAltFlash = HUD.default.MapIconsAltFlash;
            HUD.MapIconsAltFastFlash = HUD.default.MapIconsAltFastFlash;
        }
    }
}

// Clientside function to toggle the player icon on the map
simulated function ClientTogglePlayerIcon()
{
    local DHHud HUD;

    HUD = DHHud(Level.GetLocalPlayerController().myHUD);

    if (HUD != none)
    {
        if (bHidePlayerIcon)
        {
            HUD.MapPlayerIcon.RenderStyle = STY_None;
            HUD.PlayerNumberText.RenderStyle = STY_None;
        }
        else
        {
            HUD.MapPlayerIcon.RenderStyle = HUD.default.MapPlayerIcon.RenderStyle;
            HUD.PlayerNumberText.RenderStyle = HUD.default.PlayerNumberText.RenderStyle;
        }
    }
}

// To cleanly remove all admin menu local interactions if this Replicator actor is destroyed
// Including setting all actor references in menus to 'none', which is important when dealing with actor references in non-actor objects
simulated function Destroyed()
{
    local PlayerController      PC;
    local DHAdminMenu_MenuBase AdminMenu;
    local int                   i;

    PC = Level.GetLocalPlayerController();

    if (PC != none && PC.Player != none)
    {
        for (i = 0; i < PC.Player.LocalInteractions.Length; ++i)
        {
            AdminMenu = DHAdminMenu_MenuBase(PC.Player.LocalInteractions[i]);

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
    MenuArray(0)="DH_AdminMenuMutator.DHAdminMenu_PlayerMenu"
    MenuArray(1)="DH_AdminMenuMutator.DHAdminMenu_PlayerActionsMenu"
    MenuArray(2)="DH_AdminMenuMutator.DHAdminMenu_RolesMenu"
    MenuArray(3)="DH_AdminMenuMutator.DHAdminMenu_ObjectivesMenu"
    MenuArray(4)="DH_AdminMenuMutator.DHAdminMenu_RealismMenu"
    MenuArray(5)="DH_AdminMenuMutator.DHAdminMenu_ServerMenu"

    bNetNotify=true // so the PostNetReceive event gets called when a variable is replicated (for toggling bHidePlayerIcon & bHideCapProgress)

    // The same properties a ReplicationInfo actor would have:
    RemoteRole=ROLE_SimulatedProxy
    bAlwaysRelevant=true
    NetUpdateFrequency=10.0
    bOnlyDirtyReplication=true
    bSkipActorPropertyReplication=true
    bHidden=true
}
