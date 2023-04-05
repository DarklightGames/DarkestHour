//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHImageServer extends UTImageServer;

event Query(WebRequest Request, WebResponse Response)
{
    local string Image;

    Image = Request.URI;
    if (Right(Caps(Image), 4) == ".JPG" || Right(Caps(Image), 5) == ".JPEG")
    {
        Response.SendStandardHeaders("image/jpeg", true);
    }
    else if (Right(Caps(Image), 4) == ".GIF")
    {
        Response.SendStandardHeaders("image/gif", true);
    }
    else if (Right(Caps(Image), 4) == ".BMP")
    {
        Response.SendStandardHeaders("image/bmp", true);
    }
    else
    {
        Response.HTTPError(404);
        return;
    }

    Response.IncludeBinaryFile( Path $ Image );
}
