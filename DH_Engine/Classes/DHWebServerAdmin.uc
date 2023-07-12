//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHWebServerAdmin extends UTServerAdmin config;

// Override to add ServerName arguement so we can put the servername on the header page
function QueryHeaderPage(WebRequest Request, WebResponse Response)
{
    local int i;
    local string menu, GroupPage, Dis, CurPageTitle;

    Response.Subst("ServerName", class'GameReplicationInfo'.default.ServerName);
    Response.Subst("AdminName", CurAdmin.UserName);
    Response.Subst("HeaderColSpan", "2");

    if (QueryHandlers.Length > 0)
    {
        GroupPage = Request.GetVariable("Group", QueryHandlers[0].DefaultPage);

        // We build a multi-column table for each QueryHandler
        menu = "";
        CurPageTitle = "";

        for (i = 0; i < QueryHandlers.Length; ++i)
        {
            if (QueryHandlers[i].DefaultPage == GroupPage)
            {
                CurPageTitle = QueryHandlers[i].Title;
            }

            Dis = "";

            if (QueryHandlers[i].NeededPrivs != "" && !CanPerform(QueryHandlers[i].NeededPrivs))
            {
                Dis = "d";
            }

            Response.Subst("MenuLink", RootFrame$"?Group="$QueryHandlers[i].DefaultPage);
            Response.Subst("MenuTitle", QueryHandlers[i].Title);

            menu = menu$WebInclude(HeaderPage$"_item"$Dis);
        }

        Response.Subst("Location", CurPageTitle);
        Response.Subst("HeaderMenu", menu);
    }

    if (CanPerform("Xs"))
    {
        Response.Subst("HeaderColSpan", "3");
        Response.Subst("SkinSelect", Select("WebSkin", GenerateSkinSelect()));
        Response.Subst("WebSkinSelect", WebInclude(SkinSelectInclude));
    }

    // Set URIs
    ShowPage(Response, HeaderPage);
}
