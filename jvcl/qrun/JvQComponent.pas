{**************************************************************************************************}
{  WARNING:  JEDI preprocessor generated unit. Manual modifications will be lost on next release.  }
{**************************************************************************************************}

{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvComponent.PAS, released on 2000-09-22.

The Initial Developer of the Original Code is Joe Doe .
Portions created by Joe Doe are Copyright (C) 1999 Joe Doe.
Portions created by XXXX Corp. are Copyright (C) 1998, 1999 XXXX Corp.
All Rights Reserved.

Contributor(s): -

Last Modified: 2004-01-16

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I jvcl.inc}

unit JvQComponent;

interface

uses
  Classes,
  {$IFDEF USE_DXGETTEXT}
  gnugettext,
  {$ENDIF USE_DXGETTEXT}
  
  JVQCLVer, JvQExControls, JvQExExtCtrls, JvQExComCtrls, JvQExForms, JvQExStdCtrls;

type
  TJvComponent = class(TComponent)
  private
    FAboutJVCL: TJVCLAboutInfo;
  published
    property AboutJVCL: TJVCLAboutInfo read FAboutJVCL write FAboutJVCL stored False;
  end;

  TJvGraphicControl = class(TJvExGraphicControl);
  TJvPubGraphicControl = class(TJvExPubGraphicControl);

  TJvCustomTreeView = class(TJvExCustomTreeView);
  TJvPubCustomTreeView = class(TJvExPubCustomTreeView);

  TJvCustomPanel = class(TJvExCustomPanel);
  TJvPubCustomPanel = class(TJvExPubCustomPanel);

  TJvCustomControl = class(TJvExCustomControl);
  TJvPubCustomControl = class(TJvExPubCustomControl);

  TJvWinControl = class(TJvExPubWinControl);
  TJvPubWinControl = class(TJvExPubWinControl);

  TJvForm = class(TJvExForm)
  {$IFDEF USE_DXGETTEXT}
  public
    constructor Create(AOwner: TComponent); override;
    procedure RefreshTranslation; virtual;
  {$ENDIF USE_DXGETTEXT}
  end;

//=== TJvPopupListBox ========================================================



implementation

//=== TJvForm ================================================================

{$IFDEF USE_DXGETTEXT}
constructor TJvForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TranslateComponent(Self);
end;

procedure TJvForm.RefreshTranslation;
begin
  ReTranslateComponent(self);
end;

{$ENDIF USE_DXGETTEXT}



{$IFDEF USE_DXGETTEXT}
initialization
  AddDomainForResourceString('jvcl');

{$ENDIF USE_DXGETTEXT}

end.
