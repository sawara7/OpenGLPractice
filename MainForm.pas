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
    { Private �錾 }
    DC: HDC; { �f�o�C�X�R���e�L�X�g }
    RC: HGLRC; { �����_�����O�R���e�L�X�g }
  public
    { Public �錾 }
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
  DC := GetDC(Handle); //�t�H�[����DC���擾
  nPixelFormat := ChoosePixelFormat(DC, @pfd);
  // �v������Ă���t�H�[�}�b�g�ɂ����Ƃ��߂��s�N�Z���t�H�[�}�b�g�̃C���f�b�N�X���擾
  success := SetPixelFormat(DC, nPixelFormat, @pfd); // �s�N�Z���t�H�[�}�b�g��ݒ肷��
  RC := wglCreateContext(DC); // RC ����
end;

procedure TForm5.BeforeDestruction;
begin
  inherited;
  wglDeleteContext(RC); //RC ���
end;

procedure TForm5.FormPaint(Sender: TObject);
begin
  wglMakeCurrent(DC, RC);
  glClearColor(0.0, 0.0, 0.0, 0.0); { �w�i�F�̐ݒ�(������RGBA) �� }
  glClear(GL_COLOR_BUFFER_BIT); { ��ʂ��N���A���� }
  glBegin(GL_POLYGON); { �|���S����`��J�n }
  glColor3f(1.0, 1.0, 1.0); { �F�̐ݒ� �͈͂�0.0~1.0 (������RGB)�� }
  glVertex2f(-0.5, -0.4); { ���_�̐ݒ� ��_(x,y)���w�� }
  glVertex2f(+0.5, -0.4); { ���� �O�_�w��łȂ����ߕ��ʉ摜�ł��� }
  glVertex2f(0.0, +0.4); { ���� �O�̒��_�����сA�ʂƂ��ĕ`�� }
  glEnd(); { �`��I�� }
  glFlush(); { ���܂ł�OpenGL���߂�S�Ď��s }
  SwapBuffers(DC); { �_�u���o�b�t�@���g���ĉ�ʂ����������� }
  { �_�u���o�b�t�@���g���ꍇ�A�K�{�ł��� }
  wglMakeCurrent(DC, 0);
end;

end.
