program dtrello.demo;

uses
  Vcl.Forms,
  dtrello.demo.principal in 'dtrello.demo.principal.pas' {dtrello_demo_principal};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tdtrello_demo_principal, dtrello_demo_principal);
  Application.Run;
end.
