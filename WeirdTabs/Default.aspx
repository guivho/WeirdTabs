<%@ Page Language="C#" Inherits="WeirdTabs.Default" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
    <head runat="server">
        <title>WeirdTabs</title>
    </head>
    <body>
        <form id="form1" runat="server">
            <asp:TextBox runat="server" Width="200px" Rows="5" TextMode="MultiLine">Free</asp:TextBox>
            <asp:Table runat="server">
                <asp:TableRow>
                    <asp:TableCell>
                        <asp:TextBox runat="server" Width="200px" Rows="5" TextMode="MultiLine">Embedded</asp:TextBox>
                    </asp:TableCell>
                </asp:TableRow>
            </asp:Table>
            <asp:Button runat="server" Text="refresh"></asp:Button>
        </form>
    </body>
</html>
