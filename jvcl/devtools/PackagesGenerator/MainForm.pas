unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, JvMenus, ComCtrls, JvToolBar, ToolWin, JvCoolBar,
  JvStatusBar, ExtCtrls, JvSplitter, StdCtrls, JvListBox, JvCtrls,
  JvControlBar, ImgList, ActnList, JvComponent, JvBaseDlg, JvBrowseFolder,
  Mask, JvToolEdit, AppEvnts, Grids, JvGrids, JvFormPlacement, JvAppStore,
  JvAppIniStore, JvStringGrid;

type
  TfrmMain = class(TForm)
    jmmMain: TJvMainMenu;
    mnuFile: TMenuItem;
    jsbStatus: TJvStatusBar;
    jtbMenus: TJvToolBar;
    mnuExit: TMenuItem;
    mnuNavigation: TMenuItem;
    pnlList: TPanel;
    jspLeft: TJvSplitter;
    jlbList: TJvListBox;
    jcbMain: TJvControlBar;
    jtbTools: TJvToolBar;
    tbtOpen: TToolButton;
    tbtSave: TToolButton;
    aclActions: TActionList;
    imlActive: TImageList;
    imlDisabled: TImageList;
    actExit: TAction;
    actSave: TAction;
    actNew: TAction;
    actPrevPackage: TAction;
    actNextPackage: TAction;
    tbtExit: TToolButton;
    ToolButton4: TToolButton;
    tbtPrevPackage: TToolButton;
    tbtNextPackage: TToolButton;
    N1: TMenuItem;
    mnuOpen: TMenuItem;
    mnuSave: TMenuItem;
    mnuPreviousPackage: TMenuItem;
    mnuNextPackage: TMenuItem;
    jbfFolder: TJvBrowseForFolderDialog;
    pnlEdit: TPanel;
    Panel1: TPanel;
    jdePackagesLocation: TJvDirectoryEdit;
    Label1: TLabel;
    aevEvents: TApplicationEvents;
    ledName: TLabeledEdit;
    rbtRuntime: TRadioButton;
    rbtDesign: TRadioButton;
    ledDescription: TLabeledEdit;
    lblDependencies: TLabel;
    jsgDependencies: TJvStringGrid;
    jsgFiles: TJvStringGrid;
    lblFiles: TLabel;
    odlAddFiles: TOpenDialog;
    ledC5PFlags: TLabeledEdit;
    ledC6PFlags: TLabeledEdit;
    actSaveAll: TAction;
    actAddFiles: TAction;
    ToolButton1: TToolButton;
    actGenerate: TAction;
    tbtGenerate: TToolButton;
    procedure actExitExecute(Sender: TObject);
    procedure actNewExecute(Sender: TObject);
    procedure aevEventsHint(Sender: TObject);
    procedure jsgDependenciesGetCellAlignment(Sender: TJvStringGrid;
      AColumn, ARow: Integer; State: TGridDrawState;
      var CellAlignment: TAlignment);
    procedure jsgDependenciesExitCell(Sender: TJvStringGrid; AColumn,
      ARow: Integer; const EditText: String);
    procedure actAddFilesExecute(Sender: TObject);
    procedure actSaveUpdate(Sender: TObject);
    procedure ledC6PFlagsChange(Sender: TObject);
    procedure ledC5PFlagsChange(Sender: TObject);
    procedure jsgFilesSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure jsgDependenciesSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: String);
    procedure ledDescriptionChange(Sender: TObject);
    procedure ledNameChange(Sender: TObject);
    procedure rbtDesignClick(Sender: TObject);
    procedure rbtRuntimeClick(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actPrevPackageUpdate(Sender: TObject);
    procedure actNextPackageUpdate(Sender: TObject);
    procedure jlbListClick(Sender: TObject);
    procedure actGenerateExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actPrevPackageExecute(Sender: TObject);
    procedure actNextPackageExecute(Sender: TObject);
  private
    { Private declarations }
    Changed : Boolean; // true if current file has changed

    procedure LoadPackagesList;
    procedure LoadPackage;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
  end;

var
  frmMain: TfrmMain;

implementation

uses FileUtils, JvSimpleXml, JclFileUtils, JclStrings;
{$R *.dfm}

procedure TfrmMain.actExitExecute(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmMain.actNewExecute(Sender: TObject);
begin
//
end;

procedure TfrmMain.aevEventsHint(Sender: TObject);
begin
  jsbStatus.Panels[0].Text:= GetLongHint(Application.Hint);
end;

constructor TfrmMain.Create(AOwner: TComponent);
var i : integer;
begin
  inherited;
  with jsgDependencies do
  begin
    Cells[0, 0] := 'Name';
    Cells[1, 0] := 'D5';
    Cells[2, 0] := 'D6';
    Cells[3, 0] := 'D7';
    Cells[4, 0] := 'C5';
    Cells[5, 0] := 'C6';
    Cells[6, 0] := 'K2';
    Cells[7, 0] := 'K3';
    Cells[8, 0] := 'Design';
    Cells[9, 0] := 'Condition';
    ColWidths[0] := 120;
    for i := 1 to 7 do
      ColWidths[i] := 24;
    ColWidths[8] := 40;
    ColWidths[9] := 146;
  end;

  with jsgFiles do
  begin
    Cells[0, 0] := 'Name';
    Cells[1, 0] := 'D5';
    Cells[2, 0] := 'D6';
    Cells[3, 0] := 'D7';
    Cells[4, 0] := 'C5';
    Cells[5, 0] := 'C6';
    Cells[6, 0] := 'K2';
    Cells[7, 0] := 'K3';
    Cells[8, 0] := 'Form name';
    Cells[9, 0] := 'Condition';
    ColWidths[0] := 120;
    for i := 1 to 7 do
      ColWidths[i] := 24;
    ColWidths[8] := 86;
    ColWidths[9] := 100;
  end;

  // Load the list of packages
  LoadPackagesList;
end;

procedure TfrmMain.jsgDependenciesGetCellAlignment(Sender: TJvStringGrid;
  AColumn, ARow: Integer; State: TGridDrawState;
  var CellAlignment: TAlignment);
begin
  if AColumn = 0 then
    CellAlignment := taLeftJustify
  else
    CellAlignment := taCenter;
end;

procedure TfrmMain.jsgDependenciesExitCell(Sender: TJvStringGrid; AColumn,
  ARow: Integer; const EditText: String);
var
  row : TStrings;
  ColIndex : Integer;
begin
  if AColumn = 0 then
  begin
    if (Sender.RowCount > 2) and
       (Sender.Cells[0, ARow] = '') and
       (ARow < Sender.RowCount-1) then
      Sender.RemoveRow(ARow);

    if (Sender.RowCount > 1) and
       (Sender.Cells[0, Sender.RowCount-1] <> '') then
    begin
      Sender.InsertRow(Sender.RowCount);
      row := Sender.Rows[ARow];
      for ColIndex := 1 to 7 do
        row[ColIndex] := 'y';
      if rbtDesign.Checked and (Sender = jsgDependencies) then
        row[8] := 'y';
    end; 
  end;
end;

procedure TfrmMain.actAddFilesExecute(Sender: TObject);
var
  i : Integer;
  ColIndex : Integer;
  Name : string;
  PackagesDir : string;
  Dir : string;
  row : TStrings;
  dfm : textfile;
  line : string;
begin
  if odlAddFiles.Execute then
  begin
    if PathIsAbsolute(jdePackagesLocation.Text) then
      PackagesDir := jdePackagesLocation.Text
    else
      PackagesDir := PathNoInsideRelative(StrEnsureSuffix('\', extractfilepath(Application.exename))+jdePackagesLocation.Text);
    for i := 0 to odlAddFiles.Files.Count-1 do
    begin
      row := jsgFiles.InsertRow(jsgFiles.RowCount-1);
      Name := odlAddFiles.Files[i];
      Dir := GetRelativePath(PackagesDir, ExtractFilePath(Name));
      row[0] := '..\' + StrEnsureSuffix('\', Dir) + ExtractFileName(Name);
      for ColIndex := 1 to 7 do
        row[ColIndex] := 'y';

      // try to find if there is a dfm associated with the file
      // if there is one, open it and read the first line to get the
      // name of the form inside it
      if FileExists(ChangeFileExt(Name, '.dfm')) then
      begin
        AssignFile(dfm, ChangeFileExt(Name, '.dfm'));
        Reset(dfm);
        ReadLn(dfm, line);
        row[8] := Copy(line, Pos(' ', line)+1, Pos(':', line)-Pos(' ', line)-1);
        CloseFile(dfm);
      end;
    end;
    Changed := True;
  end;
end;

procedure TfrmMain.actSaveUpdate(Sender: TObject);
begin
  actSave.Enabled := (ledName.Text <> '') and Changed;
end;

procedure TfrmMain.ledC6PFlagsChange(Sender: TObject);
begin
  Changed := True;
end;

procedure TfrmMain.ledC5PFlagsChange(Sender: TObject);
begin
  Changed := True;
end;

procedure TfrmMain.jsgFilesSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  Changed := True;
end;

procedure TfrmMain.jsgDependenciesSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  Changed := True;
end;

procedure TfrmMain.ledDescriptionChange(Sender: TObject);
begin
  Changed := True;
end;

procedure TfrmMain.ledNameChange(Sender: TObject);
begin
  Changed := True;
end;

procedure TfrmMain.rbtDesignClick(Sender: TObject);
begin
  Changed := True;
end;

procedure TfrmMain.rbtRuntimeClick(Sender: TObject);
begin
  Changed := True;
end;

procedure TfrmMain.LoadPackagesList;
var
  rec : TSearchRec;
begin
  jlbList.Clear;
  if FindFirst(jdePackagesLocation.Text+'\xml\*.xml', 0, rec) = 0 then
  begin
    repeat
      jlbList.Items.Add(PathExtractFileNameNoExt(rec.Name));
    until FindNext(rec) <> 0;
  end;
  FindClose(rec);
  jlbList.ItemIndex := 0;
  LoadPackage;
end;

procedure TfrmMain.actSaveExecute(Sender: TObject);
var
  xml : TJvSimpleXml;
  i : Integer;
  j : Integer;
  FileName : string;
  propname : string;
  row : TStrings;
  rootNode : TJvSimpleXmlElemClassic;
  requiredNode : TJvSimpleXmlElem;
  packageNode : TJvSimpleXmlElem;
  filesNode : TJvSimpleXmlElem;
  fileNode : TJvSimpleXmlElem;
begin
  if PathIsAbsolute(jdePackagesLocation.Text) then
    FileName := jdePackagesLocation.Text
  else
    FileName := PathNoInsideRelative(StrEnsureSuffix('\', GetCurrentDir) + jdePackagesLocation.Text);
  FileName := FileName + '\xml\' + ledName.Text;
  if rbtDesign.Checked then
    FileName := FileName + '-D.xml'
  else
    FileName := FileName + '-R.xml';
  xml := TJvSimpleXml.Create(nil);
  try
    with xml do
    begin
      Options := [sxoAutoCreate, sxoAutoIndent];
      IndentString := '  ';

      // create root node
      Root.Name := 'Package';
      rootNode := xml.Root;
      rootNode.Properties.Add('Name', ledName.Text);
      rootNode.Properties.Add('Design', rbtDesign.Checked);

      // add description, and PFLAGS
      rootNode.Items.Add('Description', ledDescription.Text);
      rootNode.Items.Add('C5PFlags', ledC5PFlags.Text);
      rootNode.Items.Add('C6PFlags', ledC6PFlags.Text);

      // add required packages
      requiredNode := rootNode.Items.Add('Requires');
      for i := 1 to jsgDependencies.RowCount-2 do
      begin
        row := jsgDependencies.Rows[i];
        packageNode := requiredNode.Items.Add('Package');
        for j := 0 to row.Count - 1 do
        begin
          packageNode.Properties.Add(jsgDependencies.Rows[0][j], row[j]);
        end;
      end;

      // add files
      filesNode := rootNode.Items.Add('Contains');
      for i := 1 to jsgFiles.RowCount-2 do
      begin
        row := jsgFiles.Rows[i];
        fileNode := filesNode.Items.Add('File');
        for j := 0 to row.Count - 1 do
        begin
          propname := jsgFiles.Rows[0][j];
          StrReplace(propname, ' ', '', [rfReplaceAll]);
          fileNode.Properties.Add(propname, row[j]);
        end;
      end;
    end;
    // save into file
    xml.SaveToFile(fileName);
  finally
    xml.Free;
  end;

  // reload package list
  LoadPackagesList;  
end;

procedure TfrmMain.actPrevPackageUpdate(Sender: TObject);
begin
  actPrevPackage.Enabled := jlbList.ItemIndex > 0;
end;

procedure TfrmMain.actNextPackageUpdate(Sender: TObject);
begin
  actNextPackage.Enabled := (jlbList.ItemIndex > -1) and
                            (jlbList.ItemIndex < jlbList.Count-1);
end;

procedure TfrmMain.LoadPackage;
var
  xml : TJvSimpleXml;
  i : Integer;
  j : Integer;
  xmlFileName : string;
  propname : string;
  row : TStrings;
  rootNode : TJvSimpleXmlElemClassic;
  requiredNode : TJvSimpleXmlElem;
  packageNode : TJvSimpleXmlElem;
  filesNode : TJvSimpleXmlElem;
  fileNode : TJvSimpleXmlElem;
begin
  if PathIsAbsolute(jdePackagesLocation.Text) then
    xmlFileName := jdePackagesLocation.Text
  else
    xmlFileName := PathNoInsideRelative(StrEnsureSuffix('\', GetCurrentDir) + jdePackagesLocation.Text);
  xmlFileName := xmlFileName + '\xml\';
  if rbtDesign.Checked then
    xmlFileName := xmlFileName + jlbList.Items[jlbList.ItemIndex] + '.xml'
  else
    xmlFileName := xmlFileName + jlbList.Items[jlbList.ItemIndex] + '.xml';
  xml := TJvSimpleXml.Create(nil);
  try
    with xml do
    begin
      Options := [sxoAutoCreate];

      LoadFromFile(xmlFileName);

      // read root node
      rootNode := xml.Root;
      ledName.Text      := rootNode.Properties.ItemNamed['Name'].Value;
      rbtDesign.Checked := rootNode.Properties.ItemNamed['Design'].BoolValue;
      rbtRuntime.Checked := not rbtDesign.Checked;

      // read description, and PFLAGS
      ledDescription.Text := rootNode.Items.ItemNamed['Description'].Value;
      ledC5PFlags.Text    := rootNode.Items.ItemNamed['C5PFlags'].Value;
      ledC6PFlags.Text    := rootNode.Items.ItemNamed['C6PFlags'].Value;

      // read required packages
      jsgDependencies.RowCount := 2;
      jsgDependencies.Rows[1].Text := '';
      requiredNode := rootNode.Items.ItemNamed['Requires'];
      for i := 0 to requiredNode.Items.Count - 1 do
      begin
        row := jsgDependencies.InsertRow(jsgDependencies.RowCount-1);
        packageNode := requiredNode.Items.ItemNamed['Package'];
        for j := 0 to row.Count - 1 do
        begin
          row[j] := packageNode.Properties.ItemNamed[jsgDependencies.Rows[0][j]].Value;
        end;
      end;

      // read files
      jsgFiles.RowCount := 2;
      jsgFiles.Rows[1].Text := '';
      filesNode := rootNode.Items.ItemNamed['Contains'];
      for i := 0 to filesNode.Items.Count - 1 do
      begin
        row := jsgFiles.InsertRow(jsgFiles.RowCount-1);
        fileNode := filesNode.Items.ItemNamed['File'];
        for j := 0 to row.Count - 1 do
        begin
          propname := jsgFiles.Rows[0][j];
          StrReplace(propname, ' ', '', [rfReplaceAll]);
          row[j] := fileNode.Properties.ItemNamed[propname].Value;
        end;
      end;
    end;
    Changed := False;
  finally
    xml.Free;
  end;
end;

procedure TfrmMain.jlbListClick(Sender: TObject);
begin
  LoadPackage;
end;

procedure TfrmMain.actGenerateExecute(Sender: TObject);
begin
//
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Shift = [ssCtrl] then
  begin
    case Key of
      VK_UP:
        begin
          if actPrevPackage.Enabled then
            actPrevPackage.Execute;
          Key := 0;
        end;
      VK_DOWN:
        begin
          if actNextPackage.Enabled then
            actNextPackage.Execute;
          Key := 0;
        end;
    end;
  end;
end;

procedure TfrmMain.actPrevPackageExecute(Sender: TObject);
begin
  jlbList.ItemIndex := jlbList.ItemIndex - 1;
  LoadPackage;
end;

procedure TfrmMain.actNextPackageExecute(Sender: TObject);
begin
  jlbList.ItemIndex := jlbList.ItemIndex + 1;
  LoadPackage;
end;

end.
