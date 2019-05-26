unit MainForm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  OpenGL,
  System.Classes, Vcl.Graphics,
  ExtCtrls,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TForm5 = class(TForm)
    procedure FormPaint(Sender: TObject);
  private
    { Private 宣言 }
    DC: HDC; { デバイスコンテキスト }
    RC: HGLRC; { レンダリングコンテキスト }
  public
    { Public 宣言 }
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

var
  pfd : Winapi.Windows.TPixelFormatDescriptor = (
    nSize:           sizeof(TPixelFormatDescriptor);
    nVersion:        1;
    dwFlags:         PFD_DRAW_TO_WINDOW
                     or PFD_SUPPORT_OPENGL
                     or PFD_DOUBLEBUFFER;
    iPixelType:      PFD_TYPE_RGBA;
    cColorBits:      24;
    cRedBits:        0;
    cRedShift:       0;
    cGreenBits:      0;
    cGreenShift:     0;
    cBlueBits:       0;
    cBlueShift:      0;
    cAlphaBits:      0;
    cAlphaShift:     0;
    cAccumBits:      0;
    cAccumRedBits:   0;
    cAccumGreenBits: 0;
    cAccumBlueBits:  0;
    cAccumAlphaBits: 0;
    cDepthBits:      32;
    cStencilBits:    0;
    cAuxBuffers:     0;
    iLayerType:      PFD_MAIN_PLANE;
    bReserved:       0;
    dwLayerMask:     0;
    dwVisibleMask:   0;
    dwDamageMask:    0;
  );

procedure TForm5.AfterConstruction;
var
  nPixelFormat: integer;
  success: boolean;
begin
  DC := GetDC(Handle); //フォームのDCを取得
  nPixelFormat := ChoosePixelFormat(DC, @pfd);
  // 要求されているフォーマットにもっとも近いピクセルフォーマットのインデックスを取得
  success := SetPixelFormat(DC, nPixelFormat, @pfd); // ピクセルフォーマットを設定する
  RC := wglCreateContext(DC); // RC 生成
end;

procedure TForm5.BeforeDestruction;
begin
  inherited;
  wglDeleteContext(RC); //RC 解放
end;

procedure TForm5.FormPaint(Sender: TObject);
begin
  wglMakeCurrent(DC, RC);
  glClearColor(0.0, 0.0, 0.0, 0.0); { 背景色の設定(左からRGBA) 黒 }
  glClear(GL_COLOR_BUFFER_BIT); { 画面をクリアする }
  glBegin(GL_POLYGON); { ポリゴンを描画開始 }
  glColor3f(1.0, 1.0, 1.0); { 色の設定 範囲は0.0~1.0 (左からRGB)白 }
  glVertex2f(-0.5, -0.4); { 頂点の設定 二点(x,y)を指定 }
  glVertex2f(+0.5, -0.4); { 同上 三点指定でないため平面画像である }
  glVertex2f(0.0, +0.4); { 同上 三つの頂点を結び、面として描画 }
  glEnd(); { 描画終了 }
  glFlush(); { 今までのOpenGL命令を全て実行 }
  SwapBuffers(DC); { ダブルバッファを使って画面を書き換える }
  { ダブルバッファを使う場合、必須である }
  wglMakeCurrent(DC, 0);
end;

end.
