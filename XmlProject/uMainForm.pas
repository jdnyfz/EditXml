unit uMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, XMLIntf, XMLDoc, Vcl.StdCtrls,
  AdvCardList, Vcl.PlatformDefaultStyleActnCtrls, System.Actions, Vcl.ActnList,
  Vcl.ActnMan, Vcl.ToolWin, Vcl.ActnCtrls, Vcl.Menus, Vcl.ComCtrls, Vcl.ExtCtrls,
  SynEdit, SynMemo, SynEditHighlighter, SynHighlighterXML, Vcl.ImgList,
  Vcl.Grids, SynEditPythonBehaviour, SynEditMiscClasses, SynEditSearch,SynEditTypes,
  Vcl.Buttons;

type
  TfmMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Edit1: TMenuItem;
    Search1: TMenuItem;
    ools1: TMenuItem;
    Help1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    pnlTool: TPanel;
    Image1: TImage;
    pmlPath: TPanel;
    Panel2: TPanel;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    pnlMain: TPanel;
    pmlLeft: TPanel;
    pnlList: TPanel;
    pnlProperty: TPanel;
    SynMemo1: TSynMemo;
    SynXMLSyn1: TSynXMLSyn;
    Label1: TLabel;
    ToolButton4: TToolButton;
    dlgOpen: TOpenDialog;
    tvNode: TTreeView;
    ImageList1: TImageList;
    lvProperty: TStringGrid;
    SynEditSearch1: TSynEditSearch;
    BitBtn1: TBitBtn;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    FindDialog1: TFindDialog;
    ReplaceDialog1: TReplaceDialog;
    ToolButton7: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure tvNodeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure lvPropertyKeyPress(Sender: TObject; var Key: Char);
    procedure ToolButton6Click(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);
    procedure N10Click(Sender: TObject);
  private
    { Private declarations }
    FXMLDocument :IXMLDocument;
    SelectNode: IXMLNode;
    SelectTreeNode: TTreeNode;
    m_sschOption: TSynSearchOptions;
    //添加节点 --修改节点---删除节点
    procedure AddNode(ParentNode: IXMLNode; AName: string);
    procedure EditNode(CNode: IXMLNode; AValue: string); //
    procedure DeleteNode(CNode: IXMLNode);
    //添加属性--修改属性--删除属性
    procedure EditAttribute(CNode: IXMLNode; AName, AValue: string);
    procedure DeleteAttribute(CNode: IXMLNode);

    //保存文件
    procedure SaveAndReOpen();
  public
    { Public declarations }
    procedure Open(FilePath: string);
    procedure ShowNodeList(ARootNode: IXMLNode);

  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

{ TForm1 }

procedure TfmMain.AddNode(ParentNode: IXMLNode; AName: string);
var
  tNode: IXMLNode;
begin
  tNode := ParentNode.AddChild(AName);
  tNode.Text := '';

  tvNode.Items.AddNode(nil, SelectTreeNode, AName, Pointer(tNode), naAddChild);
  FXMLDocument.SaveToFile(pmlPath.Caption);
end;

procedure TfmMain.BitBtn1Click(Sender: TObject);
begin
  tvNode.FullExpand;
end;

procedure TfmMain.DeleteAttribute(CNode: IXMLNode);
var
  TempNodeList: IXMLNodeList;
  i: integer;
begin
  TempNodeList := CNode.AttributeNodes;
  TempNodeList.Delete(TempNodeList.IndexOf(lvProperty.Cells[0,lvProperty.Row]));
   //显示属性
    TempNodeList := SelectNode.GetAttributeNodes;
    lvProperty.RowCount := TempNodeList.Count + 1;
    for I := 0 to TempNodeList.Count - 1 do
    begin

      lvProperty.Cells[0,i + 1] := TempNodeList[i].NodeName;
      if(TempNodeList[i].NodeValue) = null then
        lvProperty.Cells[1,i + 1] := ''
      else
        lvProperty.Cells[1,i + 1] := TempNodeList[i].NodeValue;
    end;
end;

procedure TfmMain.DeleteNode(CNode: IXMLNode);
var
  ParentNode: IXMLNode;
  NodeList: IXMLNodeList;
begin
  ParentNode := CNode.ParentNode;
  NodeList := ParentNode.ChildNodes;
  NodeList.Delete(NodeList.IndexOf(CNode));

  SaveAndReOpen;
end;

procedure TfmMain.EditAttribute(CNode: IXMLNode; AName, AValue: string);
begin
  CNode.Attributes[AName] := AValue;
  SaveAndReOpen;
end;

procedure TfmMain.EditNode(CNode: IXMLNode; AValue: string);
begin
  CNode.NodeValue := AValue;
  FXMLDocument.SaveToFile(pmlPath.Caption);
end;

procedure TfmMain.FindDialog1Find(Sender: TObject);
begin
   if (frMatchCase in FindDialog1.Options) then
   begin
     m_sschOption := m_sschOption + [ssoMatchCase];
   end;

   if (frWholeWord in FindDialog1.Options) then
   begin
     m_sschOption :=m_sschOption +  [ssoWholeWord];
   end;

   if (frDown in FindDialog1.Options) then
   begin
     m_sschOption :=m_sschOption +  [ssoBackwards];
   end;

   SynEditSearch1.Pattern := '^';
   SynEditSearch1.FindAll(FindDialog1.FindText);
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  FXMLDocument :=TXMLDocument.Create(nil);
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  FXMLDocument := nil;
end;

procedure TfmMain.FormShow(Sender: TObject);
begin
  lvProperty.Cells[0,0] := '名称';
  lvProperty.Cells[1,0] := '属性';
end;

procedure TfmMain.lvPropertyKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    EditAttribute(SelectNode, lvProperty.Cells[0,lvProperty.Row] ,lvProperty.Cells[1,lvProperty.Row]);
    SaveAndReOpen();
  end;
end;

procedure TfmMain.N10Click(Sender: TObject);
begin
  FindDialog1.Execute();
end;

procedure TfmMain.N2Click(Sender: TObject);
var
  LFilePath: string;
begin
  if dlgOpen.Execute then
  begin
    LFilePath:=dlgOpen.FileName;
    open(LFilePath);
    pmlPath.Caption := LFilePath;
  end;
end;

procedure TfmMain.Open(FilePath: string);
var
  LRootNode: IXMLNode;
  LCount: integer;

begin
  try
    FXMLDocument.LoadFromFile(FilePath);
    FXMLDocument.Active := true;

    LRootNode := FXMLDocument.DocumentElement;
    //遍历 xml节点
    LCount := LRootNode.ChildNodes.Count;
    SynMemo1.Lines.LoadFromFile(FilePath, TEncoding.UTF8);
    //
    ShowNodeList(LRootNode);

  except on e: exception do
    showmessage(e.Message);
  end;
end;

procedure TfmMain.SaveAndReOpen;
begin
  FXMLDocument.SaveToFile(pmlPath.Caption);
  SynMemo1.Lines.LoadFromFile(pmlPath.Caption, TEncoding.UTF8);
 // FXMLDocument.Refresh;
end;

procedure TfmMain.ShowNodeList(ARootNode: IXMLNode);
  function GetNode(nNode: IXMLNode; TNode: TTreeNode):boolean;
  var
    LName: string;
    CurTreeNode: TTreeNode;
    i: integer;
  begin
    LName := '<'+ nNode.NodeName +'>';
    if nNode.IsTextElement  then
    begin
      //CurTreeNode := tvNode.Items.AddChild(TNode, LName);
      CurTreeNode := tvNode.Items.AddNode(nil, TNode, LName, Pointer(nNode), naAddChild);
    end
    else
    begin
      if nNode.HasChildNodes then
      begin
        //CurTreeNode := tvNode.Items.AddChild(TNode, LName);
        CurTreeNode := tvNode.Items.AddNode(nil, TNode, LName, Pointer(nNode), naAddChild);
        for i:=0 to nNode.ChildNodes.Count-1 do
        begin
          GetNode(nNode.ChildNodes.Nodes[i], CurTreeNode);
        end;
      end
      else
      begin
        CurTreeNode := tvNode.Items.AddNode(nil, TNode, LName, Pointer(nNode), naAddChild);
      end;
    end;
  end;
var
  i, j: integer;
  RootTree: TTreeNode;
begin
  //
  tvNode.Items.Clear;
  RootTree := tvNode.Items.AddFirst(nil, 'xml');

  tvNode.Items.BeginUpdate;
  GetNode(ARootNode,RootTree);
  tvNode.Items.EndUpdate;
end;

procedure TfmMain.ToolButton1Click(Sender: TObject);
var
  s: string;
begin
  if InputQuery('节点','节点名称',s) then
  begin
    if s<>'' then //如果输入不为空则
      AddNode(SelectNode,s);
  end;
end;

procedure TfmMain.ToolButton2Click(Sender: TObject);
var
  s: string;
begin
  if InputQuery('节点','节点值',s) then
  begin
    if s<>'' then //如果输入不为空则
      EditNode(SelectNode,s);
  end;
end;

procedure TfmMain.ToolButton3Click(Sender: TObject);
begin
  DeleteNode(SelectNode);
  tvNode.Selected.Delete;
end;

procedure TfmMain.ToolButton4Click(Sender: TObject);
var
  lname: string;
  i: integer;
  Node:TTreeNode;
begin
  if InputQuery('节点','节点名称',lname) then
  begin
    tvNode.SetFocus;
    for i:=0 to tvNode.Items.Count-1 do
    begin
      if pos(lname,tvNode.Items.Item[i].Text) > 0 then
      begin
        Node:=tvNode.Items.Item[i];
        tvNode.Select(Node);    //选中焦点
        Exit;
      end;
  end;
  end;
end;

procedure TfmMain.ToolButton5Click(Sender: TObject);
var
  lname: string;
begin
  if InputQuery('属性','属性名称',lname) then
  begin
    lvProperty.RowCount := lvProperty.RowCount + 1;
    lvProperty.Cells[0, lvProperty.RowCount - 1] := lname;
    EditAttribute(SelectNode,lname,'');
  end;
end;

procedure TfmMain.ToolButton6Click(Sender: TObject);
begin
  DeleteAttribute(Selectnode);
end;

procedure TfmMain.tvNodeClick(Sender: TObject);
var
  pItem:TTreeNode;
  Name: string;
  i,j: integer;
  AttList: IXMLNodeList;
  node :TxmlNode;
begin
  pItem:=tvNode.Selected;
  SelectTreeNode := pItem;  //
  if pItem = nil then
    exit;

  if pItem.Data <> nil then
  begin
    SelectNode := IXMLNode(pItem.Data);
    self.Caption:= SelectNode.NodeName;
    for j := 1 to lvProperty.RowCount  do
    begin
      lvProperty.Rows[j].Clear;
    end;

    //显示值
    if SelectNode.IsTextElement then
    begin
      lvProperty.RowCount := 2;
      lvProperty.Cells[0,1] := '#text';
      lvProperty.Cells[1,1] := SelectNode.Text;
      exit;
    end;
    //显示属性
    AttList := SelectNode.GetAttributeNodes;
    lvProperty.RowCount := AttList.Count + 1;
    for I := 0 to AttList.Count - 1 do
    begin

      lvProperty.Cells[0,i + 1] := AttList[i].NodeName;
      if(AttList[i].NodeValue) = null then
        lvProperty.Cells[1,i + 1] := ''
      else
        lvProperty.Cells[1,i + 1] := AttList[i].NodeValue;
    end;
  end;

end;

end.
