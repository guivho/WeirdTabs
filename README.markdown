Weird tab injection in multiline text boxes
===========================================

Summary
-------

Mono injects two tab characters (i.e. `\t\t`) in front of any text displayed
in multiline text boxes that are embedded as content in an `<asp:TableCell>`
within an `<asp:TableRow>` of an `<asp:Table>`.

Two additional tab characters are injected at every single postback.

This happens with the Mono Framework 2.10.8.

It can be observed with web applications rendered with xsp4 as well as
with mod-mono-server4.

### Version info

* /Library/Frameworks/Mono.framework/Versions/2.10.8/bin/mono
* /Library/Frameworks/Mono.framework/Versions/2.10.8/lib/mono/4.0/xsp4.exe
* /Library/Frameworks/Mono.framework/Versions/2.10.8/lib/mono/4.0/mod-mono-server4.exe

#### Mono

    $ mono --version
    Mono JIT compiler version 2.10.8 (tarball Mon Dec 19 17:43:18 EST 2011)
    Copyright (C) 2002-2011 Novell, Inc, Xamarin, Inc and Contributors. www.mono-project.com
            TLS:           normal
            SIGSEGV:       normal
            Notification:  kqueue
            Architecture:  x86
            Disabled:      none
            Misc:          debugger softdebug
            LLVM:          yes(2.9svn-mono)
            GC:            Included Boehm (with typed GC)

#### Xsp4

    $ xsp4 --version
    xsp4.exe 2.10.2.0
    Copyright (C) 2002-2011 Novell, Inc.
    Minimalistic web server for testing System.Web

#### Mod-mono

    $ mod-mono-server4 --version
    mod-mono-server4.exe 2.10.2.0
    (c) (c) 2002-2011 Novell, Inc.
    Mod_mono backend for XSP

WeirdTabs application
---------------------

WeirdTabs is a minimalistic application designed to clearly demonstrate the
problem.

### Relevant application controls and logic

The application only has one single page, the `Default.aspx` page. It
only has three controls:

- Multiline `<asp:TextBox>` with hardcoded initial text `Free`
- Multiline `<asp:TextBox>` with hardcoded initial text `Embedded`. This
  box is nested within an `<asp:TableCell>`.
- Button to trigger a postback

#### Here's the `Default.aspx` file:

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

#### The `Default.aspx.cs` file is a mere skeleton, it does not have any processing logic:

    using System.Web.UI;

    namespace WeirdTabs
    {
        public partial class Default : Page
        {
        }
    }

### Expected behaviour

[Expected behaviour](expected.png)

This application should display two multiline text areas with text content
sitting right at column 0 and row 0.

The first box should have `Free` as text, the second box should show
`Embedded`.

Whenever the `refresh` button is clicked, this page should be rerendered
without causing any change to the content of the text boxes.


### Observed behaviour

[Observed behaviour](observed.png)

The first box displays `Free` as it is supposed to.

The second box displays

    \t\tEmbedded

thus displaying two injected tabs in front of the text.

Note that the `\t` escape sequence shown in this text represents one
single tab character with hex value `x09`.

At every single postback, two more tabs are injected, as in

    \t\t\t\tEmbedded
    \t\t\t\t\t\tEmbedded
    \t\t\t\t\t\t\t\tEmbedded, etc.


### Behaviour on IIS Server

This test application behaves as expected when running on an IIS server.


Conclusion
----------

This erroneous behaviour occurs with any multiline `<asp:TextBox>` that is
content of an `<asp:TableCell>` in an `<asp:TableRow>` of an `<asp:Table>`.


Miscellaneous notes
-------------------

- The error does not occur with non-multiline text nor with non-embedded
  text boxes.

- The content of the `WeirdTabs` boxes is hard coded to keep it simple.
  The error occurs regardless of the source of the text box content.

