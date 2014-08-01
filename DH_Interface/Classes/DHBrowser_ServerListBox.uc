//====================================================================
//  DHBrowser_ServerListBox
// ====================================================================
class DHBrowser_ServerListBox extends UT2K4Browser_ServerListBox;

defaultproperties
{
     OpenIPPage="DH_Interface.DHBrowser_OpenIP"
     Begin Object Class=GUIMultiColumnListHeader Name=MyHeader
         BarStyleName="DHMultiColBar"
         StyleName="DHMultiColBar"
     End Object
     Header=GUIMultiColumnListHeader'DH_Interface.DHBrowser_ServerListBox.MyHeader'

     SelectedStyleName="DHListSelectionStyle"
     DefaultListClass="DH_Interface.DHBrowser_ServersList"
     Begin Object Class=DHGUIVertScrollBar Name=TheScrollbar
         bVisible=false
         OnPreDraw=TheScrollbar.GripPreDraw
     End Object
     MyScrollBar=DHGUIVertScrollBar'DH_Interface.DHBrowser_ServerListBox.TheScrollbar'

     StyleName="DHComboListBox"
     Begin Object Class=GUIContextMenu Name=RCMenu
         ContextItems(0)="Join Server"
         ContextItems(1)="Join As Spectator"
         ContextItems(2)="-"
         ContextItems(3)="Refresh Server Info"
         ContextItems(4)="Refresh List"
         ContextItems(5)="-"
         ContextItems(6)="Configure Filters"
         ContextItems(7)="Create Template"
         ContextItems(8)="Deactivate All Filters"
         ContextItems(9)="-"
         ContextItems(10)="Add To Favorites"
         ContextItems(11)="Copy server address"
         ContextItems(12)="Open IP"
         OnOpen=DHBrowser_ServerListBox.InternalOnOpen
         OnClose=DHBrowser_ServerListBox.InternalOnClose
         OnSelect=DHBrowser_ServerListBox.InternalOnClick
     End Object
     ContextMenu=GUIContextMenu'DH_Interface.DHBrowser_ServerListBox.RCMenu'

}
